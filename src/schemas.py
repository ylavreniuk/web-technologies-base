from pydantic import BaseModel, EmailStr

class UserSubmission(BaseModel):
    name: str
    email: EmailStr
    message: str

class UserCreate(BaseModel):
    username: str
    password: str