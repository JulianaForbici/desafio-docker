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
    git clone "$REPO_URL" "$PROJECT_DIR"
    CHANGED=1
else
    cd "$PROJECT_DIR"
    echo "Pulling latest changes..."
    git pull origin main
    CHANGED=1   
fi

cd "$PROJECT_DIR"

if [ "$CHANGED" = "1" ]; then
    echo "Rebuilding and restarting containers..."
    sudo docker-compose down
    sudo docker-compose up --build -d --force-recreate
else
    echo "No rebuild needed."
fi

CRON_JOB="*/5 * * * * /bin/bash $PROJECT_DIR/deploy.sh >> $LOG_FILE 2>&1"
(crontab -l 2>/dev/null | grep -v "$PROJECT_DIR/deploy.sh" ; echo "$CRON_JOB") | crontab -

echo "Finished."
