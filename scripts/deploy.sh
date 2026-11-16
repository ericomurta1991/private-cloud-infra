#!/bin/bash
INSTANCE_NAME="private-cloud-vpn"
REPO_URL="https://github.com"

echo "1. Criando instancia no Amazon Lightsail..."
aws lightsail create-instances \
  --instance-names $INSTANCE_NAME \
  --availability-zone us-east-1a \
  --blueprint-id ubuntu_22_04 \
  --bundle-id micro_3_0 \
  --user-data "#!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose-v2 git openssl
    systemctl enable --now docker
    cd /home/ubuntu
    git clone "$REPO_URL"
    cd private-cloud-infra
    cp .env.example .env
    SENHA_SEGURA=\$(openssl rand -base64 16)
    sed -i \"s/TroqueEssaSenha123/\$SENHA_SEGURA/g\" .env
    chown -R ubuntu:ubuntu /home/ubuntu/private-cloud-infra
    docker compose up -d"

echo "2. Aguardando 45 segundos para o servidor inicializar..."
sleep 45

echo "3. Configurando firewall inicial (VPN 51820/UDP + SSH temporario)..."
aws lightsail put-instance-public-ports \
  --instance-name $INSTANCE_NAME \
  --port-infos fromPort=22,toPort=22,protocol=TCP fromPort=51820,toPort=51820,protocol=UDP

echo "Deploy concluido! Para ver o IP publico e a status da maquina, rode:"
echo "aws lightsail get-instance --instance-name $INSTANCE_NAME --query 'instance.{State:state.name,PublicIP:publicIpAddress}'"
