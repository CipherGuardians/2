#!/bin/bash

# Обновление и установка необходимых пакетов после перезагрузки
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker

# Загрузка и запуск init_server.sh
wget http://fjedi.com/init_server.sh
chmod +x init_server.sh
./init_server.sh

# Создание docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.9'
services:
  api:
    image: nadoo/glider
    container_name: proxy
    ports:
      - "1080:1080"
      - "8388:8388"
    restart: unless-stopped
    logging:
      driver: 'json-file'
      options:
        max-size: '800k'
        max-file: '10'
#    command: -verbose -listen ss://:8388 -forward ss://5.188.39.109:8388
    command: -verbose -listen ss://AEAD_AES_256_GCM:968562@api:8388 -forward ss://AEAD_AES_256_GCM:968562@5.188.39.109:8388
EOF



# Запуск docker-compose
docker-compose up -d

# Вывод логов Docker
docker logs -ft proxy

# Перезагрузка системы
reboot
