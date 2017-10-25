#!/bin/bash

if [ "$EUID" -ne 0 ] 
  then echo "Please run as root"
  exit
 fi

read -p "Full Hostname ( ei dc1.example.lan ) : " newHostname  
domain=‘echo $newHostname | cut -d . -f 2,3’
ethernet=`ls  /sys/class/net | grep -v lo` 

# Setup static IP and local DNS

#cat <<EOF_interfaces >> /etc/network/interfaces 
#auto $ethernet
#iface $ethernet inet static
#   address 10.0.0.10
#   netmask 255.255.255.0
#   gateway 10.0.0.1
#   dns-nameservers 127.0.0.1 8.8.8.8
#   dns-search 
# EOF_interfaces

apt-get update -y; apt-get upgrade -y; apt-get dist-upgrade -y
hostnamectl set-hostname $newHostname
reboot
