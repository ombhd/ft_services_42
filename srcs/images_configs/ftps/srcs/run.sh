#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login: obouykou

echo "Starting telegraf .."
telegraf &

echo "Starting vsftpd service.."
rc-service vsftpd start >/dev/null 2>&1
sleep 3

while true;
do
	if ! pgrep vsftpd >/dev/null 2>&1 ; then
		echo "FTPS is down !"
		echo "Quitting.."
		exit 1
	else
		echo "FTPS is up!"
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
