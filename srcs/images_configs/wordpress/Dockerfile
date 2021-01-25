FROM alpine:3.12.3
LABEL maintainer="Omar BOUYKOURNE <omarbpixel@gmail.com>"

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 5050

#update and install utils
RUN apk update 1>/dev/null
RUN apk add nginx 1>/dev/null
RUN apk add openrc 1>/dev/null

RUN rc-status 1>/dev/null
RUN touch /run/openrc/softlevel

#add the community repo for the repositories packages file reference, telegraf exists in that repo
RUN echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add telegraf 1>/dev/null
#edit config file for file to link it with InfluxDB
RUN mkdir /etc/telegraf && \
	cp -f /etc/telegraf.conf /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  hostname = "".*|  hostname = "wordpress"|' /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  # urls = \["http://127.0.0.1:8086"\].*|  urls = \["http://influxdb:8086"\]|' /etc/telegraf/telegraf.conf && \
	sed -i 's|^  # database = "telegraf"|  database = "influxdb"|' /etc/telegraf/telegraf.conf

#add www user in www group
RUN adduser -D -g 'www' www
RUN mkdir /www

#give permissions, -R is for recursion on directories and files
RUN chown -R www:www /var/lib/nginx /www

#download wordpress files
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz 1>/dev/null
RUN mv /wordpress /www
RUN rm -rf latest.tar.gz

RUN apk add php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json \
	php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath \
	php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc \
	php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype 1>/dev/null

#copy the necessary files
ADD ./srcs/nginx.conf /etc/nginx/nginx.conf
ADD ./srcs/wp-config.php /www/wordpress/wp-config.php
ADD ./srcs/run.sh /usr/bin/run.sh

#make it exucutable
RUN chmod +x /usr/bin/run.sh

RUN apk update

ENTRYPOINT /usr/bin/run.sh
