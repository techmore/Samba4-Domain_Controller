#!/bin/bash

if [ "$EUID" -ne 0 ] 
  then echo "Please run as root"
  exit
fi

read -p "Full Hostname ( ei dc1.example.lan ) : " newHostname  
domain=‘echo $newHostname | cut -d . -f 2,3’
ethernet=`ls  /sys/class/net | grep -v lo` 

apt-get update -y; apt-get upgrade -y; apt-get dist-upgrade -y
hostnamectl set-hostname $newHostname
reboot
