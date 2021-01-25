FROM alpine:3.12.3
LABEL maintainer="Omar BOUYKOURNE <omarbpixel@gmail.com>"

EXPOSE 21

VOLUME [ "/sys/fs/cgroup" ]

#update and install utils
RUN apk update
RUN apk add openrc
RUN apk add vsftpd
RUN apk add openssl openssh
RUN rc-status
RUN touch /run/openrc/softlevel

#add the community repo for the repositories packages file reference, telegraf exists in that repo
RUN echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add telegraf 1>/dev/null
#edit config file for file to link it with InfluxDB
RUN mkdir /etc/telegraf && \
	cp -f /etc/telegraf.conf /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  hostname = "".*|  hostname = "ftps"|' /etc/telegraf/telegraf.conf && \
	sed -i 's|.*  # urls = \["http://127.0.0.1:8086"\].*|  urls = \["http://influxdb:8086"\]|' /etc/telegraf/telegraf.conf && \
	sed -i 's|^  # database = "telegraf"|  database = "influxdb"|' /etc/telegraf/telegraf.conf

#generating an ssl certificate with openssl
RUN echo -e "MA\nKH\nKHOURIBGA\n1337Ltd\nOCP\nOCP SA\nft_services@1337.ma\n" | openssl req \
			-x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out \
			/etc/ssl/private/vsftpd.pem

#edit the vsftpd cofniguration file
RUN echo 'rsa_cert_file=/etc/ssl/private/vsftpd.pem' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'rsa_private_key_file=/etc/ssl/private/vsftpd.pem' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'ssl_enable=YES' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'allow_anon_ssl=NO' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'force_local_data_ssl=YES' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'force_local_logins_ssl=YES' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'ssl_tlsv1=YES' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'ssl_sslv2=NO' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'ssl_sslv3=NO' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'require_ssl_reuse=NO' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'ssl_ciphers=HIGH' >> /etc/vsftpd/vsftpd.conf \
	&& sed -i 's|.*anonymous_enable=YES.*|anonymous_enable=NO|' /etc/vsftpd/vsftpd.conf \
	&& sed -i 's|.*#local_enable=YES.*|local_enable=YES|' /etc/vsftpd/vsftpd.conf \
	&& sed -i 's|.*#write_enable=YES.*|write_enable=YES|' /etc/vsftpd/vsftpd.conf \ 
	&& sed -i 's|.*#chroot_local_user=YES.*|chroot_local_user=YES|' /etc/vsftpd/vsftpd.conf \ 
	&& echo 'allow_writeable_chroot=YES' >> /etc/vsftpd/vsftpd.conf \
	&& echo 'seccomp_sandbox=NO' >> /etc/vsftpd/vsftpd.conf \
	&& echo "pasv_enable=Yes" >> /etc/vsftpd/vsftpd.conf \
	&& echo "pasv_max_port=10100" >> /etc/vsftpd/vsftpd.conf \
	&& echo "pasv_min_port=10100" >> /etc/vsftpd/vsftpd.conf \
	&& echo "pasv_addr_resolve=YES" >> /etc/vsftpd/vsftpd.conf \
	&& echo "pasv_address=192.168.99.243" >> /etc/vsftpd/vsftpd.conf

RUN adduser -D admin && echo "admin:password" | chpasswd
RUN ssh-keygen -A

#copy the necessary files
ADD ./srcs/run.sh /usr/bin/run.sh
#make it exucutable
RUN chmod +x /usr/bin/run.sh


ENTRYPOINT /usr/bin/run.sh

