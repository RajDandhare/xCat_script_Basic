#!/bin/bash
num_computes=2

echo "############################################ Install Utils ###########################################################"
yum -y install yum-utils

echo "################################################# wget xcat repo #####################################################"
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/latest/xcat-core/xcat-core.repo --no-check-certificate
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/xcat-dep/rh7/x86_64/xcat-dep.repo --no-check-certificate

echo "############################################# Install xCAT ###########################################################"
yum -y install xCAT
. /etc/profile.d/xcat.sh

echo "############################################# IP Config ##############################################################"
ifconfig ens36 192.168.1.1 netmask 255.255.255.0 up
chdef -t site dhcpinterfaces="xcatmn|ens36"
copycds /root/CentOS-7-x86_64-DVD-2009.iso

echo "############################################# Giving IPs #############################################################"
for ((i=0 ; i < $num_computes ; i++));
do
  n=$(($i+1))
  mkdef -t node cn$i groups=compute,all ip=$(head -$n ./ip_file | tail -1) mac=$(head -$n ./mac_file | tail -1) netboot=xnba arch=x86_64
done

echo "############################################# Creating user ##########################################################"
chtab key=system passwd.username=root passwd.password=root
chdef-t site domain="master.demo.lab"

echo "############################################# Making services ########################################################"
makehosts
makenetworks
makedhcp -n
makedns -n

echo "############################################ Nodeset #################################################################"
echo "osimages....."
echo "$(lsdef -t osimage)" > osfile
osi=$(head -1 ./osfile | tail -1 | cut -d " " -f 1)
nodeset compute osimage=$osi
