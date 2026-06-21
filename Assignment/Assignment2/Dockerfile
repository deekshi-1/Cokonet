# Stage 1 - Builder
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 - Final
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11

COPY . .

EXPOSE 5000

ENTRYPOINT ["python"]

CMD ["app.py"]
