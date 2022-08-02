#!/bin/bash

MOUNTPOINT=$1

chmod +x /usr/bin/mount_space.sh
chmod +x /tmp/setup_mount.sh

export DEBIAN_FRONTEND=noninteractive

mount_space.sh $NFS $SHARED $MOUNTPOINT

mkdir -p /root/ctx
cp /tmp/php-fpm.conf /root/ctx/php-fpm.conf
cp /tmp/www.conf /root/ctx/www.conf
cp /tmp/Dockerfile /root/ctx/Dockerfile
cp /tmp/script.sh /root/ctx/script.sh
cd /root/ctx

sed -i 's/__addr__/0.0.0.0/g' ./www.conf

docker build -t php .
docker run -d \
	--restart unless-stopped \
	-p 9000:9000 \
	-v ${MOUNTPOINT}:/var/www \
	\
	-e WP_ADMIN_USER=${WP_ADMIN_USER} \
	-e WP_ADMIN_PASSWORD=${WP_ADMIN_PASS} \
	-e WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL} \
	-e WP_REG_USER=${WP_REG_USER} \
	-e WP_REG_USER_PASSWORD=${WP_REG_USER_PASS} \
	-e WP_URL=${WP_URL} \
	-e WP_FQDN=${WP_FQDN} \
	\
	--name php_container php
