#!/bin/bash

echo "#################################### Creating Ens.port ###########################################"
echo -e "TYPE=Ethernet\nPROXY_METHOD=none\nBROWSER_ONLY=no\nBOOTPROTO=none\nDEFROUTE=yes\nIPV4_FAILURE_FATAL=no\nIPV6INIT=yes\nIPV6_AUTOCONF=yes\nIPV6_DEFROUTE=yes\nIPV6_FAILURE_FATAL=no\nIPV6_ADDR_GEN_MODE=stable-privacy\nNAME=ens36\nUUID=6925de50-efdc-4dd7-92eb-4683f2c649e4\nDEVICE=ens36\nONBOOT=yes\nIPADDR=192.168.1.1\nPREFIX=24\nIPV6_PRIVACY=no" > /etc/sysconfig/network-scripts/ifcfg-ens36
systemctl restart network

echo "#################################### Hostname ############################################"
hostnamectl set-hostname master.demo.lab
hostname

echo "#################################### Firewalld ###########################################"
systemctl stop firewalld
systemctl disable firewalld

echo "#################################### Selinux #############################################"
echo -e "SELINUX=disabled\nSELINUXTYPE=targeted" > /etc/selinux/config
setenforce 0

init 6
