from pydantic import BaseModel, EmailStr

class UserSubmission(BaseModel):
    name: str
    email: EmailStr
    message: str