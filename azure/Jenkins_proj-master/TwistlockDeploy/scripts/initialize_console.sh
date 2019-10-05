#!/bin/bash
apt-get update
apt-get update
cd /var/tmp
sudo wget -O initialize_console.sh https://raw.githubusercontent.com/wwce/terraform/twistlck/azure/Jenkins_proj-master/WebInDeploy/scripts/initialise_console.sh
sudo chmod 755 /var/tmp/initialize_console.sh
sudo bash /var/tmp/initialize_console.sh https://cdn.twistlock.com/releases/c84791c5/twistlock_19_07_363.tar.gz
