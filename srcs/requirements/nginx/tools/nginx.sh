#!/bin/bash

set -e

echo "Nginx starting..."

if [ ! -f /etc/ssl/certs/nginx.crt ]; then
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=MG/ST=Analamanga/L=Antananarivo/O=42/CN=kandrian.42.fr"
fi

nginx -g "daemon off;"