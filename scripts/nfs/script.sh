#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y
apt install -y nfs-kernel-server curl wget

if [ $SHARED == "" ]; then
	SHARED="/srv/nfs"
fi

mkdir -p $SHARED

wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xzvf /tmp/wordpress.tar.gz -C $SHARED

cp /tmp/wp-config.php $SHARED/wordpress/wp-config.php

sed -i "s/database_name_here/$DB_NAME/g" $SHARED/wordpress/wp-config.php
sed -i "s/username_here/$DB_USER/g" $SHARED/wordpress/wp-config.php
sed -i "s/password_here/$DB_PASS/g" $SHARED/wordpress/wp-config.php
sed -i "s/localhost/$DB_HOST:$DB_PORT/g" $SHARED/wordpress/wp-config.php

wget -O /tmp/phpmyadmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz

tar -xzvf /tmp/phpmyadmin.tar.gz -C $SHARED
mv $SHARED/phpMyAdmin-5.2.0-all-languages $SHARED/phpmyadmin
cp /tmp/pma-config.inc.php $SHARED/phpmyadmin/config.inc.php

sed -i "s/database_name_here/$DB_NAME/g" $SHARED/phpmyadmin/config.inc.php
sed -i "s/username_here/$DB_USER/g" $SHARED/phpmyadmin/config.inc.php
sed -i "s/password_here/$DB_PASS/g" $SHARED/phpmyadmin/config.inc.php
sed -i "s/localhost/$DB_HOST:$DB_PORT/g" $SHARED/phpmyadmin/config.inc.php
sed -i "s/port_here/$DB_PORT/g" $SHARED/phpmyadmin/config.inc.php

chown -R www-data:www-data $SHARED
chmod -R 755 $SHARED

OPTIONS="rw,sync,no_subtree_check,root_squash,all_squash,anonuid=33,anongid=33"

cat <<EOF >/etc/exports
$SHARED/wordpress           $HOSTS($OPTIONS)
$SHARED/phpmyadmin          $HOSTS($OPTIONS)
EOF

systemctl restart nfs-kernel-server
systemctl enable nfs-kernel-server
showmount -e
