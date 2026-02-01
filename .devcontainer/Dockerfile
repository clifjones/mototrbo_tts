FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install MotoTRBO TTS dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

    
