import os
from datetime import datetime, timezone
from fastapi import FastAPI

app = FastAPI(title="Cloud Native Sample API", version="1.0.0")

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
