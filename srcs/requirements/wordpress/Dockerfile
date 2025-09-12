FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-cli curl less unzip \
 && rm -rf /var/lib/apt/lists/*

# Installer wp-cli
RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp

# php-fpm écoute en 9000
RUN sed -ri 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

WORKDIR /home/adoireau/data/www/html
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
