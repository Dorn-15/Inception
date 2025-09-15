FROM alpine:3.19

EXPOSE 3306

RUN apk update && apk upgrade && \
	apk add mariadb mariadb-client && \
	rm -rf /var/cache/apk/* && \
	mkdir -p /run/mysqld /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
