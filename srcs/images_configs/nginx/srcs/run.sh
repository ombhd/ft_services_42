#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login: obouykou

echo "Starting telegraf .."
telegraf &


echo "Starting Nginx Server.."
rc-service nginx start >/dev/null 2>&1
echo "Starting sshd Service.."
rc-service sshd start >/dev/null 2>&1

sleep 1

while true;
do
	if ! pgrep nginx >/dev/null 2>&1 ; then
		echo "Nginx Server is down !"
		echo "Quitting.."
		exit 1
	else
		echo "Nginx is up!"
	fi
	if ! pgrep sshd >/dev/null 2>&1 ; then
		echo "sshd service is down !"
		echo "Quitting.."
		exit 1
	else
		echo "sshd is up!"
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

exit 0
