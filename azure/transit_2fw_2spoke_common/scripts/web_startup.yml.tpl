#cloud-config

runcmd:
  - sudo apt-get update -y
  - sudo apt-get install -y php
  - sudo apt-get install -y apache2
  - sudo apt-get install -y libapache2-mod-php
  - sudo rm -f /var/www/html/index.html
  - sudo wget -O /var/www/html/index.php https://raw.githubusercontent.com/wwce/terraform/master/azure/transit-common-fw/scripts/showheaders.php
  - sudo systemctl restart apache2