import os
from datetime import datetime, timezone
from fastapi import FastAPI, Request, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

HTTP_REQUESTS = Counter('sample_api_http_requests_total', 'HTTP requests by method, path and status', ['method', 'path', 'status'])

app = FastAPI(title="Cloud Native Sample API", version="1.0.0")

@app.middleware("http")
async def request_metrics(request: Request, call_next):
    response = await call_next(request)
    HTTP_REQUESTS.labels(method=request.method, path=request.url.path, status=str(response.status_code)).inc()
    return response

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

@app.get("/")
def root():
    return {"service": "cloud-native-sample-api", "status": "ok"}

@app.get("/health/live")
def liveness():
    return {"status": "alive"}

@app.get("/health/ready")
def readiness():
    return {"status": "ready"}

@app.get("/info")
def info():
    return {"version": os.getenv("APP_VERSION", "dev"), "utc": datetime.now(timezone.utc).isoformat()}
