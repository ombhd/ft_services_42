#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login: obouykou

echo "Starting telegraf .."
telegraf &


echo "Starting MySQL .."

if ! ls /var/lib/mysql/ib_buffer_pool > /dev/null 2>&1 ; 
then
	echo "Setup MySQL .."
	/etc/init.d/mariadb setup 1> /dev/null && \
	rc-service mariadb start 1>/dev/null && \
	mysql -u root -e "create user '${MYSQL_ROOT_USERNAME}'@'%' identified by '${MYSQL_ROOT_PASSWORD}'" 1>/dev/null && \
	mysql -u root -e "create database wordpress" 1>/dev/null && \
	mysql -u root -e "grant all privileges on *.* to '${MYSQL_ROOT_USERNAME}'@'%'" 1>/dev/null && \
	mysql -u root -e "flush privileges" 1>/dev/null && \
	mysql -u root -e "exit" 1>/dev/null && \
	mysql -u root < /wordpress.sql && \
	rc-service mariadb stop 1>/dev/null
fi

sed -i "s|.*skip-networking.*|#skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

rc-service mariadb start 1>/dev/null
sleep 1


while true;
do
	if ! pgrep mysql >/dev/null 2>&1 ; then
		echo "MySQL is down !"
		echo "Quitting.."
		exit 1
	else
		echo "MySQL is up!"
	fi
	if ! pgrep telegraf >/dev/null 2>&1 ; then
		echo "telegraf is down !"
		echo "Quitting.."
		exit 1
	else
		echo "telegraf is up!"
	fi
	sleep 2
done
