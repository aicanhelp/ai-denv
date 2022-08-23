### 在Ubuntu中如何设置临时的和永久的默认路由？ 

声明：我的操作系统是Ubuntu 18.4，如下所示：  
```
root@cnptucs1:~# lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.1 LTS
Release:	18.04
Codename:	bionic
```
所以设置静态IP地址和默认路由都是通过/etc/netplan/50-cloud-init.yaml文件来设置。我不确定我的设置方法是否适用于别的操作系统的情况。

    首先，设置临时的默认路由可以使用route add命令，假如比如我原来的默认路由对应的网卡是eno1，对应的网关为192.168.1.1，现在我想删除这个默认路由，并重新添加一个默认路由，使得对应的网卡为eno6，其对应的网关为0.0.0.0，则可以采用命令route add -net 0.0.0.0 netmask 0.0.0.0 dev eno6，如下图所示：
```
root@cnptucs1:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 eno1
10.0.0.0        0.0.0.0         255.255.255.0   U     0      0        0 eno6
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eno1
root@cnptucs1:~# route del -net 0.0.0.0 netmask 0.0.0.0 gw 192.168.1.1 dev eno1
root@cnptucs1:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.0.0.0        0.0.0.0         255.255.255.0   U     0      0        0 eno6
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eno1
root@cnptucs1:~# route add -net 0.0.0.0 netmask 0.0.0.0 dev eno6
root@cnptucs1:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         0.0.0.0         0.0.0.0         U     0      0        0 eno6
10.0.0.0        0.0.0.0         255.255.255.0   U     0      0        0 eno6
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eno1
```
    如果我们要设置永久性的默认路由，则我们需要对/etc/netplan/50-cloud-init.yaml文件进行更改。在我的主机上，该文件内容如下：
```
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses: [192.168.1.113/24]
            dhcp4: false
            dhcp6: false
            optional: true
            gateway4: 192.168.1.1
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
        eno2:
            addresses: [100.100.100.10/24]
            dhcp4: false
            optional: true
        eno5:
            addresses: []
            dhcp4: true
            optional: true
        eno6:
            addresses: [10.0.0.10/24]
            dhcp4: false
            optional: true
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
    version: 2
```
我们留意到在eno1条目下有一个以gateway4开头的项。该项在哪个网卡对应的条目下，哪个网卡就是默认路由对应的网卡，同时gateway4之后的IP地址指定了默认路由的网关地址，比如此时默认路由对应的网卡是eno1，对应的网关是192.168.1.1，如下图所示：



如果我们把gateway4的值改成0.0.0.0并使用netplan apply重新加载该文件，如下：
```
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses: [192.168.1.113/24]
            dhcp4: false
            dhcp6: false
            optional: true
            gateway4: 0.0.0.0
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
        eno2:
            addresses: [100.100.100.10/24]
            dhcp4: false
            optional: true
        eno5:
            addresses: []
            dhcp4: true
            optional: true
        eno6:
            addresses: [10.0.0.10/24]
            dhcp4: false
            optional: true
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
    version: 2
```
则可以看到它增加了一个以0.0.0.0为默认网关的默认路由，如下图所示：



 但是如果我们把机器重启，就可以看到默认路由的网关从192.168.1.1变成了0.0.0.0，如下图所示：



如果我们把gateway4这一项从eno1条目下移动到eno6条目下，如下所示：
```
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses: [192.168.1.113/24]
            dhcp4: false
            dhcp6: false
            optional: true
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
        eno2:
            addresses: [100.100.100.10/24]
            dhcp4: false
            optional: true
        eno5:
            addresses: []
            dhcp4: true
            optional: true
        eno6:
            addresses: [10.0.0.10/24]
            dhcp4: false
            optional: true
            gateway4: 0.0.0.0
            nameservers:
                addresses: [8.8.8.8,8.8.4.4]
    version: 2
```
使用netplan apply之后就可以看到默认路由的网卡变成了eno6，如下图所示：


