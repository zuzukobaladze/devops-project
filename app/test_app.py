import pytest
from app import app as flask_app
import json

@pytest.fixture
def app():
    return flask_app

@pytest.fixture
def client(app):
    return app.test_client()

def test_health_endpoint(client):
    response = client.get('/health')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert 'timestamp' in data
    assert data['version'] == '1.0.0'

def test_submit_endpoint(client):
    test_data = {
        'name': 'Test User',
        'message': 'Hello, DevOps!'
    }
    
    response = client.post('/submit', data=test_data)
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert data['status'] == 'success'
    assert data['data']['name'] == 'Test User'
    assert data['data']['message'] == 'Hello, DevOps!'
    assert 'timestamp' in data['data'] 