#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login : obouykou

eval "$(minikube docker-env)"

#building images
printf "\n\033[33m ◊ Building images ...  \033[0m\n" 
sleep 1

docker_img_builder()
{
	printf "\n\033[33m %s .. ====> \033[0m" "$1" 
	sleep 0.2
	if docker build -t "$1" "$2" > /dev/null 2>&1;
	then
		printf "\033[32m SUCCESS! ;)\033[0m\n"
		sleep 0.2
		return 0
	fi
	printf "\033[31m FAILURE! :(\033[0m\n"
	sleep 0.2
	exit 1
}

nginx_path="./srcs/images_configs/nginx/"
nginx_img="nginx"

pma_path="./srcs/images_configs/phpMyAdmin/"
pma_img="phpmyadmin"

mysql_path="./srcs/images_configs/mysql/"
mysql_img="mysql"

ftps_path="./srcs/images_configs/ftps/"
ftps_img="ftps"

wp_path="./srcs/images_configs/wordpress/"
wp_img="wordpress"

grafana_path="./srcs/images_configs/Grafana/"
grafana_img="grafana"

influxdb_path="./srcs/images_configs/influxDB/"
influxdb_img="influxdb"

docker_img_builder $nginx_img $nginx_path
docker_img_builder $pma_img $pma_path
docker_img_builder $mysql_img $mysql_path
docker_img_builder $ftps_img $ftps_path
docker_img_builder $wp_img $wp_path
docker_img_builder $grafana_img $grafana_path
docker_img_builder $influxdb_img $influxdb_path

echo
exit 0
