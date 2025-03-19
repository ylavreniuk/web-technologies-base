from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, ForeignKey, Table
from src.database import Base


def init_db(db):
    # Check if default users exist
    if not db.query(User).first():
        user1 = User(name="admin")
        user2 = User(name="guest")
        db.add_all([user1, user2])
        db.commit()

    # Check if default items exist
    if not db.query(Item).first():
        item1 = Item(name="Sample Item 1", owner_id=1)
        item2 = Item(name="Sample Item 2", owner_id=2)
        db.add_all([item1, item2])
        db.commit()

    # Check if default tags exist
    if not db.query(Tag).first():
        tag1 = Tag(name="Important")
        tag2 = Tag(name="Optional")
        db.add_all([tag1, tag2])
        db.commit()

    print("Database initialized with default data.")


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
