FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y mariadb-server \
 && rm -rf /var/lib/apt/lists/*

# Bind sur 0.0.0.0
RUN sed -ri 's/^#?bind-address.*/bind-address=0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306
VOLUME ["/home/adoireau/data/lib/mysql"]
ENTRYPOINT ["/entrypoint.sh"]
