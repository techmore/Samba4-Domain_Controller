#!/bin/bash

if [ "$EUID" -ne 0 ] 
  then echo "Please run as root"
  exit
 fi
 
read -p "Full Hostname ( ei dc1.example.lan ) : " newHostname  

domain=‘echo $newHostname | cut -d . -f 2,3’
ethernet=`ls  /sys/class/net | grep -v lo` 

apt-get -y install samba krb5-user krb5-config winbind libpam-winbind libnss-winbind

hostnamectl set-hostname $newHostname

apt-get update -y; apt-get upgrade -y; apt-get dist-upgrade -y

# OPENTECH.LAN
# opentech.lan
# opentech.lan

# Setup static IP and local DNS

cat <<EOF_interfaces >> /etc/network/interfaces 
auto $ethernet
iface $ethernet inet static
   address 10.0.0.10
   netmask 255.255.255.0
   gateway 10.0.0.1
   dns-nameservers 127.0.0.1 8.8.8.8
   dns-search $domain
EOF_interfaces

systemctl stop samba-ad-dc.service smbd.service nmbd.service winbind.service
systemctl disable samba-ad-dc.service smbd.service nmbd.service winbind.service

mv /etc/samba/smb.conf /etc/samba/smb.conf.initial

samba-tool domain provision --use-rfc2307 --interactive

mv /etc/krb6.conf /etc/krb5.conf.initial
ln –s /var/lib/samba/private/krb5.conf /etc/

systemctl start samba-ad-dc.service
systemctl status samba-ad-dc.service
systemctl enable samba-ad-dc.service

# netstat –tulpn| egrep ‘smbd|samba’

samba-tool domain level show

ping -c 4 'hostname'
ping -c 4 'hostname | cut -d . -f 2,3'
ping -c 4 'hostname | cut -d . -f 1'
