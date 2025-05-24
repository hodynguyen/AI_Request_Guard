from fastapi import FastAPI
from pydantic import BaseModel
from model import is_malicious

app = FastAPI()

class RequestData(BaseModel):
    method: str
    path: str
    args: dict

@app.post("/predict")
def predict(data: RequestData):
    if is_malicious(data.path, data.args):
        return {"decision": "block"}
    return {"decision": "allow"}
