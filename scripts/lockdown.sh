#!/bin/bash
INSTANCE_NAME="private-cloud-vpn"

echo "Aplicando Hardening de Rede: fechando SSH publico..."
aws lightsail put-instance-public-ports \
  --instance-name $INSTANCE_NAME \
  --port-infos fromPort=51820,toPort=51820,protocol=UDP

echo "Servidor trancado! Apenas a porta 51820/UDP (WireGuard) esta visivel na internet."
