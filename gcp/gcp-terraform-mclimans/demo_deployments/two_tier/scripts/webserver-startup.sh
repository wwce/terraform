#! /bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
dbip="10.5.3.5"
FW_NIC2="10.5.2.4"
while true
    do 
        resp=$(curl -s -S -g -k "https://$FW_NIC2/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=LUFRPT1CU0dMRHIrOWFET0JUNzNaTmRoYmkwdjBkWWM9alUvUjBFTTNEQm93Vmx0OVhFRlNkOXdJNmVwYWk5Zmw4bEs3NjgwMkh5QT0=")
	echo $resp
        if [[ $resp == *"[CDATA[yes"* ]] ; then
            break
        fi
        sleep 10s
    done
apt-get update
apt-get install -y apache2 wordpress
ln -sf /usr/share/wordpress /var/www/html/wordpress
gzip -d /usr/share/doc/wordpress/examples/setup-mysql.gz
while true; do
  resp=$(mysql -udemouser -ppaloalto@123 -h "$dbip" -e 'show databases')
  echo "$resp"
  if [[ "$resp" = *"Demo"* ]]
       then
            break
  fi
 sleep 5s
done
bash /usr/share/doc/wordpress/examples/setup-mysql -n Demo -t "$dbip" "$dbip"
sed -i "s/define('DB_USER'.*/define('DB_USER', 'demouser');/g" /etc/wordpress/config-"$dbip".php
sed -i "s/define('DB_PASSWORD'.*/define('DB_PASSWORD', 'paloalto@123');/g" /etc/wordpress/config-"$dbip".php
wget -O /usr/lib/cgi-bin/guess-sql-root-password.cgi https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/guess-sql-root-password.cgi
chmod +x /usr/lib/cgi-bin/guess-sql-root-password.cgi
sed -i "s/DB-IP-ADDRESS/$dbip/g" /usr/lib/cgi-bin/guess-sql-root-password.cgi
wget -O /usr/lib/cgi-bin/ssh-to-db.cgi https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/ssh-to-db.cgi
chmod +x /usr/lib/cgi-bin/ssh-to-db.cgi
sed -i "s/DB-IP-ADDRESS/$dbip/g" /usr/lib/cgi-bin/ssh-to-db.cgi
wget -O /var/www/html/showheaders.php https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/showheaders.php
wget -O /var/www/html/sql-attack.html https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/sql-attack.html
ln -sf /etc/apache2/conf-available/serve-cgi-bin.conf /etc/apache2/conf-enabled/serve-cgi-bin.conf
ln -sf /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load
sudo ln -s /etc/wordpress/config-"$dbip".php /etc/wordpress/config-default.php
systemctl restart apache2

