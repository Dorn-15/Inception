#!/bin/sh

# Vérification des variables d'environnement requises
if [ -z "$SQL_DB" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ]; then
    echo "Error: Required environment variables are not set"
    echo "Please make sure SQL_DB, SQL_USER, and SQL_PASSWORD are set"
    exit 1
fi

# Attendre que MariaDB soit prêt
echo "Waiting for MariaDB..."
while ! mariadb -h mariadb -u"$SQL_USER" -p"$SQL_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    sleep 1
done
echo "MariaDB is ready!"

# Vérifier si wp-config.php existe déjà
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Creating WordPress configuration..."
    # Créer la configuration WordPress
    wp config create --allow-root \
        --dbname="$SQL_DB" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=mariadb:3306 \
        --path='/var/www/wordpress'

    # # Ajouter les constantes pour forcer HTTPS et le port
    # wp config set WP_HOME "https://${DOMAIN_NAME}:8442" --allow-root --type=constant
    # wp config set WP_SITEURL "https://${DOMAIN_NAME}:8442" --allow-root --type=constant
    # wp config set FORCE_SSL_ADMIN true --allow-root --type=constant

    # Installer WordPress et créer l'administrateur principal
    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path='/var/www/wordpress'

    # Créer un utilisateur supplémentaire
    echo "Creating additional user..."
    wp user create --allow-root \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --path='/var/www/wordpress'

    # # Configuration des URLs WordPress avec le port
    # wp option update home "https://${DOMAIN_NAME}:8442" --allow-root
    # wp option update siteurl "https://${DOMAIN_NAME}:8442" --allow-root
fi

echo "Starting PHP-FPM..."
# Démarrer PHP-FPM
exec /usr/sbin/php-fpm82 -F
