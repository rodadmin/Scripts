#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Do you want to install pve-no-subscription repository ? [y/n]"
read repo
if [ $repo = "y" ]; then
   echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list
   sed -i '1 s/^/#/' /etc/apt/sources.list.d/pve-enterprise.list
fi


apt update
apt upgrade -y
apt install -y htop

sed -i.bak "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service

echo "Do you want to restart the server ? [y/n]"
read reboot
if [ $reboot = "y" ]; then
    reboot
fi

echo "Proxmox Server successfully configured"

