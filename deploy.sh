#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/JulianaForbici/desafio-docker.git"
PROJECT_DIR="/desafio-docker"
CRON_SCRIPT="desafio-docker.sh"

echo "=== Starting deployment script ==="

echo "Updating package lists..."
sudo apt update -y

echo "Installing required packages (docker, docker-compose, git, cron)..."
sudo apt install -y docker.io docker-compose git cron

echo "Ensuring Docker service is running and enabled..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Ensuring cron service is running and enabled..."
sudo systemctl start cron
sudo systemctl enable cron

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Cloning repository into $PROJECT_DIR..."
    sudo git clone "$REPO_URL" "$PROJECT_DIR"
else
    echo "Repository found. Pulling latest changes in $PROJECT_DIR..."
    sudo git -C "$PROJECT_DIR" pull origin main
fi

echo "Rebuilding and restarting Docker containers..."
sudo docker-compose -f "$PROJECT_DIR/docker-compose.yml" down
sudo docker-compose -f "$PROJECT_DIR/docker-compose.yml" up --build -d --force-recreate

echo "Checking if cron job is already installed..."
if ! crontab -l 2>/dev/null | grep -q "$CRON_SCRIPT"; then
    echo "Adding cron job to run $PROJECT_DIR/$CRON_SCRIPT every 5 minutes..."
    (crontab -l 2>/dev/null; echo "*/5 * * * * $PROJECT_DIR/$CRON_SCRIPT") | crontab -
else
    echo "Cron job already exists. Skipping."
fi

echo "=== Deployment script finished successfully ==="
