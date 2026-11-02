from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"

def test_liveness():
    assert client.get("/health/live").json() == {"status": "alive"}

def test_readiness():
    assert client.get("/health/ready").json() == {"status": "ready"}

def test_info():
    response = client.get("/info")
    assert response.status_code == 200
    assert "version" in response.json()
