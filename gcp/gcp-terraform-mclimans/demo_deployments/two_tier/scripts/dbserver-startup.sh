#!/bin/bash
sudo exec > >(sudo tee /var/log/user-data.log|logger -t user-data -s 2> sudo /dev/console) 2>&1
FW_NIC3="10.5.3.4"
while true
    do 
        resp=$(curl -s -S -g -k "https://$FW_NIC3/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=LUFRPT1CU0dMRHIrOWFET0JUNzNaTmRoYmkwdjBkWWM9alUvUjBFTTNEQm93Vmx0OVhFRlNkOXdJNmVwYWk5Zmw4bEs3NjgwMkh5QT0=")
	echo $resp
        if [[ $resp == *"[CDATA[yes"* ]] ; then
            break
        fi
        sleep 10s
    done
sudo apt-get update
sudo apt-get -y install debconf-utils 
sudo DEBIAN_FRONTEND=noninteractive | apt-get install -y mysql-server 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "DELETE FROM mysql.user WHERE User=''" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_localhost';"
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "FLUSH PRIVILEGES;" 
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql && sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "CREATE DATABASE Demo;" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "CREATE USER 'demouser'@'%' IDENTIFIED BY 'paloalto@123';" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "GRANT ALL PRIVILEGES ON Demo.* TO 'demouser'@'%';" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "FLUSH PRIVILEGES;"