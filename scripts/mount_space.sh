#!/bin/bash

NFS=$1
SHARED=$2
MOUNTPOINT=$3

printf "Mounting space...\n" >/var/log/mount_space.log
printf "shared = $SHARED, mountpoint = $MOUNTPOINT\n" >>/var/log/mount_space.log

apt update
apt upgrade -y
apt install -y nfs-common

mkdir -p $MOUNTPOINT/{wordpress,phpmyadmin}
OPTIONS=hard,intr,rsize=262144,wsize=262144,timeo=600

cat <<EOF >>/etc/fstab

$NFS:$SHARED/wordpress		$MOUNTPOINT/wordpress	nfs4	$OPTIONS	0 0
$NFS:$SHARED/phpmyadmin		$MOUNTPOINT/phpmyadmin	nfs4	$OPTIONS	0 0
EOF

# Mounts all the NFS shares in the fstab file
mount -av >>/var/log/mount_space.log 2>&1
