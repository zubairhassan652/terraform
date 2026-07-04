import os
import redis
from celery.result import AsyncResult

from fastapi import FastAPI

from tasks import say_hello  # Import the Celery task
from celery_app import celery_app


app = FastAPI()

REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379/0")

# Direct redis client (optional — for caching, rate limiting etc.)
redis_client = redis.from_url(REDIS_URL)

@app.get("/cache-test")
def cache_test():
    redis_client.set("hello", "world", ex=60)  # store with 60s TTL
    value = redis_client.get("hello")
    return {"cached_value": value.decode()}


# ── Async endpoint (offloads to Celery worker) ────────────────
@app.post("/hello/async")
def hello_async(name: str = "World"):
    """
    Sends task to Celery worker — returns task_id immediately
    without waiting for result.
    """
    task = say_hello.delay(name)
    return {
        "task_id": task.id,
        "status": "submitted",
        "message": f"Task submitted! Check result at /tasks/{task.id}"
    }

@app.get("/tasks/{task_id}")
def get_task_result(task_id: str):
    """
    Poll this endpoint to check task status and result.
    """
    result = AsyncResult(task_id, app=celery_app)

    return {
        "task_id": task_id,
        "status": result.status,
        # PENDING   → task not started yet
        # STARTED   → worker picked it up
        # SUCCESS   → done, result available
        # FAILURE   → something went wrong
        "result": result.result if result.ready() else None,
        "ready": result.ready()
    }


@app.get("/")
async def root():
    return {"message": "Hello World"}