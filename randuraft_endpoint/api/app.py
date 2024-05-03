from fastapi import FastAPI

from api.routers.task import router as task

# TODO: Sentryとかのエラハンいれる
# TODO: Authいれる
app = FastAPI()
app.include_router(task)
