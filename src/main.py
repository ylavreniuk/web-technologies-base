from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from src.routes import router

app = FastAPI()

# Налаштування CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Дозволяє запити з будь-якого джерела
    allow_credentials=True,
    allow_methods=["*"],  # Дозволяє всі методи (GET, POST тощо)
    allow_headers=["*"],  # Дозволяє всі заголовки
)

app.mount("/static", StaticFiles(directory="src/static"), name="static")
app.include_router(router)