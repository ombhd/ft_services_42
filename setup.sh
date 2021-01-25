#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login: obouykou


clear
#Removing resources
if [ "$1" = "remove" ]; then
	if ! ./srcs/setup_utils/resource_remover.sh ; then
		printf "\033[33m Failed to remove one or many resources, Quitting ..\n\n\033[0m"
		exit 1
	fi
	exit 0
fi

#Setup only one deployment
if [ "$1" = "only" ] && [ "$#" = "2" ]; then

	if ! ./srcs/setup_utils/just_one_deploy.sh "$2" ; then
		printf "\033[33m Failed to rebuild resources, Quitting ..\n\n\033[0m"
		exit 1
	fi
	exit 0
fi

printf "\n\033[33m ◊ Removing minikube ==> \033[0m" 
sleep 1
if	minikube delete > /dev/null 2>&1;
	then
		printf "\033[32m DONE! ;)\033[0m\n\n"
		sleep 0.2
	else
		printf "\033[31m FAILURE! :(\033[0m\n\n"
		sleep 0.2
		exit 1
	fi

sleep 1

#check for the neccesary tools to build the project
if ! ./srcs/setup_utils/env_checker.sh ; then
	printf "\033[33mQuitting ..\n\n\033[0m"
	exit 1
fi

#build the images
if ! ./srcs/setup_utils/images_builder.sh; then
	printf "\033[33m\n Failed to build a docker image, Quitting .. \n\n\033[0m"
	exit 1
fi

#installing and configuring MetalLB
if ! ./srcs/setup_utils/MetalLB_installer.sh; then
	printf "\033[33m Failed to install and configure MetalLB, Quitting ..\n\n\033[0m"
	exit 1
fi

if ! ./srcs/setup_utils/depls_srvcs_creator.sh; then
	printf "\033[33m Failed to apply one or more yaml configurations, Quitting ..\n\n\033[0m"
	exit 1
fi
