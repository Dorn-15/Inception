#!/bin/sh
set -e

DB_HOST="mariadb:3306"
DB_NAME="${MYSQL_DATABASE}"
DB_USER="${MYSQL_USER}"
DB_PASS="$(cat /run/secrets/db_password.txt)"
SITE_URL="https://${DOMAIN_NAME}"
ADMIN_USER="${WP_ADMIN}"
ADMIN_PASS="$(cat /run/secrets/credentials.txt)"
ADMIN_EMAIL="${WP_ADMIN_EMAIL}"
TITLE="${WP_TITLE}"

# Attendre la DB
i=0
until mariadb -h mariadb -u"${DB_USER}" -p"${DB_PASS}" -e "SELECT 1" >/dev/null 2>&1; do
	i=$((i+1))
	if [ $i -gt 60 ]; then echo "DB indisponible"; exit 1; fi
	sleep 1
done

# Installer WordPress si absent
if [ ! -f wp-config.php ]; then
	wp core download --allow-root
	wp config create --allow-root \
		--dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASS}" --dbhost="${DB_HOST}" \
		--path=/var/www/html

	wp core install --allow-root \
		--url="${SITE_URL}" --title="${TITLE}" \
		--admin_user="${ADMIN_USER}" --admin_password="${ADMIN_PASS}" --admin_email="${ADMIN_EMAIL}" \
		--skip-email
fi

# Démarrer php-fpm en avant-plan
exec php-fpm8.2 -F
