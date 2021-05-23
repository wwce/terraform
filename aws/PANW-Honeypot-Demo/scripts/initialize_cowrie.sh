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
#wget --no-check-certificate https://security-framework-us-west-2.s3.amazonaws.com/cowrie_files_20210504.tar.gz
#tar zxf cowrie_files_20210504.tar.gz
cd /var/tmp
echo "version: '2'" > docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  cowrie:" >> docker-compose.yml
echo "    restart: always" >> docker-compose.yml
echo "    image: pglynn/cowrie:latest" >> docker-compose.yml
echo "    environment:" >> docker-compose.yml
echo "      - COWRIE_TELNET_ENABLED=yes" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - \"2222:2222\"" >> docker-compose.yml
echo "      - \"2223:2223\"" >> docker-compose.yml
#echo "    volumes:" >> docker-compose.yml
#echo "      - /home/cowrie/cowrie/etc:/cowrie/cowrie-git/etc" >> docker-compose.yml
#echo "      - /home/cowrie/cowrie/share:/cowrie/cowrie-git/share" >> docker-compose.yml
#echo "      - /home/cowrie/cowrie/honeyfs:/cowrie/cowrie-git/honeyfs" >> docker-compose.yml
docker-compose up -d
usermod -aG docker ubuntu
