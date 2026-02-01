#!/usr/bin/env bash
set -e

# Create virtual environment for Python
python3 -m venv .venv && source .venv/bin/activate
pip3 install pathvalidate piper-tts
mkdir -p $DATA_DIR
mkdir -p $OUTPUT_DIR
mkdir -p $TMP_DIR
