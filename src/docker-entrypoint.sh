#!/bin/sh

addgroup \
	-g $GID \
	-S \
	$FTP_USER

adduser \
	-D \
	-G $FTP_USER \
	-h /home/$FTP_USER \
	-s /bin/false \
	-u $UID \
	$FTP_USER

mkdir -p /home/$FTP_USER
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

if [ ! -d /config ] 
then
    echo "/config didn't exist" 
    mkdir -p /config 
fi
if [ ! -e /config/vsftpd.conf ] 
then
    echo "/config/vsftpd.conf didn't exist" 
    cp /etc/vsftpd.conf /config/vsftpd.conf 
fi

mkdir -p /var/log/vsftpd
touch /var/log/vsftpd/vsftpd.log
tail -f /var/log/vsftpd/vsftpd.log &

exec "$@"
