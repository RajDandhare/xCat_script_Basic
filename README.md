# xCat_script

This is Basic Boot script fot Multiple Nodes.

#This scripts will only work on Linux.
And only Boot CentOS7.9 in compute nodes.

This All Projects is Done in using VMs.

#You might need to edit the script for IPs and ens port names (Default IP:192.168.1.1 portName:ens)

Master Node system configuration:
 RAM - 4GB Sockets - 2 (you can use one socket too)
 Core - 1 (if you use one socket you might need tow cores)
 Network Adapters - Two Adapter one for NAT and other for hostonly

Compute Nodes system configuration:
 Network Adapters - one Adapter hostonly
 For Stateless:
   RAM - 8GB (you will need more RAM because it will boot on RAM without storage disk)
   Sockets - 2 (you can use one socket too)
   Core - 1 (if you use one socket you might need tow cores)

 For Statefull:
   RAM - 4GB Sockets - 2 (you can use one socket too)
   Sockets - 2 (you can use one socket too)
   Core - 1 (if you use one socket you might need tow cores)

All computer nodes must be in same network adaptor name.

First CentOS ios file must be present in the script folder (stateless/statefull). link or CentOS7 ios file : https://mirrors.nxtgen.com/centos-mirror/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2207-02.iso

Steps:

1. first run common installation script ('bash <script_name>') (might need to change the ens port number in script)

2. You just need to run the bash script in the folders. just select one of the boot process stateless or statefull as per requirement.(might need to change the ens port number in script)

3. After the scripting finishes you just need to start/restart the compute nodes.

computer node's username and password will be 'root' to login.


Reference URL Links:

1. https://github.com/openhpc/ohpc/releases/download/v1.3.9.GA/Install_guide-CentOS7-xCAT-Stateless-SLURM-1.3.9-x86_64.pdf
2. https://github.com/openhpc/ohpc/releases/download/v1.3.9.GA/Install_guide-CentOS7-xCAT-Stateful-SLURM-1.3.9-x86_64.pdf