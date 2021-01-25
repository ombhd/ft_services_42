#!/bin/sh
#Author: Omar BOUYKOURNE  <omarbpixel@gmail.com>
#42login : obouykou

#install MetalLB
printf "\n\033[33m ◊ Installing and configuring MetalLB ===>  \033[0m" 

if	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml > /dev/null 2>&1 && \
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml > /dev/null 2>&1 && \
 	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" > /dev/null 2>&1 ;
then
	printf "\033[32m SUCCESS! ;)\033[0m\n"
else
	printf "\033[31m FAILURE! :(\033[0m\n"
	exit 1
fi

echo

exit 0
