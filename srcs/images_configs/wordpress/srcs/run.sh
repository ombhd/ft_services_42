#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login: obouykou

echo "Starting telegraf .."
telegraf &

echo "Starting PHP FastCGI.."
rc-service php-fpm7 start 1>/dev/null

echo "Starting Nginx Server.."
rc-service nginx start 1>/dev/null

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
	if ! pgrep php-fpm7 >/dev/null 2>&1 ; then
		echo "PHP FastCGI is down !"
		echo "Quitting.."
		exit 1
	else
		echo "PHP FastCGI is up!"
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
