#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login : obouykou

#Creating Deployments and services
printf "\n\033[33m ◊ Creating Deployments and services ... \033[0m\n" 
sleep 1

apply_yaml()
{
	printf "\n\033[33m %s .. ====> \033[0m" "$1"
	if [ "$1" != "mysql-secret" ]; then
		path_of_yaml="./srcs/yaml_configs/$1-config.yaml"
	else
		path_of_yaml="./srcs/yaml_configs/$1.yaml"
	fi
	sleep 0.2
	if kubectl apply -f "$path_of_yaml" > /dev/null 2>&1;
	then
		printf "\033[32m SUCCESS! ;)\033[0m\n"
		sleep 0.2
		return 0
	fi
	printf "\033[31m FAILURE! :(\033[0m\n"
	sleep 0.2
	exit 1
}

#metallb
apply_yaml metallb

#mysql
apply_yaml mysql-secret
apply_yaml mysql

#influxdb
apply_yaml influxdb

#nginx
apply_yaml nginx

#phpmyadmin
apply_yaml phpmyadmin

#wordpress
apply_yaml wordpress

# grafana
apply_yaml grafana

#ftps
apply_yaml ftps

echo

exit 0

