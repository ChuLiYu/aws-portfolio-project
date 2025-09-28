FROM python:3.11-slim

# 設定工作目錄
WORKDIR /app

# 安裝系統依賴和安全更新
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# 複製需求檔案
COPY requirements.txt .

# 安裝 Python 依賴
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 複製應用程式檔案
COPY . .

# 建立非 root 使用者和設定權限
RUN useradd -m -u 1000 appuser \
    && chown -R appuser:appuser /app \
    && chmod -R 755 /app \
    && chmod 644 /app/app.py

# 切換到非 root 使用者
USER appuser

# 設定環境變數
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV FLASK_ENV=production
ENV FLASK_DEBUG=False

# 暴露端口
EXPOSE 80

# 健康檢查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# 啟動應用程式
CMD ["gunicorn", "--bind", "0.0.0.0:80", "--workers", "2", "--timeout", "30", "--max-requests", "1000", "--max-requests-jitter", "100", "app:app"]
