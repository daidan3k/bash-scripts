#!/bin/sh

mkdir -p /mnt/shared
/usr/bin/vmhgfs-fuse .host:/"NFS Sudoers" /mnt/shared -o subtype=vmhgfs-fuse,allow_other,uid=1000,gid=1000,umask=0033
cp /mnt/shared/sudoers /etc/sudoers

umount -vvv --force /mnt/shared 2>/dev/null

while mount | grep -q "/mnt/shared"
do
	sleep 1
done

rmdir /mnt/shared
