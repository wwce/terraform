#!/bin/bash
while true
  do
    curl -s -S -g --insecure https://www.google.com
    if [ $? -eq 0 ] ; then
      break
    fi
  sleep 10s
done
apt-get update
apt-get update
apt install docker.io python3-pip build-essential libssl-dev libffi-dev docker-compose -y --force-yes
cd /var/tmp
echo "version: '2'" > docker-compose.yml
echo "volumes:" >> docker-compose.yml
echo "  cowrie-etc:" >> docker-compose.yml
echo "  cowrie-var:" >> docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  cowrie:" >> docker-compose.yml
echo "    restart: always" >> docker-compose.yml
echo "    image: cowrie/cowrie" >> docker-compose.yml
echo "    environment:" >> docker-compose.yml
echo "      - COWRIE_TELNET_ENABLED=yes" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - \"2222:2222\"" >> docker-compose.yml
echo "      - \"2223:2223\"" >> docker-compose.yml
echo "    volumes:" >> docker-compose.yml
echo "      - cowrie-etc:/cowrie/cowrie-git/etc" >> docker-compose.yml
echo "      - cowrie-var:/cowrie/cowrie-git/var" >> docker-compose.yml
docker-compose up -d
usermod -aG docker ubuntu
