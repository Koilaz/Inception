FROM alpine:3.22

RUN apk update && apk add --no-cache \
	mariadb \
	mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/maria.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/setup_mariadb.sh /usr/local/bin/setup_mariadb.sh

RUN chmod +x /usr/local/bin/setup_mariadb.sh

EXPOSE 3306

LABEL description="MariaDB client"

CMD ["/usr/local/bin/setup_mariadb.sh"]
