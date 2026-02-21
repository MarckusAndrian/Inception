#!/bin/bash

set -e

# Read secrets from Docker secret files if available, fallback to env vars
if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi
if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d /var/lib/mysql/${MYSQL_DATABASE} ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Starting temporary MariaDB server for initialization..."
    mysqld --user=mysql --skip-networking &
    pid=$!

    # Wait for the temporary server to be ready
    until mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done

    echo "Creating database and user..."
    mysql -u root <<-EOF
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
	EOF

    echo "Stopping temporary server..."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$pid"
    echo "MariaDB initialization complete."
fi

exec mysqld --user=mysql --bind-address=0.0.0.0