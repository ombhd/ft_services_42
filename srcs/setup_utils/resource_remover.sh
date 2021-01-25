#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login : obouykou

#Deleting Deployments and services
if	minikube status > /dev/null 2>&1; then
	printf "\n\033[33m ◊ Removing Deployments and services ==> \033[0m" 
	sleep 1
	if	kubectl delete deployments --all > /dev/null 2>&1 && \
		kubectl delete services --all > /dev/null 2>&1 ;
	then
		printf "\033[32m DONE! ;)\033[0m\n\n"
		sleep 0.2
		exit 0
	fi
	printf "\033[31m FAILURE! :(\033[0m\n\n"
	sleep 0.2
	exit 1
fi

echo
