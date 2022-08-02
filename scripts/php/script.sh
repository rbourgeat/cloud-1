#!/bin/bash

service php7.4-fpm start
service php7.4-fpm stop

wp core install --allow-root \
	--url=$WP_URL \
	--title=42GameDev \
	--admin_user=$WP_ADMIN_USER \
	--admin_password=$WP_ADMIN_PASSWORD \
	--admin_email=$WP_ADMIN_EMAIL \
	--path=/var/www/wordpress

wp user create $WP_REG_USER "$WP_REG_USER@$WP_FQDN" \
	--allow-root \
	--role=author \
	--user_pass=$WP_REG_USER_PASSWORD \
	--path=/var/www/wordpress

php-fpm7.4 -F
