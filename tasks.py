from celery_app import celery_app
import time

@celery_app.task(name="tasks.say_hello")
def say_hello(name: str = "World"):
    time.sleep(2)  # simulate some work
    message = f"Hello, {name}! from Celery worker"
    print(message)
    return message