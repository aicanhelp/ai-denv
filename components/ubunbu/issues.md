#### 1、CA问题:
我遇到了同样的问题，必须将.pem文件复制到/usr/local/share/ca-certificates，并将其重命名为.crt。例如，如果您没有.pem，则可以使用openssl轻松将.cer文件转换为.pem。

复制文件后，必须执行sudo update-ca-certificates。

openssl x509 -inform DER -in certificate.cer -out certificate.crt
openssl x509 -inform PEM -in certificate.cer -out certificate.crt


快捷键，没有printSrc键时，用fn+insert


#### 2、没有add to favorite
需要/usr/share/applictions中对应的*.desktop文件中增加 StartupWMClass。同时，
*.desktop文件的文件名改为${VM_Class}.desktop. 这时，应用程序启动后，就有add to favorite了
有关获取VMClass：
启动应用程序，然后小窗口启动一个termial，运行'xprop|grep WM_CLASS',然后鼠标点击一下应用程序的窗口，terminal中就会返回该应用程序的WM_Class.


【经验分享】Ubuntu上添加可信任根证书
1. 如果是pem格式的根证书，先重命名为 .crt格式，例如（ mitmproxy-ca-cert.crt）。
2. sudo cp  mitmproxy-ca-cert.crt  /usr/local/share/ca-certificates/
3. sudo update-ca-certificates

update-ca-certificates命令将PEM格式的根证书内容附加到/etc/ssl/certs/ca-certificates.crt ，而/etc/ssl/certs/ca-certificates.crt 包含了系统自带的各种可信根证书.

#### 3、wifi慢
（查看wifi网卡lshw -C network）

- /etc/modprobe.d/iwlwifi.conf
在打开的这个配置文件中空白处添加：options iwlwifi 11n_disable=8
options iwlwifi power_save=0

- /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf中的wifi.powersave = 3 改为= 0。


- 检查您的WiFi MTU与ip link。如果您的MTU是1500，您正在遭受“数据包碎片”，并发送2个数据包，您认为您正在发送。对于WiFi，您应该通过执行sudo ip link set dev wlx18d6c70b2c17 mtu 1492将MTU设置为1492 (WiFi增加了8字节的开销)。实际上，这应该由您的DHCP服务器来设置

- 禁用ipv6
- sudo vim /etc/default/avahi-daemon 修改为 AVAHI_DAEMON_DETECT_LOCAL = 0 本身值为 1

- 修改网络参数：
    
    sudo sysctl -w net.ipv4.tcp_slow_start_after_idle=0
    sudo sysctl -w net.ipv4.tcp_tw_reuse=1

    sudo sysctl -w net.ipv4.tcp_tw_recycle=1

    sudo sysctl -w net.ipv4.tcp_fin_timeout=30

    sudo sysctl -w net.ipv4.tcp_keepalive_time=120
   
    sudo sysctl -w net.ipv4.tcp_window_scaling = 1

- 修改网卡缓冲
sudo sysctl -w net.core.rmem_default=262144
sudo sysctl -w net.core.rmem_max=4194304

- ubuntu默认使用ipv6，修改关闭
sudo vim /etc/gai.conf # gai 是 GetAddrInfo()缩写
定位到#precedence ::ffff:0:0/96 100
移除#
保存文件并退出：shift + zz (ZZ)
重新启动。