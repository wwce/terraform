#! /bin/bash
apt-get update
apt-get install -y apache2 php7. libapache2-mod-php7.
rm -f /var/www/html/index.html
wget -O /var/www/html/index.php https://raw.githubusercontent.com/jasonmeurer/azure-appgw-2fw/master/showheaders.php
systemctl restart apache2
