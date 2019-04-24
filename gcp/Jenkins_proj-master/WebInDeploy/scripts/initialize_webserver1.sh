#!/bin/bash
apt-get update
apt-get update
apt install docker.io python3-pip build-essential libssl-dev libffi-dev -y --force-yes
pip3 install docker-compose
cd /var/tmp
wget https://jenkins-test-vuln.s3-us-west-2.amazonaws.com/Dockerfile
wget https://jenkins-test-vuln.s3-us-west-2.amazonaws.com/docker-compose.yml
wget https://jenkins-test-vuln.s3-us-west-2.amazonaws.com/jenkins.sh
docker-compose build
docker-compose up -d