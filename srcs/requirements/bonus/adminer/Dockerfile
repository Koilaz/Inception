FROM alpine:3.22

RUN apk add --no-cache \
        php83 \
        php83-fpm \
        php83-mysqli \
        php83-session \
        curl \
    && mkdir -p /var/www \
    && curl -fsSL https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php \
        -o /var/www/adminer.php \
    && chown -R nobody:nobody /var/www

COPY conf/php-fpm.conf /etc/php83/php-fpm.d/www.conf

EXPOSE 9000

CMD ["php-fpm83", "-F"]
