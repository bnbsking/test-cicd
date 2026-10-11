FROM python:3.12-slim

ENV PIP_DEFAULT_TIMEOUT=86400

RUN apt update && apt install -y \
    vim \
    curl \
    procps

WORKDIR /app
COPY . /app

RUN pip install requests fastapi uvicorn python-multipart
