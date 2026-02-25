#!/bin/bash

# Create DB and config root & wpsuer

set -e

WP_PATH="/var/www/html"

echo "Starting WordPress setup..."

# Read secrets from Docker secret files if available, fallback to env vars
if [ -f /run/secrets/db_password ]; then
    WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
fi
if [ -f /run/secrets/credentials ]; then
    WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/credentials)
fi

# Wait for MariaDB to be fully ready
echo "Waiting for MariaDB to be ready..."
until mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SELECT 1" &>/dev/null; do
    echo "Waiting for Mariadb to be ready..."
    sleep 3
done
echo "MariaDB is ready."

# Install wp-cli if not present
# Interface in terminal for installing and setting WP
if [ ! -f /usr/local/bin/wp ]; then
    cd /tmp
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Download WordPress if not already present
if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "Downloading WordPress..."
    wp core download --path="$WP_PATH" --allow-root
fi

# Create wp-config.php if not present
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Creating wp-config.php..."
    wp config create --path="$WP_PATH" \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root
fi

# Install WordPress if not already installed
if ! wp core is-installed --path="$WP_PATH" --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install --path="$WP_PATH" \
        --url="https://kandrian.42.fr" \
        --title="Kandrian's Site" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root

    # Create second user 
    echo "Creating second user..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --role=editor \
        --path="$WP_PATH" \
        --allow-root
fi

# Fix permissions for nginx/php-fpm
echo "Setting permissions..."
chown -R www-data:www-data "$WP_PATH"
chmod -R 755 "$WP_PATH"

echo "Launching PHP-FPM..."

mkdir -p /run/php
exec php-fpm8.2 -F
