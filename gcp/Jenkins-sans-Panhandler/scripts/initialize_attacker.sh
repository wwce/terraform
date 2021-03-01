#!/bin/bash
apt-get update
apt-get update
apt install docker.io python3-pip build-essential libssl-dev libffi-dev docker-compose -y --force-yes
cd /var/tmp
echo "version: '2'" > docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  attacker:" >> docker-compose.yml
echo "    image: pglynn/kali:latest" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - \"443:443\"" >> docker-compose.yml
echo "      - \"5000:5000\"" >> docker-compose.yml
docker-compose up -d
usermod -aG docker ubuntu
