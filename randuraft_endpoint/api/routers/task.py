from fastapi import APIRouter, Body

from api.models.task import ChatRequest, ChatResponse
from randuraft_endpoint.services.create_chat import get_chat_completion

router = APIRouter()


@router.post("/chat", response_class=ChatResponse)
def chat(request: ChatRequest = Body(...))->ChatResponse:
    return ChatResponse(response_message=get_chat_completion(request.message))


# 　ここをいじればタスクtreeとタスク生成してみようこんど
# 　firebaseからの現在のタスクの追加とかもここ
