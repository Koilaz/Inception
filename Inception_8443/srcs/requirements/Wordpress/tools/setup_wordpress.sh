#!/bin/sh
set -e

mkdir -p /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Initializing WordPress files in /var/www/html"
	cp -a /usr/src/wordpress/. /var/www/html/

	echo "Configuring WordPress via WP-CLI..."
	cd /var/www/html

	# Create wp-config.php
	wp config create \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass=$(cat /run/secrets/db_password) \
		--dbhost="mariadb:3306" \
		--allow-root

		# Install WordPress core
		wp core install \
			--url="https://$DOMAIN_NAME" \
			--title="My Inception" \
			--admin_user=$(cat /run/secrets/wp_admin_user) \
			--admin_password=$(cat /run/secrets/wp_admin_password) \
			--admin_email="$WP_ADMIN_EMAIL" \
			--allow-root

	# Create a second normal user
	wp user create \
		"${WP_NORMAL_USER}" \
		"${WP_NORMAL_EMAIL}" \
		--role="author" \
		--user_pass=$(cat /run/secrets/wp_normal_password) \
		--allow-root

	# Install Redis plugin
	wp plugin install redis-cache --activate --allow-root
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_REDIS_PORT 6379 --raw --allow-root
	wp redis enable --allow-root

	echo "WordPress configured successfully!"
else
	echo "WordPress is already configured."
fi

chown -R user1:user1 /var/www/html

exec php-fpm82 -F
