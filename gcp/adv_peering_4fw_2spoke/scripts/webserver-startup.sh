#!/bin/bash
until sudo apt-get update; do echo "Retrying"; sleep 2; done
until sudo apt-get install -y php; do echo "Retrying"; sleep 2; done
until sudo apt-get install -y apache2; do echo "Retrying"; sleep 2; done
until sudo apt-get install -y libapache2-mod-php; do echo "Retrying"; sleep 2; done
until sudo rm -f /var/www/html/index.html; do echo "Retrying"; sleep 2; done
until sudo wget -O /var/www/html/index.php https://raw.githubusercontent.com/wwce/terraform/master/gcp/adv_peering_4fw_2spoke/scripts/showheaders.php; do echo "Retrying"; sleep 2; done
until sudo systemctl restart apache2; do echo "Retrying"; sleep 2; done