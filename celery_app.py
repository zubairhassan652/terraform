from celery import Celery
import os
import sys

REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379/0")

celery_app = Celery(
    "myapp",
    broker=REDIS_URL,
    backend=REDIS_URL,
    include=["tasks"]
)

celery_app.conf.update(
    task_serializer="json",
    result_serializer="json",
    accept_content=["json"],
    timezone="UTC",
    enable_utc=True,
)

if sys.platform == "win32":
    celery_app.conf.update(
        worker_pool="solo",        # ← use solo pool on Windows
    )