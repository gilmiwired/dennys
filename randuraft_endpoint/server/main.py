import uvicorn

from api.app import app


def start():
    uvicorn.run(app=app, host="0.0.0.0", port=8000, reload=True)
