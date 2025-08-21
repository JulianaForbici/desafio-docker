#!/bin/bash
set -e

REPO_URL="https://github.com/JulianaForbici/desafio-docker.git"
PROJECT_DIR="/desafio-docker"

echo "Starting..."

sudo apt update -y
sudo apt install -y docker.io docker-compose git cron

sudo systemctl start docker
sudo systemctl enable docker

sudo systemctl start cron
sudo systemctl enable cron

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Cloning repository into $PROJECT_DIR..."
    sudo git clone "$REPO_URL" "$PROJECT_DIR"
else
    echo "Pulling latest changes in $PROJECT_DIR..."
    sudo git -C "$PROJECT_DIR" pull origin main
fi

echo "Rebuilding and restarting containers..."
sudo docker-compose -f "$PROJECT_DIR/docker-compose.yml" down
sudo docker-compose -f "$PROJECT_DIR/docker-compose.yml" up --build -d --force-recreate

(crontab -l 2>/dev/null | grep -q "desafio-docker.sh") || \
  (crontab -l 2>/dev/null; echo "*/5 * * * * $PROJECT_DIR/desafio-docker.sh") | crontab -

echo "Finished."

