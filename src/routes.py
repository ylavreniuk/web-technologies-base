from fastapi import Depends, HTTPException, Request, Form, APIRouter
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session

from src.config import templates
from src.dependencies import get_db
from src.models import User, Item, Tag, Detail

router = APIRouter()

@router.get("/profile")
def show_profile(request: Request):
    user_data = {
    "name": "User Userenko",
    "email": "user@example.com",
    "bio": "Розробник веб-застосунків",
    "role": "Admin"
    }
    return templates.TemplateResponse("profile.html", {"request": request,
    "user": user_data})


@router.get("/")
def home(request: Request, db: Session = Depends(get_db)):
    try:
        users = db.query(User).all()
        return templates.TemplateResponse(
            "users.html", {"request": request, "users": users}
        )
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.post("/users/create")
def create_user(name: str = Form(...), db: Session = Depends(get_db)):
    user = User(name=name)
    db.add(user)
    db.commit()
    return HTTPException(status_code=200, detail="User created")


@router.get("/items")
def list_items(request: Request, db: Session = Depends(get_db)):
    items = db.query(Item).all()
    return templates.TemplateResponse(
        "items.html", {"request": request, "items": items}
    )


@router.post("/items/create")
def create_item(
    name: str = Form(...), owner_id: int = Form(...), db: Session = Depends(get_db)
):
    item = Item(name=name, owner_id=owner_id)
    db.add(item)
    db.commit()
    return HTTPException(status_code=200, detail="Item created")


@router.get("/details")
def list_details(request: Request, db: Session = Depends(get_db)):
    details = db.query(Detail).all()
    return templates.TemplateResponse(
        "details.html", {"request": request, "details": details}
    )


@router.post("/details/create")
def create_detail(
    description: str = Form(...),
    item_id: int = Form(...),
    db: Session = Depends(get_db),
):
    detail = Detail(description=description, item_id=item_id)
    db.add(detail)
    db.commit()
    return HTTPException(status_code=200, detail="Detail created")


@router.get("/tags")
def list_tags(request: Request, db: Session = Depends(get_db)):
    tags = db.query(Tag).all()
    return templates.TemplateResponse("tags.html", {"request": request, "tags": tags})


@router.post("/tags/create")
def create_tag(name: str = Form(...), db: Session = Depends(get_db)):
    tag = Tag(name=name)
    db.add(tag)
    db.commit()
    return HTTPException(status_code=200, detail="Tag created")
