from fastapi import APIRouter, Body

from api.models.task import ChatRequest, ChatResponse
from services.openai import get_chat_completion

router = APIRouter()


@router.post("/chat", response_class=ChatResponse)
def chat(request: ChatRequest = Body(...)):
    return ChatResponse(get_chat_completion(request.Request))


# 　ここをいじればタスクtreeとタスク生成してみようこんど
# 　firebaseからの現在のタスクの追加とかもここ
