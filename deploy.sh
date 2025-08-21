#!/bin/bash

set -e  # Para o script se qualquer comando der erro

# URL do repositório GitHub
REPO_URL="https://github.com/JulianaForbici/desafio-docker.git"
# Diretório onde o projeto será clonado ou atualizado
PROJECT_DIR="/desafio-docker"

echo "Starting..."

# Atualiza lista de pacotes e instala docker, docker-compose, git e cron
sudo apt update -y
sudo apt install -y docker.io docker-compose git cron

# Inicia e habilita os serviços docker e cron para iniciar junto com o sistema
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start cron
sudo systemctl enable cron

# Se o diretório do projeto não existir, clona o repositório
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Cloning repository into $PROJECT_DIR..."
    git clone "$REPO_URL" "$PROJECT_DIR"
else
    # Se já existir, entra no diretório e faz pull das últimas alterações
    cd "$PROJECT_DIR"
    echo "Pulling latest changes..."
    git pull origin main
fi

# Entra no diretório do projeto
cd "$PROJECT_DIR"

echo "Rebuilding and restarting containers..."
# Para os containers existentes e reconstrói tudo forçando atualização
sudo docker-compose down
sudo docker-compose up --build -d --force-recreate

# Cria um job no crontab para rodar deploy_pizzaria.sh a cada 5 minutos,
# se ele ainda não estiver criado (sem redirecionamento de logs)
crontab -l 2>/dev/null | grep -q "deploy_pizzaria.sh" || \
  (crontab -l 2>/dev/null; echo "*/5 * * * * $PROJECT_DIR/deploy_pizzaria.sh") | crontab -

echo "Finished."
