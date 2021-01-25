FROM alpine:3.12.3
LABEL maintainer="Omar BOUYKOURNE <omarbpixel@gmail.com>"

EXPOSE 3306

VOLUME [ "/sys/fs/cgroup" ]

#update and install utils
RUN apk update 1>/dev/null
RUN apk add openrc 1>/dev/null

#add the community repo for the repositories packages file reference, telegraf exists in that repo
RUN echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add telegraf 1>/dev/null
#edit config file for file to link it with InfluxDB
RUN mkdir /etc/telegraf && \
	cp -f /etc/telegraf.conf /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  hostname = "".*|  hostname = "mysql"|' /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  # urls = \["http://127.0.0.1:8086"\].*|  urls = \["http://influxdb:8086"\]|' /etc/telegraf/telegraf.conf && \
	sed -i 's|^  # database = "telegraf"|  database = "influxdb"|' /etc/telegraf/telegraf.conf

RUN rc-status 1>/dev/null
RUN touch /run/openrc/softlevel


#install MySQL
RUN apk add mariadb mariadb-client 1>/dev/null

#copy the necessary files
ADD ./srcs/run.sh /usr/bin/run.sh
ADD ./srcs/wordpress.sql /
RUN chmod +x /usr/bin/run.sh

ENTRYPOINT /usr/bin/run.sh
