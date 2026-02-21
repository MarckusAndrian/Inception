FROM debian:12-slim

RUN apt-get update \
    && apt-get install -y mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/mysqld \
    && chown mysql:mysql /run/mysqld

COPY /tools/mariadb.sh /usr/local/bin/mariadb.sh

RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/mariadb.sh" ]