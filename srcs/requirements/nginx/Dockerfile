FROM debian:12-slim

RUN apt-get update \ 
    && apt install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/* 

COPY /conf/nginx.conf /etc/nginx/nginx.conf 

COPY /tools/nginx.sh /usr/local/bin/nginx.sh

RUN chmod +x /usr/local/bin/nginx.sh 

EXPOSE 443 

ENTRYPOINT [ "/usr/local/bin/nginx.sh" ]