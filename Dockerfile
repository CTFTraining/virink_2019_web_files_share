FROM openresty/openresty:alpine

LABEL Organization="CTFTraining" Author="Virink <virink@outlook.com>"
MAINTAINER Virink@CTFTraining <virink@outlook.com>

COPY _files /tmp
COPY src /usr/local/openresty/nginx/html

WORKDIR /usr/local/openresty/nginx/html/

RUN chown -R nobody:nobody /usr/local/openresty/nginx/html/uploads && \
    mv /tmp/nginx.conf /etc/nginx/conf.d/default.conf && \
    mv /tmp/start.sh /start.sh && \
    chmod +x /start.sh

CMD [ "/start.sh" ]