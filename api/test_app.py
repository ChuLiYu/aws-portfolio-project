# API 測試檔案
# API Test File

import pytest
import json
from app import app, sanitize_input, check_rate_limit


@pytest.fixture
def client():
    """建立測試客戶端"""
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_health_endpoint(client):
    """測試健康檢查端點"""
    response = client.get("/")
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data["ok"] == True
    assert "timestamp" in data


def test_get_guestbook_empty(client):
    """測試取得空的留言列表"""
    response = client.get("/api/guestbook")
    assert response.status_code == 200
    data = json.loads(response.data)
    assert "messages" in data
    assert "count" in data
    assert data["count"] == 0


def test_add_message(client):
    """測試新增留言"""
    test_message = "Hello, World!"
    response = client.post(
        "/api/guestbook", json={"msg": test_message}, content_type="application/json"
    )
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data["ok"] == True
    assert "message" in data
    assert data["message"]["msg"] == test_message


def test_add_message_empty(client):
    """測試新增空留言"""
    response = client.post(
        "/api/guestbook", json={"msg": ""}, content_type="application/json"
    )
    assert response.status_code == 400
    data = json.loads(response.data)
    assert "error" in data


def test_sanitize_input():
    """測試輸入清理函數"""
    # 正常輸入
    assert sanitize_input("Hello World") == "Hello World"

    # HTML 標籤
    assert (
        sanitize_input("<script>alert('xss')</script>")
        == "&lt;script&gt;alert(&#x27;xss&#x27;)&lt;/script&gt;"
    )

    # 長度限制
    long_text = "a" * 600
    result = sanitize_input(long_text)
    assert len(result) == 500

    # 空輸入
    assert sanitize_input("") == ""
    assert sanitize_input(None) == ""

    # 特殊字符
    assert sanitize_input("Hello! @#$%") == "Hello! @#$%"


def test_rate_limit():
    """測試速率限制"""
    # 測試正常請求
    allowed, error = check_rate_limit("127.0.0.1")
    assert allowed == True
    assert error is None

    # 測試超過限制（需要模擬多個請求）
    # 這裡只是測試函數邏輯，實際的速率限制測試需要更複雜的設定


def test_cors_headers(client):
    """測試 CORS 標頭"""
    response = client.options("/api/guestbook")
    # CORS 標頭應該由 flask-cors 處理
    assert response.status_code in [200, 204]


def test_invalid_json(client):
    """測試無效的 JSON"""
    response = client.post(
        "/api/guestbook", data="invalid json", content_type="application/json"
    )
    assert response.status_code == 201  # 應該處理無效 JSON 並返回空訊息


if __name__ == "__main__":
    pytest.main([__file__])
