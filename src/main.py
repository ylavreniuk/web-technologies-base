from fastapi import FastAPI
from src.database import engine, Base
from src.routes import router
from src.config import static_files
from src.models import init_db
from src.database import SessionLocal

app = FastAPI()
app.mount("/static", static_files, name="static")
app.include_router(router)

Base.metadata.create_all(bind=engine)

with SessionLocal() as db:
    init_db(db)
