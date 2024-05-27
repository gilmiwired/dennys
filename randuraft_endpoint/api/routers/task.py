import logging

from fastapi import APIRouter

from api.models.task import ChatRequest, ChatResponse
from services.create_task import create_content_using_openai

router = APIRouter()
logger = logging.getLogger(__name__)


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    logger.info(f"Received message: {request.message}")
    try:
        response_message = create_content_using_openai(request.message)
        logger.info(f"Processed message: {response_message}")
        return ChatResponse(response_message=response_message)
    except Exception as e:
        logger.error(f"Error processing message: {e}")
        raise


# 　ここをいじればタスクtreeとタスク生成してみようこんど
# 　firebaseからの現在のタスクの追加とかもここ
