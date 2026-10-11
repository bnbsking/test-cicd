FROM python:3.12-slim

RUN apt update && apt install vim -y

RUN pip install requests openai
