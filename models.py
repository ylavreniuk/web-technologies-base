from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, ForeignKey, Table
from database import Base
# Database Models


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    items = relationship("Item", back_populates="owner")


item_tag = Table(
    "item_tag",
    Base.metadata,
    Column("item_id", Integer, ForeignKey("items.id"), primary_key=True),
    Column("tag_id", Integer, ForeignKey("tags.id"), primary_key=True),
)


class Item(Base):
    __tablename__ = "items"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="items")
    detail = relationship("Detail", uselist=False, back_populates="item")
    tags = relationship("Tag", secondary=item_tag, back_populates="items")


class Detail(Base):
    __tablename__ = "details"
    id = Column(Integer, primary_key=True, index=True)
    description = Column(String, index=True)
    item_id = Column(Integer, ForeignKey("items.id"), unique=True)
    item = relationship("Item", back_populates="detail")


class Tag(Base):
    __tablename__ = "tags"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    items = relationship("Item", secondary=item_tag, back_populates="tags")
