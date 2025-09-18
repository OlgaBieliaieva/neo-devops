#!/bin/bash

set -e

echo "=== Встановлення DevOps інструментів ==="

# Docker
if ! command -v docker &> /dev/null; then
    echo "Встановлюю Docker..."
    sudo apt update
    sudo apt install -y docker.io
else
    echo "Docker вже встановлений."
fi
# Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Встановлюю Docker Compose..."
    sudo apt install -y docker-compose
else
    echo "Docker Compose вже встановлений."
fi
# Python
if ! command -v python3 &> /dev/null; then
    echo "Встановлюю Python..."
    sudo apt install -y python3 python3-pip
else
    echo "Python вже встановлений."
fi
# pip
if ! python3 -m pip --version &> /dev/null; then
    echo "Встановлюю pip..."
    sudo apt update
    sudo apt install --reinstall -y python3-pip
    python3 -m ensurepip --upgrade || true
else
    echo "pip вже встановлений."
fi
# Django
if ! python3 -m pip show django &> /dev/null; then
    echo "Встановлюю Django..."
    python3 -m pip install --user --break-system-packages django
else
    echo "Django вже встановлений."
fi

echo "✅ Встановлення DevOps інструментів завершено!"
