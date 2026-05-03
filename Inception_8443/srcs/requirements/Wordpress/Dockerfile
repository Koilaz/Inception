FROM alpine:3.22

LABEL description="Homemade Wordpress Image"

# Install all necessary dependencies for WordPress and WP-CLI
RUN apk update && \
	apk add --no-cache \
	php82 \
	php82-fpm \
	php82-mysqli \
	php82-mbstring \
	php82-xml \
	php82-curl \
	php82-gd \
	php82-zip \
	php82-phar \
	php82-iconv \
	curl \
	tar && \
	ln -s /usr/bin/php82 /usr/bin/php

# Create a custom user with a hardcoded UID/GID for consistent permissions across containers
RUN addgroup -g 1000 user1 && adduser -u 1000 -G user1 -S user1

RUN mkdir -p /usr/src/wordpress \
	&& curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
	&& tar -xzf /tmp/wordpress.tar.gz -C /tmp \
	&& mv /tmp/wordpress/* /usr/src/wordpress/ \
	&& rm -rf /tmp/wordpress /tmp/wordpress.tar.gz \
	&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp


COPY tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
COPY conf/php.conf /etc/php82/php-fpm.d/www.conf

RUN chmod +x /usr/local/bin/setup_wordpress.sh

ENTRYPOINT [ "/usr/local/bin/setup_wordpress.sh" ]

