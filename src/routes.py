from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

router = APIRouter()
templates = Jinja2Templates(directory="src/templates")

@router.get("/profile")
async def show_profile(request: Request):
    user_data = {
        "name": "User Userenko",
        "email": "user@example.com",
        "bio": "Розробник веб-застосунків",
        "role": "Admin"
    }
    return templates.TemplateResponse("profile.html", {"request": request, "user": user_data})
