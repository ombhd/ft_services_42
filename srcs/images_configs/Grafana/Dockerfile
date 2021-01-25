FROM alpine:3.12.3
LABEL maintainer="Omar BOUYKOURNE <omarbpixel@gmail.com>"

EXPOSE 3000

VOLUME [ "/sys/fs/cgroup" ]

#update and install utils
RUN apk update 1>/dev/null
#add the community repo for the repositories file reference, grafana and telegraf exists in that repo
RUN echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add grafana telegraf 1>/dev/null

#edit config file for file to link it with InfluxDB
RUN mkdir /etc/telegraf && \
	cp -f /etc/telegraf.conf /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  hostname = "".*|  hostname = "grafana"|' /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  # urls = \["http://127.0.0.1:8086"\].*|  urls = \["http://influxdb:8086"\]|' /etc/telegraf/telegraf.conf && \
	sed -i 's|^  # database = "telegraf"|  database = "influxdb"|' /etc/telegraf/telegraf.conf

ADD ./srcs/datasources/sample.yaml /usr/share/grafana/conf/provisioning/datasources/sample.yaml
ADD ./srcs/dashboards/sample.yaml /usr/share/grafana/conf/provisioning/dashboards/sample.yaml
ADD ./srcs/dashboards/*.json /usr/share/grafana/conf/provisioning/dashboards/


#copy the necessary files
ADD ./srcs/run.sh /usr/bin/run.sh
#make it exucutable
RUN chmod +x /usr/bin/run.sh


ENTRYPOINT /usr/bin/run.sh
