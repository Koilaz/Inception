FROM alpine:3.22

RUN apk update && apk add --no-cache vsftpd openssl

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/ftp_setup.sh /usr/local/bin/ftp_setup.sh

RUN chmod +x /usr/local/bin/ftp_setup.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/usr/local/bin/ftp_setup.sh"]