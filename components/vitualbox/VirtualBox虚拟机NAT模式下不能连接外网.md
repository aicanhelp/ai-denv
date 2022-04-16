### VirtualBox虚拟机NAT模式下不能连接外网  

#### 背景
　　给VirtualBox虚拟机（装载了Ubuntu16.04系统）配置了两张网卡，网络模式分别为“网络地址转换（NAT）”和“仅主机（Host-Only）适配器”，其中，enp0s3网卡（NAT）用于外网访问，而enp0s8网卡（Host-Only）用于主机访问虚拟机。然而，虚拟机启动后，却不能访问外网。

#### 定位
网络配置文件如下：
```
$ vi /etc/network/interface

...
The primary network interface
auto enp0s3
iface enp0s3 inet dhcp

auto enp0s8
iface enp0s8 inet static
address 192.168.137.16
netmask 255.255.255.0
gateway 192.168.137.1 
```

eth0使用dhcp，eth1使用static。eth0的实际网络如下：
```  

$ ifconfig   
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:fe55:2858  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:55:28:58  txqueuelen 1000  (Ethernet)
        RX packets 6  bytes 1476 (1.4 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 33  bytes 3108 (3.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

打开其路由，才发现了问题。

```
$ route -n  
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.137.1   0.0.0.0         UG    0      0        0 enp0s8
10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
192.168.137.0   0.0.0.0         255.255.255.0   U     0      0        0 enp0s8
```

enp0s8网卡成为了默认路由，这就导致其他路由不能匹配到的网段都会走enp0s8这个网卡，而我们实际上配置与外网连接的虚拟网卡是enp0s3，环境自然就连接不了外网了。我们可以尝试手动来删除现在的默认路由。  

```
$ route del default  
$ route add default gw 10.0.2.2 dev enp0s3  
$ route -n  

Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         gateway         0.0.0.0         UG    0      0        0 enp0s3
10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
192.168.137.0   0.0.0.0         255.255.255.0   U     0      0        0 enp0s8
```
　　路由设置成功，OS也可以访问外网了。但这只是修改了本次的路由设置，OS重启后就失效了，因此我们需要将配置持久化。

#### 持久化路由配置
　　我们将路由持久化设置在网络配置文件/etc/network/interfaces中。在网卡启动后添加对应的路由增删的代码，与route命令类似，只是在句首加上up即可。  
```
$ vi /etc/network/interfaces
...
auto enp0s3
iface enp0s3 inet dhcp
up route add default gw 10.0.2.2 dev enp0s3

auto enp0s8
iface enp0s8 inet static
address 192.168.137.16
netmask 255.255.255.0
gateway 192.168.137.1
up route del default dev enp0s8
```
　　注意：up route add default gw [gateway-addr] dev [dev-name]，该语句中，[dev-name]表示外网网卡的名称，即上面的enp0s3，而[gateway-addr]表示外网网卡使用的网关ip地址。
　　那么，如何获取这个外网网卡的网关地址呢？virtualbox如下规定：

In NAT mode, the guest network interface is assigned to the IPv4 range 10.0.x.0/24 by default where x corresponds to the instance of the NAT interface +2. So x is 2 when there is only one NAT instance active. In that case the guest is assigned to the address 10.0.2.15, the gateway is set to 10.0.2.2 and the name server can be found at 10.0.2.3.
　　简单的说，就是如果第0个网卡是NAT网卡，那么其网段的第三个数字就0+2=2就是10.0.2.0，网关为10.0.2.2，name server则是10.0.2.3.以此类推。