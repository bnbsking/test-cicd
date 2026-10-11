from fastapi import FastAPI


app = FastAPI()


@app.get("/")
def hello(name: str) -> str:
    return f"Hello, {name}!"
