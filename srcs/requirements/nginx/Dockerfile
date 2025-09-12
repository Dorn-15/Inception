FROM debian:bookworm-slim

RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl vim curl && \
    mkdir -p /etc/nginx/ssl /var/run/nginx /var/www/wordpress

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=localhost"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chown -R www-data:www-data /var/www/wordpress && \
    chmod -R 755 /var/www/wordpress

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]

