#!/bin/bash
# Install docker
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# READ MORE: https://docs.docker.com/install/linux/docker-ce/ubuntu/
# To check: grep "cloud-init\[" /var/log/syslog
#       OR: less /var/log/cloud-init-output.log

# Manually add user to docker group
# sudo usermod -aG docker $USER


curl -o ./twistlock.tar.gz https://cdn.twistlock.com/releases/0955bgg7/twistlock_19_07_358.tar.gz
mkdir twistlock
tar -xzf twistlock.tar.gz -C twistlock/
./twistlock/twistlock.sh -s onebox