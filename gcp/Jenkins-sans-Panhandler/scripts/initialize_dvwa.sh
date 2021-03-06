#!/bin/bash
apt-get update
apt-get update
apt install docker.io python3-pip build-essential libssl-dev libffi-dev docker-compose -y --force-yes
cd /var/tmp
echo "version: '2'" > docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  struts:" >> docker-compose.yml
echo "    image: vulnerables/web-dvwa" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - \"8080:80\"" >> docker-compose.yml
docker-compose up -d
usermod -aG docker ubuntu
