#!/bin/bash
apt-get update
apt-get update
apt install docker.io python3-pip build-essential libssl-dev libffi-dev -y --force-yes
pip3 install docker-compose
cd /var/tmp
echo "version: '3'" > docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  jenkins:" >> docker-compose.yml
echo "    image: pglynn/jenkins:latest" >> docker-compose.yml
echo "    environment:" >> docker-compose.yml
echo "      JAVA_OPTS: \"-Djava.awt.headless=true\"" >> docker-compose.yml
echo "      JAVA_OPTS: \"-Djenkins.install.runSetupWizard=false\"" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - \"50000:50000\"" >> docker-compose.yml
echo "      - \"8080:8080\"" >> docker-compose.yml
docker-compose up -d
