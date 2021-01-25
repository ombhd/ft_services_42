#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login : obouykou

clear
#banner
printf	"\n\n\033[1;34m	█▀▀ ▀█▀    █▀ █▀▀ █▀█ █░█ █ █▀▀ █▀▀ █▀\033[0m\n"
printf 	"\033[1;34m	█▀░ ░█░ ▀▀ ▄█ ██▄ █▀▄ ▀▄▀ █ █▄▄ ██▄ ▄█\033[0m\n"
printf	"\n		  		  By: "
printf	"\033[33m𝒐𝒃𝒐𝒖𝒚𝒌𝒐𝒖\033[0m\n\n"

sleep 1

if [ "$1" = "metallb" ]; then
	#installing and configuring MetalLB
	if ! ./srcs/setup_utils/MetalLB_installer.sh; then
		printf "\033[33m Failed to install and configure MetalLB, Quitting ..\n\n\033[0m"
		exit 1
	fi
	exit 0
fi


if	kubectl get deployment "$1" > /dev/null 2>&1 ; then
	printf "\n\033[33m ◊ Removing Deployment and service of %s ====> \033[0m" "$1" 
	sleep 1
	if	kubectl delete deployment "$1" > /dev/null 2>&1 && \
		kubectl delete service "$1" > /dev/null 2>&1 ;
	then
		printf "\033[32m DONE! ;)\033[0m\n\n"
		sleep 0.2
	else
		printf "\033[31m FAILURE! :(\033[0m\n\n"
		sleep 0.2
		exit 1
	fi
fi

sleep 1

dockerfile_path="./srcs/images_configs/$1/"
container_img="$1"


#removing image
printf "\033[33m ◊ Removing image of %s .. ====> \033[0m" "$1"
sleep 1

if docker rmi -f "$container_img" > /dev/null 2>&1;
then
	printf "\033[32m SUCCESS! ;)\033[0m\n\n"
	sleep 0.2
else
	printf "\033[31m FAILURE! :(\033[0m\n\n"
	printf "\033[33m Maybe you need to run this first [ \033[34meval \$(minikube docker-env)\033[33m ] \033[0m\n\n"
	sleep 0.2
	exit 1
fi

#building image
printf "\033[33m ◊ Building image for %s .. ====> \033[0m" "$1"
sleep 1

if docker build -t "$container_img" "$dockerfile_path" > /dev/null 2>&1;
then
	printf "\033[32m SUCCESS! ;)\033[0m\n\n"
	sleep 0.2
else
	printf "\033[31m FAILURE! :(\033[0m\n\n"
	sleep 0.2
	exit 1
fi


#Creating Deployment and service
printf "\033[33m ◊ Creating Deployment and service for %s .. ====> \033[0m" "$1"
sleep 1

apply_yaml()
{
	path_of_yaml="./srcs/yaml_configs/$1-config.yaml"
	sleep 0.2
	if kubectl apply -f "$path_of_yaml" > /dev/null 2>&1;
	then
		printf "\033[32m SUCCESS! ;)\033[0m\n\n"
		sleep	0.2
		exit 	0
	fi
	printf "\033[31m FAILURE! :(\033[0m\n\n"
	sleep	0.2
	exit	1
}

apply_yaml	"$1"

echo

exit 0