# load_test.py
import requests
import time
import concurrent.futures

BASE_URL = "http://localhost:8000"  # Change this to your FastAPI server URL
# BASE_URL = "http://fastapi.example.com"
TASKS = 500

def submit_task(i):
    try:
        r = requests.post(
            f"{BASE_URL}/hello/async",
            params={"name": f"LoadTest{i}"},
            timeout=10
        )
        data = r.json()
        print(f"✅ Task {i}: {data['task_id']}")
        return data['task_id']
    except Exception as e:
        print(f"❌ Task {i} failed: {e}")
        return None

print(f"🚀 Submitting {TASKS} tasks to {BASE_URL}...")
start = time.time()

# Submit all tasks
with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
    task_ids = list(executor.map(submit_task, range(1, TASKS + 1)))

submitted = [t for t in task_ids if t]
print(f"\n=== Summary ===")
print(f"✅ Submitted: {len(submitted)}/{TASKS}")
print(f"⏱ Time: {time.time()-start:.2f}s")