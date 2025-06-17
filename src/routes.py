from fastapi import APIRouter, Request, HTTPException
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel, EmailStr
from fastapi import APIRouter, Request, HTTPException
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel, EmailStr

router = APIRouter()
templates = Jinja2Templates(directory="src/templates")

class EmailRequest(BaseModel):
    email: EmailStr

@router.get("/profile")
async def show_profile(request: Request):
    user_data = {
        "name": "User Userenko",
        "email": "user@example.com",
        "bio": "Розробник веб-застосунків",
        "role": "Admin"
    }
    return templates.TemplateResponse("profile.html", {"request": request, "user": user_data})

@router.post("/api/message")
async def send_message(email_request: EmailRequest):
    return {"message": f"Email {email_request.email} успішно отримано!"}