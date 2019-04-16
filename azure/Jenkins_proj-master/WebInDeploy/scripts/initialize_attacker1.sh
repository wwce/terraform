#!/bin/bash
apt-get update
apt-get update
apt install docker.io python3-pip build-essential libssl-dev libffi-dev -y --force-yes
pip3 install docker-compose
cd /var/tmp
wget https://raw.githubusercontent.com/nembery/terraform-1/master/azure/Jenkins_proj-master/.temp/Dockerfile
wget https://raw.githubusercontent.com/nembery/terraform-1/master/azure/Jenkins_proj-master/.temp/docker-compose.yml
wget https://github.com/wwce/terraform/blob/master/azure/Jenkins_proj-master/attacker/run.sh
wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/attacker/auto-sploit.sh
wget https://raw.githubusercontent.com/wwce/terraform/master/aws/Jenkins_proj-master/exp-server.py
docker-compose build
docker-compose up -d
