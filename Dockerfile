ARG PYTHON_VERSION=3.13

FROM python:${PYTHON_VERSION}-slim AS builder

WORKDIR /app

COPY requirements.txt ./

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

FROM python:${PYTHON_VERSION}-slim

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

COPY . .

EXPOSE 8080

CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8080"]
