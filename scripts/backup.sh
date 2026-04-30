#!/bin/bash
# Скрипт автоматизации бэкапа конфигурации PKI в Borg
REPO="monitoring@62.84.125.193:/home/monitoring/repo"
# Создание архива
borg create --stats --progress $REPO::$(date +%Y-%m-%d) /etc/easy-rsa
