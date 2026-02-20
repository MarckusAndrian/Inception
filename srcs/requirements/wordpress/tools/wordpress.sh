#!/bin/bash

set -e

WP_PATH="/var/www/html"

echo "Starting WordPress setup..."

# Wait for MariaDB
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 2
done

echo "MariaDB is ready."

# Download WordPress if not already present
if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "Downloading WordPress..."

    cd /tmp
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz

    cp -rn /tmp/wordpress/* $WP_PATH/
    rm -rf /tmp/wordpress /tmp/latest.tar.gz
fi

# wp-config.php is already copied by the Dockerfile

# Set proper permissions
chown -R www-data:www-data $WP_PATH
chmod -R 755 $WP_PATH

echo "Launching PHP-FPM..."

mkdir -p /run/php
exec php-fpm8.2 -F
