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

#checking for the brew, minikube and docker if they are installed
if ! which brew minikube docker > /dev/null 2>&1;
then
	echo "\033[31m Warning: Make sure you have brew, docker and minikube installed!\033[0m "
	exit 1
fi

if ! minikube status > /dev/null 2>&1;
then
	echo " Starting minikube Cluster.."
	echo
	if ! minikube start --vm-driver=virtualbox --memory=3g > /dev/null 2>&1; then
		echo "\033[31m Couldn't start minikube Cluster! :(\033[0m"
		echo
		exit 1
	fi
fi

exit 0
