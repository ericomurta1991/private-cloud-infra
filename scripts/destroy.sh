#!/bin/bash
INSTANCE_NAME="private-cloud-vpn"

echo "Destruindo instancia $INSTANCE_NAME na AWS Lightsail..."
aws lightsail delete-instance --instance-name $INSTANCE_NAME

echo "Instancia removida com sucesso! Nenhuma cobranca adicional sera gerada."
