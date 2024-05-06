from pydantic import BaseModel


# StreamingResponseとか使うとリアルタイムにいける？
class ChatRequest(BaseModel):
    message: str
    # GPTのバージョンとか指定するのもいける


class ChatResponse(BaseModel):
    response_message: str
