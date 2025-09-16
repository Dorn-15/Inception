FROM alpine:3.19

# Installation des dépendances nécessaires
RUN apk update && apk upgrade && \
    apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-dom \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    mariadb-client \
    wget

# Téléchargement et installation de WordPress
RUN wget https://fr.wordpress.org/wordpress-6.8.2-fr_FR.tar.gz -P /var/www && \
    cd /var/www && tar -xzf wordpress-6.8.2-fr_FR.tar.gz && rm wordpress-6.8.2-fr_FR.tar.gz && \
    chown -R nobody:nobody /var/www/wordpress

# Installation de WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configuration de PHP-FPM
COPY ./conf/www.conf /etc/php82/php-fpm.d/www.conf

# Copie du script d'initialisation
COPY ./tools/auto_config.sh /auto_config.sh
RUN chmod +x /auto_config.sh

# Création du dossier pour PHP-FPM
RUN mkdir -p /run/php

WORKDIR /var/www/wordpress

EXPOSE 9000

ENTRYPOINT ["/auto_config.sh"]
