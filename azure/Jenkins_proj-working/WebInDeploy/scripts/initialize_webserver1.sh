#!/bin/bash
apt-get update
apt-get update
apt install docker.io python3-pip build-essential libssl-dev libffi-dev -y --force-yes
pip3 install docker-compose
cd /var/tmp
wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/jenkins/Dockerfile
wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/jenkins/docker-compose.yml
wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/jenkins/jenkins.sh
docker-compose build
docker-compose up -d
