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
apt install docker.io python3-pip build-essential libssl-dev libffi-dev docker-compose mysql-client -y --force-yes
cd /var/tmp
mkdir data
wget --no-check-certificate -O /var/tmp/data/mysql.sql https://raw.githubusercontent.com/cowrie/cowrie/master/docs/sql/mysql.sql
echo "version: '2'" > docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  mysql:" >> docker-compose.yml
echo "    restart: always" >> docker-compose.yml
echo "    image: mysql:latest" >> docker-compose.yml
echo "    environment:" >> docker-compose.yml
echo "      - MYSQL_ROOT_PASSWORD=S3cur3P@ssw0rd" >> docker-compose.yml
echo "      - MYSQL_USER=cowrie" >> docker-compose.yml
echo "      - MYSQL_PASSWORD=S3cur3P@ssw0rd" >> docker-compose.yml
echo "      - MYSQL_DATABASE=cowrie" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - \"3306:3306\"" >> docker-compose.yml
echo "    command: --default-authentication-plugin=mysql_native_password" >> docker-compose.yml
echo "    volumes:" >> docker-compose.yml
echo "      - /var/tmp/data:/docker-entrypoint-initdb.d" >> docker-compose.yml
docker-compose up -d
usermod -aG docker ubuntu
