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
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="mariadb" \
		--allow-root

	# Install WordPress core
	wp core install \
		--url="https://localhost:8443" \
		--title="My Inception" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--allow-root

	# Create a second normal user as required by the subject (not an admin)
	wp user create \
		"${WP_NORMAL_USER}" \
		"${WP_NORMAL_EMAIL}" \
		--role="author" \
		--user_pass="${WP_NORMAL_PASSWORD}" \
		--allow-root

	echo "WordPress configured successfully!"
else
	echo "WordPress is already configured."
fi

chown -R user1:user1 /var/www/html

exec php-fpm82 -F
