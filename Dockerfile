FROM python:3.8-slim

WORKDIR /app

COPY counter-service.py .

RUN pip install flask

EXPOSE 443

CMD ["python", "counter-service.py"]

