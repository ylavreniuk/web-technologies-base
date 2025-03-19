from pydantic import BaseModel
# Pydantic Schemas


class UserCreate(BaseModel):
    name: str


class ItemCreate(BaseModel):
    name: str
    owner_id: int


class DetailCreate(BaseModel):
    description: str
    item_id: int


class TagCreate(BaseModel):
    name: str
