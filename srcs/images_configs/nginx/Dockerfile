FROM alpine:3.12.3
LABEL maintainer="Omar BOUYKOURNE <omarbpixel@gmail.com>"

EXPOSE 80
EXPOSE 443
EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]

#update and install utils
RUN apk update
RUN apk add nginx
RUN apk add openrc
RUN apk add openssh
RUN rc-status
RUN touch /run/openrc/softlevel

#add the community repo for the repositories packages file reference, telegraf exists in that repo
RUN echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add telegraf 1>/dev/null
#edit config file for file to link it with InfluxDB
RUN mkdir /etc/telegraf && \
	cp -f /etc/telegraf.conf /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  hostname = "".*|  hostname = "nginx"|' /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  # urls = \["http://127.0.0.1:8086"\].*|  urls = \["http://influxdb:8086"\]|' /etc/telegraf/telegraf.conf && \
	sed -i 's|^  # database = "telegraf"|  database = "influxdb"|' /etc/telegraf/telegraf.conf

#add www user in www group
RUN adduser -D -g 'www' www
RUN mkdir /www

#give permissions, -R is for recursion on directories and files
RUN chown -R www:www /var/lib/nginx /www

#install openssl to generate an ssl certificate with it
RUN apk add openssl
RUN echo -e "MA\nKH\nKHOURIBGA\n1337Ltd\nOCP\nOCP SA\nft_services@1337.ma\n" | openssl req \
    -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt >/dev/null 2>&1

#copy the necessary files
ADD ./srcs/nginx.conf /etc/nginx/nginx.conf
ADD ./srcs/index.html /www/index.html
ADD ./srcs/imgs /www/imgs
ADD ./srcs/run.sh /usr/bin/run.sh
#make it exucutable
RUN chmod +x /usr/bin/run.sh

RUN echo "root:password" | chpasswd
#make the root able to connect via ssh
RUN sed -i 's|.*#PermitRootLogin prohibit-password.*|PermitRootLogin yes|' /etc/ssh/sshd_config
RUN ssh-keygen -A

ENTRYPOINT /usr/bin/run.sh
