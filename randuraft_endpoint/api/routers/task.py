import logging
from typing import List

from fastapi import APIRouter

from api.models.task import ChatRequest, ChatResponse, Task
from services.create_task import create_content_using_openai
from services.saving.test_data import TEST_TASK_TREE

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


@router.post("/test/task", response_model=List[Task])
async def fetch_test_task():
    logger.info("test-task")
    logger.info(f"{TEST_TASK_TREE}")
    return TEST_TASK_TREE


#  TODO タスクツリー取得用のエンドポイント
#  from services.create_task import create_task_tree
