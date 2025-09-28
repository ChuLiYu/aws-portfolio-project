from flask import Flask, jsonify, request
from flask_cors import CORS
import html
import re
import os
from datetime import datetime
import logging
from collections import defaultdict, deque
import time

app = Flask(__name__)

# CORS Configuration - Restrict allowed origins
allowed_origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:8080").split(",")
CORS(
    app,
    origins=allowed_origins,
    methods=["GET", "POST"],
    allow_headers=["Content-Type"],
)

# Logging Configuration
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

msgs = []

# Rate Limiting Configuration
RATE_LIMIT_PER_MINUTE = int(os.getenv("RATE_LIMIT_PER_MINUTE", "60"))
RATE_LIMIT_PER_HOUR = int(os.getenv("RATE_LIMIT_PER_HOUR", "1000"))

# Simple in-memory rate limiter
rate_limiter = defaultdict(lambda: {"minute": deque(), "hour": deque()})


def check_rate_limit(ip_address):
    """Check rate limiting"""
    current_time = time.time()
    minute_window = current_time - 60
    hour_window = current_time - 3600

    # Clean expired records
    while (
        rate_limiter[ip_address]["minute"]
        and rate_limiter[ip_address]["minute"][0] < minute_window
    ):
        rate_limiter[ip_address]["minute"].popleft()

    while (
        rate_limiter[ip_address]["hour"]
        and rate_limiter[ip_address]["hour"][0] < hour_window
    ):
        rate_limiter[ip_address]["hour"].popleft()

    # Check limits
    if len(rate_limiter[ip_address]["minute"]) >= RATE_LIMIT_PER_MINUTE:
        return False, "Rate limit exceeded: too many requests per minute"

    if len(rate_limiter[ip_address]["hour"]) >= RATE_LIMIT_PER_HOUR:
        return False, "Rate limit exceeded: too many requests per hour"

    # Record request
    rate_limiter[ip_address]["minute"].append(current_time)
    rate_limiter[ip_address]["hour"].append(current_time)

    return True, None


def sanitize_input(text):
    """Clean and validate input to prevent XSS attacks"""
    if not text or not isinstance(text, str):
        return ""

    # Limit length
    if len(text) > 500:
        text = text[:500]

    # Remove HTML tags and special characters
    text = html.escape(text)

    # Only allow letters, numbers, basic punctuation and Chinese characters
    text = re.sub(r"[^\w\s\u4e00-\u9fff.,!?@#$%^&*()_+-=]", "", text)

    return text.strip()


@app.get("/api/guestbook")
def list_msgs():
    """Get guestbook messages"""
    try:
        # Check rate limiting
        client_ip = request.environ.get("HTTP_X_FORWARDED_FOR", request.remote_addr)
        if client_ip:
            client_ip = client_ip.split(",")[0].strip()

        allowed, error_msg = check_rate_limit(client_ip)
        if not allowed:
            logger.warning(f"Rate limit exceeded for IP: {client_ip}")
            return jsonify({"error": error_msg}), 429

        return jsonify({"messages": msgs, "count": len(msgs)}), 200
    except Exception as e:
        logger.error(f"Error retrieving messages: {e}")
        return jsonify({"error": "Internal server error"}), 500


@app.post("/api/guestbook")
def add_msg():
    """Add guestbook message"""
    try:
        # Check rate limiting
        client_ip = request.environ.get("HTTP_X_FORWARDED_FOR", request.remote_addr)
        if client_ip:
            client_ip = client_ip.split(",")[0].strip()

        allowed, error_msg = check_rate_limit(client_ip)
        if not allowed:
            logger.warning(f"Rate limit exceeded for IP: {client_ip}")
            return jsonify({"error": error_msg}), 429

        data = request.get_json(silent=True) or {}

        # Validate input
        msg_content = sanitize_input(data.get("msg", ""))
        if not msg_content:
            return jsonify({"error": "Message content is required"}), 400

        # Add message
        new_msg = {
            "msg": msg_content,
            "from": "web",
            "timestamp": datetime.utcnow().isoformat(),
            "id": len(msgs) + 1,
        }

        msgs.append(new_msg)

        # Limit message count to prevent memory overflow
        if len(msgs) > 1000:
            msgs.pop(0)

        logger.info(f"New message added from IP {client_ip}: {msg_content[:50]}...")
        return jsonify({"ok": True, "message": new_msg}), 201

    except Exception as e:
        logger.error(f"Error adding message: {e}")
        return jsonify({"error": "Internal server error"}), 500


@app.get("/")
def health():
    """Health check endpoint"""
    return {"ok": True, "timestamp": datetime.utcnow().isoformat()}, 200


@app.errorhandler(404)
def not_found(error):
    """404 error handler"""
    return jsonify({"error": "Not found"}), 404


@app.errorhandler(405)
def method_not_allowed(error):
    """405 error handler"""
    return jsonify({"error": "Method not allowed"}), 405


@app.errorhandler(500)
def internal_error(error):
    """500 error handler"""
    logger.error(f"Internal server error: {error}")
    return jsonify({"error": "Internal server error"}), 500


if __name__ == "__main__":
    # Development environment configuration
    debug_mode = os.getenv("FLASK_DEBUG", "False").lower() == "true"
    port = int(os.getenv("FLASK_PORT", 80))

    if debug_mode:
        logger.warning("Running in DEBUG mode - not suitable for production!")
        app.run(host="0.0.0.0", port=port, debug=True)
    else:
        # Production environment recommended to use gunicorn
        logger.info("Starting production server...")
        app.run(host="0.0.0.0", port=port, debug=False)
