#!/bin/bash 
num_computes=2

echo "######################################### install from http rpm file ##############################################"
yum -y install http://build.openhpc.community/OpenHPC:/1.3/CentOS_7/x86_64/ohpc-release-1.3-1.el7.x86_64.rpm

echo "#################################### installing yum-utils ##############################################"
yum -y install yum-utils

echo "############################### xCat repositorys #####################################"
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/latest/xcat-core/xcat-core.repo --no-check-certificate
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/xcat-dep/rh7/x86_64/xcat-dep.repo --no-check-certificate

echo "######################### install ohpc #####################################"
yum -y install ohpc-base 
echo "########################### install xcat #################################"
yum -y install xCAT
echo "################################# excute xcat script ########################"
. /etc/profile.d/xcat.sh

echo "################################# ntpd.service #########################"
systemctl enable ntpd.service
echo "server 192.168.1.1 iburst" >> /etc/ntp.conf
systemctl restart ntpd

echo "server 192.168.1.1 iburst" >> /etc/chrony.conf
echo "local stratum 10" >> /etc/chrony.conf
systemctl start chronyd.service

echo "########################### copy iso image ##################################"
copycds /root/CentOS-7-x86_64-DVD-2009.iso

echo "############################### Exporting image #################################"
export CHROOT=/install/netboot/centos7.7/x86_64/compute/rootimg/

echo "########################### Createig node #################################"

for ((i=0 ; i < $num_computes ; i++));
do
  n=$(($i+1))
  mkdef -t node cn$i groups=compute,all ip=$(head -$n ./ip_file | tail -1) mac=$(head -$n ./mac_file | tail -1) netboot=xnba arch=x86_64
done

chdef -t site domain="master.demo.lab"
chdef -t site master="192.168.1.1"
chdef -t site forwarders="192.168.1.1"
chdef -t site nameservces="192.168.1.1"
chtab key=system passwd.username=root passwd.password=root

echo "################# Genimage ###################"
echo "osimages....."
echo "$(lsdef -t osimage)" > osfile
osi=$(head -2 ./osfile | tail -1 | cut -d " " -f 1)
genimage $osi

echo "#################### packimage ###################"
packimage $osi

echo "################# Make command #####################"
makehosts
makenetworks
makedhcp -n
makedhcp -a
makedns -n
makedns -a

xcatprobe xcatmn -i ens36
sleep 5

echo "########################### Nodeset ###############################"
nodeset compute osimage=$osi
