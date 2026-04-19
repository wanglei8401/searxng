 FROM python:3.11-slim
    
    ENV SEARXNG_VERSION=latest
    
    RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        curl \
        && rm -rf /var/lib/apt/lists/*
    
    WORKDIR /usr/local/searxng
    
    COPY requirements.txt requirements-server.txt ./
    RUN pip install --no-cache-dir -r requirements.txt -r requirements-server.txt
    
    COPY searx/ ./searx/
    COPY searxng.data/ ./searxng.data/
    COPY searxng.version/ ./searxng.version/
    COPY manage.py setup.py ./
    
    ENV SEARXNG_BASE_URL="http://localhost:8888/"
    ENV SEARXNG_SECRET_KEY="$(openssl rand -hex 32)"
    ENV SEARXNG_BIND_ADDRESS="0.0.0.0:8888"
    
    EXPOSE 8888
    
    CMD ["python", "-m", "searx.run"]
