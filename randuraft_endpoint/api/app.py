from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.routers.task import router as task

# TODO: Sentryとかのエラハンいれる
# TODO: Authいれる
app = FastAPI()
app.include_router(task)
origins = [
    "http://localhost:3000",
    "http://localhost:61435",  # FlutterのWebビルドが使用するポート
    "http://localhost",
]

# CORSの設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
