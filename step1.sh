#!/bin/bash

if [ "$EUID" -ne 0 ] 
  then echo "Please run as root"
  exit
 fi
sudo su

read -p “Full Hostname ( ei dc1.example.lan ) : “ new-hostname  
domain=‘echo $new-hostname | cut -d . -f 2,3’
ethernet=`ls  /sys/class/net | grep -v lo` 

# Setup static IP and local DNS

cat <<EOF_interfaces >> /etc/network/interfaces 
auto $ethernet
iface $ethernet inet static
   address 10.0.0.10
   netmask 255.255.255.0
   gateway 10.0.0.1
   dns-nameservers 127.0.0.1 8.8.8.8
   dns-search 
EOF_interfaces

apt-get update -y; apt-get upgrade -y; apt-get dist-upgrade -y
hostnamectl set-hostname $new-hostname
reboot
