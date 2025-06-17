from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from src.routes import router

app = FastAPI()
app.mount("/static", StaticFiles(directory="src/static"), name="static")
app.include_router(router)
