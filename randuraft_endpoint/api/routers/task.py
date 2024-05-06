from fastapi import APIRouter

from api.models.task import ChatRequest, ChatResponse
from services.create_chat import get_chat_completion

router = APIRouter()


@router.post("/chat", response_model=ChatResponse)
def chat(request: ChatRequest):
    response_message = get_chat_completion(request.message)
    return ChatResponse(response_message=response_message)


# 　ここをいじればタスクtreeとタスク生成してみようこんど
# 　firebaseからの現在のタスクの追加とかもここ
