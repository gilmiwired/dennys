from typing import List, Optional

from pydantic import BaseModel


# StreamingResponseとか使うとリアルタイムにいける？
class ChatRequest(BaseModel):
    message: str
    # GPTのバージョンとか指定するのもいける


class ChatResponse(BaseModel):
    response_message: str


class Task(BaseModel):
    id: int
    task: str
    children: Optional[List["Task"]] = None


Task.update_forward_refs()
