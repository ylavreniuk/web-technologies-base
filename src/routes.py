from fastapi import APIRouter, Request, Depends, HTTPException, status
from fastapi.templating import Jinja2Templates
from fastapi.security import OAuth2PasswordRequestForm, OAuth2PasswordBearer
from sqlalchemy.orm import Session
from src.schemas import UserSubmission, UserCreate
from src.services.form_handler import handle_submission
from src.database import SessionLocal
from src.models import User
from src.auth import hash_password, verify_password, create_access_token, get_current_user

router = APIRouter()
templates = Jinja2Templates(directory="src/templates")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/register")
async def show_register(request: Request):
    return templates.TemplateResponse("register.html", {"request": request})

@router.get("/login")
async def show_login(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

@router.get("/profile")
async def show_profile(request: Request, current_user: str = Depends(oauth2_scheme)):
    return templates.TemplateResponse("profile.html", {"request": request})

@router.post("/api/submit")
async def submit_form(data: UserSubmission):
    response = handle_submission(data)
    return {"status": "success", "data": data, "message": response["message"]}

@router.get("/api/users")
async def get_users(db: Session = Depends(get_db)):
    users = db.query(User).all()
    return [
        {
            "id": user.id,
            "username": user.username,
            "bio": user.profile.bio if user.profile else "No bio",
            "posts": [post.title for post in user.posts]
        }
        for user in users
    ]

@router.post("/register")
async def register(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.username == user.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    hashed = hash_password(user.password)
    db_user = User(username=user.username, hashed_password=hashed)
    db.add(db_user)
    db.commit()
    return {"msg": "User created"}

@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Invalid credentials")
    token = create_access_token({"sub": user.username})
    return {"access_token": token, "token_type": "bearer"}

@router.get("/api/profile")
async def read_profile(current_user: str = Depends(oauth2_scheme)):
    return {"username": current_user}