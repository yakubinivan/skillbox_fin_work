#!/bin/bash

# Скрипт для развертывания инфраструктуры в Yandex Cloud через yc CLI

echo "Начинаю создание виртуальных машин..."

# 1. Создание CA-server (Удостоверяющий центр)
yc compute instance create \
  --name ca-server \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,size=20 \
  --metadata-from-file user-data=cloud-config.yaml

# 2. Создание VPN-server (VPN-шлюз)
yc compute instance create \
  --name vpn-server \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,size=20 \
  --metadata-from-file user-data=cloud-config.yaml

# 3. Создание Monitoring-server (Мониторинг и Бэкапы)
yc compute instance create \
  --name monitoring-server \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,size=20 \
  --metadata-from-file user-data=cloud-config.yaml

echo "Инфраструктура успешно создана!"
