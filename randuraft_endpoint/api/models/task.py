from pydantic import BaseModel


# StreamingResponseとか使うとリアルタイムにいける？
class ChatRequest(BaseModel):
    Request: str
    # GPTのバージョンとか指定するのもいける


class ChatResponse(BaseModel):
    Response: str
