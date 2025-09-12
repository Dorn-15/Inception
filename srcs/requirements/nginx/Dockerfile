FROM alpine:3.19

RUN apk update && apk upgrade && \
	apk add nginx openssl curl && \
	rm -rf /var/cache/apk/* && \
	mkdir -p /etc/nginx/ssl /var/run/nginx /var/www/wordpress

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chown -R nginx:nginx /var/www/wordpress && \
	chmod -R 755 /var/www/wordpress

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]

