FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    curl \
    wget \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/wp-config.php /var/www/html/wp-config.php

RUN chmod +x /usr/local/bin/wordpress.sh

EXPOSE 9000

ENTRYPOINT [ "/usr/local/bin/wordpress.sh" ]