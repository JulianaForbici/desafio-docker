#!/bin/bash

PROJECT_DIR="/tmp/desafio-docker"
REPO_URL="https://github.com/JulianaForbici/desafio-docker.git"
LOG_FILE="/tmp/pizzaria-deploy.log"

echo "[INFO] Starting deploy script..."

apt update -y
apt install -y docker.io docker-compose git cron >> "$LOG_FILE" 2>&1

if [ ! -d "$PROJECT_DIR" ]; then
    echo "[INFO] Cloning repository into $PROJECT_DIR..."
    git clone "$REPO_URL" "$PROJECT_DIR" >> "$LOG_FILE" 2>&1
    CHANGED=1
else
    cd "$PROJECT_DIR"
    echo "[INFO] Pulling latest changes..."
    git fetch origin >> "$LOG_FILE" 2>&1

    LOCAL_COMMIT=$(git rev-parse HEAD)
    REMOTE_COMMIT=$(git rev-parse origin/main)

    if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo "[INFO] Changes detected between commits. Updating repo..."
        git reset --hard origin/main >> "$LOG_FILE" 2>&1
        CHANGED=1
    else
        echo "[INFO] No changes in repository."
        CHANGED=0
    fi
fi

cd "$PROJECT_DIR"

if [ "$CHANGED" = "1" ]; then
    echo "[INFO] Rebuilding and restarting containers..."
    docker-compose down >> "$LOG_FILE" 2>&1
    docker-compose build --no-cache >> "$LOG_FILE" 2>&1
    docker-compose up -d >> "$LOG_FILE" 2>&1
else
    echo "[INFO] No rebuild needed."
fi

CRON_JOB="*/5 * * * * /bin/bash $PROJECT_DIR/deploy.sh >> $LOG_FILE 2>&1"
(crontab -l 2>/dev/null | grep -Fv "$PROJECT_DIR/deploy.sh" ; echo "$CRON_JOB") | crontab -

echo "[INFO] Deploy script finished."
