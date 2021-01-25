#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login: obouykou

echo "Starting telegraf .."
telegraf &

echo "Changing password for admin .."
if  cd /usr/share/grafana ; then
	if ! grafana-cli admin reset-admin-password 'password' > /dev/null 2>&1; then
		echo "Couldn't Change the admin password :("
		exit 1
	fi
fi

echo "Starting grafana in background .."
( if ! grafana-server  >/dev/null 2>&1 ; then
	echo "Couldn't start grafana :("
	exit 1
fi ) &

sleep 2

while true;
do
	if ! pgrep grafana-server >/dev/null 2>&1 ; then
		echo "grafana Service is down !"
		echo "Quitting.."
		exit 1
	else
		echo "grafana is up!"
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
