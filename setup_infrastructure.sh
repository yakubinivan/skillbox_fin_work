#!/bin/bash

# Скрипт для развертывания инфраструктуры в Yandex Cloud через yc CLI

echo "Начинаю создание инфраструктуры..."

# 1. Создание группы безопасности (Firewall)
# Создаем группу и сразу сохраняем её ID в переменную
SG_ID=$(yc vpc security-group create \
  --name project-sg \
  --description "Firewall rules for VPN and Monitoring" \
  --rule "direction=ingress,port=22,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=ingress,port=1194,protocol=udp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=ingress,port=3000,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --network-name default \
  --format json | jq -r .id)

echo "Группа безопасности создана с ID: $SG_ID"

# 2. Создание CA-server (Удостоверяющий центр)
yc compute instance create \
  --name ca-server \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,security-group-ids=[$SG_ID] \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,size=20 \
  --metadata-from-file user-data=cloud-config.yaml

# 3. Создание VPN-server (VPN-шлюз)
yc compute instance create \
  --name vpn-server \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,security-group-ids=[$SG_ID] \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,size=20 \
  --metadata-from-file user-data=cloud-config.yaml

# 4. Создание Monitoring-server (Мониторинг и Бэкапы)
yc compute instance create \
  --name monitoring-server \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,security-group-ids=[$SG_ID] \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,size=20 \
  --metadata-from-file user-data=cloud-config.yaml

echo "Инфраструктура успешно создана! Все правила Firewall применены."
