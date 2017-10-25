#!/bin/bash

if [ "$EUID" -ne 0 ] 
  then echo "Please run as root"
  exit
 fi
sudo su

apt-get install samba krb5-user krb5-config winbind libpam-winbind libnss-winbind

# OPENTECH.LAN
# opentech.lan
# opentech.lan

systemctl stop samba-ad-dc.service smbd.service nmbd.service winbind.service
systemctl disable samba-ad-dc.service smbd.service nmbd.service winbind.service

mv /etc/samba/smb.conf /etc/samba/smb.conf.initial

samba-tool domain provision --use-rfc2307 --interactive

mv /etc/krb6.conf /etc/krb5.conf.initial
ln –s /var/lib/samba/private/krb5.conf /etc/

systemctl start samba-ad-dc.service
systemctl status samba-ad-dc.service
systemctl enable samba-ad-dc.service

netstat –tulpn| egrep ‘smbd|samba’

samba-tool domain level show

ping -c 4 `hostname`
ping -c 4 `hostname | cut -d . -f 2,3`
ping -c 4 `hostname | cut -d . -f 1
