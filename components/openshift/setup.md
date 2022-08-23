## 关于CRC - Codeready Container
### CRC功能定位

通常一套正式的OpenShift集群至少需要3个物理或虚拟节点，这对于一般技术人员学习产品或开发大多数应用显然是比较高的环境。为了降低OpenShift开发学习的门槛，Redhat为用户提供了一个可以单机运行的OpenShift（Codeready Container - CRC）环境。CRC是直接运行在虚拟机中，当我们下载虚拟机并启动后，一个OpenShift环境就运行起来了。

### 准备运行环境
#### 运行环境要求

CRC是一个最小的OpenShift环境，运行过程需要的所有资源需要在线下载，因此他必须在一个能访问Internet的环境中运行。RedHat目前提供Linux-KVM、Mac-HyperKit和Windows-HyperV三种格式的CRC虚拟机文件，我们可以根据自己的环境下载对应的CRC文件。

另外你还需要一个 https://developers.redhat.com 的有效用户，用来下载允许 CRC 从 RedHat 网站拉取镜像的 pull secret 文件。

运行CRC的最低硬件环境如下，但是为了能够更好地运行，建议能提供更多的内存。

    4 vCPUs
    10 GB 空余内存
    35 GB 存储

注意：如果运行CRC的宿主机也是一个虚拟机，需要打开虚拟化软件的嵌套功能，以允许在宿主虚拟机中运行CRC虚拟机、

如果使用Linux作为CRC的宿主机操作系统，建议使用 RHEL/CentOS 7.5或更高版本(本文使用的是RHEL 7.8)。如果使用其它 Linux，可参见“参考文档”。
创建用户

请用 root 用户完成以下操作。

创建一个用户（例如 “crc”），并将他加入到“wheel”组中（会自动拥有sudoer）。

$ useradd crc -G wheel

#### 安装KVM虚拟化组件

RHEL/CentOS 的环境可以分别执行以下命令安装CRC所需要的 libvirt 和 NetworkManager 组件：

$ yum install -y virt-manager libvirt libvirt-python python-virtinst libvirt-client
$ yum install -y qemu-kvm qemu-img
$ yum install -y NetworkManager


#### 下载CRC和Pull Secret

请用 crc 用户完成以下操作。
从https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/下载Linux、Mac和Windows平台的CRC虚拟机文件。本文使用的基于RHEL的Linux环境，因此下载 crc-linux-amd64.tar.xz 文件即可。

$ curl -o ~/crc-linux-amd64.tar.xz https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz
$ tar -xvf ~/crc-linux-amd64.tar.xz
$ cd ~/crc-linux-1.32.1-amd64
$ export PATH=$PATH:~/crc-linux-1.32.1-amd64


登录 https://cloud.redhat.com/openshift/install/pull-secret，然后下载pull secret到“~/crc-linux-1.32.1-amd64”目录下pull-secret.json文件。
安装运行CRC

请用 crc 用户完成以下操作。
第一次运行

可以用下命令查看所有crc的运行参数，并且设置相关参数。

$ crc config
$ crc config set cpus 12 
$ crc config set memory 49152
$ crc config set disk-size 160
$ crc config set kubeadmin-password openshift
$ crc config set pull-secret-file pull-secret.json
$ crc config set enable-cluster-monitoring true
$ crc config set consent-telemetry no
$ crc config set skip-check-daemon-systemd-unit true
$ crc config set skip-check-daemon-systemd-sockets true
$ crc config view 


设置CRC运行环境，这一步会用下载的文件解压出VM运行文件。

$ crc setup


然后执行命令启动CRC的虚机，其中“-c”指的是使用cpu的数量；“-m”指定的虚机使用内存量，单位是MB；“-d”指定的虚机使用存储空间，单位是GB；”-p“指定pull secret文件的。

$ crc start -c 8 -m 40960 -d 100 -p pull-secret.json


在CRC虚拟机启动完成后会显示以下提示，其中说明了缺省的kubeadmin用户、密码和API-Server的访问地址。

The server is accessible via web console at:
  https://console-openshift-console.apps-crc.testing
 
Log in as administrator:
  Username: kubeadmin
  Password: openshift
 
Log in as user:
  Username: developer
  Password: developer
 
Use the 'oc' command line interface:
  $ eval $(crc oc-env)
  $ oc login -u developer https://api.crc.testing:6443

查看OpenShift的控制台访问地址。

$ crc console --url


关闭和再次运行

    关闭CRC虚拟机

$ crc stop

    再次运行CRC的时候需要注意：如果在宿主机中配置了下文中的DNS服务，在重新启动CRC前需要先关闭DNS服务，在CRC启动成功后再运行DNS服务即可。

访问CRC的OpenShift
从本地访问

在安装完CRC后缺省只能通过以下命令在运行虚拟机的宿主机中访问到运行在虚拟机中的OpenShift。

$ oc login -u <USERNAME> -p <PASSWORD> https://api.crc.testing:6443


可以在宿主机中执行以下命令，获得访问OpenShift Web Console的地址。

$ crc console --url


以上OpenShift的api-server和web console地址中的域名是在运行CRC的宿主机上通过hosts文件解析的。我们可以查看宿主机的hosts文件确认增加了以下内容。注意以下CRC虚机使用的IP地址是固定的“192.168.130.11”。

$ cat /etc/hosts
192.168.130.11 api.crc.testing oauth-openshift.apps-crc.testing console-openshift-console.apps-crc.testing default-route-openshift-image-registry.apps-crc.testing

从远程访问

为了能够从远程的其它节点访问到运行在宿主机中的CRC，需要解决远程“访问路径”和“域名解析”问题。本文分别使用HAProxy和hosts解决上述问题。
在这里插入图片描述
请用root 用户完成以下操作。
打通访问路径

我们在宿主机上运行HAProxy，用它作为代理来打通外部远程节点和运行在CRC虚拟机中OpenShift的访问路径。

    安装haproxy

$ yum install -y haproxy


    配置haproxy。先获得运行CRC的虚机IP地址（注意：该IP地址是KVM使用的地址，只能在宿主机上访问到），然后将其设置到haproxy的配置中，最后重启haproxy服务。

$ export CRC_IP=$(crc ip)
$ tee /etc/haproxy/haproxy.cfg &>/dev/null << EOF
global
    debug

defaults
    log global
    mode http
    timeout connect 5000
    timeout client 500000
    timeout server 500000

frontend apps
    bind 0.0.0.0:80
    option tcplog
    mode tcp
    default_backend apps

backend apps
    mode tcp
    balance roundrobin
    server webserver1 ${CRC_IP}:80 check

frontend apps_ssl
    bind 0.0.0.0:443
    option tcplog
    mode tcp
    default_backend apps_ssl

backend apps_ssl
    mode tcp
    balance roundrobin
    option ssl-hello-chk
    server webserver1 ${CRC_IP}:443 check

frontend api
    bind 0.0.0.0:6443
    option tcplog
    mode tcp
    default_backend api

backend api
    mode tcp
    balance roundrobin
    option ssl-hello-chk
    server webserver1 ${CRC_IP}:6443 check
EOF
 
$ systemctl restart haproxy
$ systemctl status haproxy

  

注意：如果haproxy启动报告“Starting frontend api: cannot bind socket [0.0.0.0:6443]”的错误，可以执行以下命令：

$ setsebool -P haproxy_connect_any=1


    配置宿主机的防火墙和SELinux。

$ systemctl start firewalld
$ firewall-cmd --add-port=80/tcp --permanent
$ firewall-cmd --add-port=6443/tcp --permanent
$ firewall-cmd --add-port=443/tcp --permanent
$ systemctl restart firewalld
$ yum -y install policycoreutils-python-utils
$ semanage port -a -t http_port_t -p tcp 6443


实现域名解析

为了让远程节点能访问到CRC虚机中的域名，需要在运行CRC的宿主机上安装DNS服务，然后将远程节点的DNS指向CRC宿主机上。请用root 用户完成以下操作。

    首先在运行CRC的宿主机上安装并配置DNS服务，使其能对“crc.testing”和“apps-crc.testing”域名解析。其中 “NAME_SERVER” 设为运行CRC虚拟机的宿主机地址。

$ yum -y install bind bind-utils
$ systemctl enable named --now
$ export NAME_SERVER=192.168.203.171
$ cp /etc/named.conf{,_bak}
$ sed -i -e "s/listen-on port.*/listen-on port 53 { any; };/" /etc/named.conf
$ sed -i -e "s/allow-query.*/allow-query { any; };/" /etc/named.conf
$ sed -i '/recursion yes;/a \
        forward first; \
        forwarders { 114.114.114.114; 8.8.8.8; };' /etc/named.conf
$ sed -i -e "s/dnssec-enable.*/dnssec-enable no;/" /etc/named.conf
$ sed -i -e "s/dnssec-validation.*/dnssec-validation no;/" /etc/named.conf 
 
$ cat >> /etc/named.rfc1912.zones << EOF
zone "crc.testing" IN {
        type master;
        file "crc.testing.zone";
        allow-update { none; };
};

zone "apps-crc.testing" IN {
        type master;
        file "apps-crc.testing.zone";
        allow-update { none; };
};
EOF
 
$ cat > /var/named/crc.testing.zone << EOF
\$TTL 1D
@       IN SOA  crc.testing. admin.crc.testing. (    
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry 
                                        1W      ; expire
                                        3H )    ; minimum
        NS      ns.crc.testing.          
*       IN A    ${NAME_SERVER}
EOF
 
$ cat > /var/named/apps-crc.testing.zone << EOF
\$TTL 1D
@       IN SOA  apps-crc.testing. admin.apps-crc.testing. (    
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry 
                                        1W      ; expire
                                        3H )    ; minimum
        NS      ns.apps-crc.testing.          
*       IN A    ${NAME_SERVER}
EOF
 
$ systemctl restart named

 

    然后将远程节点的dns指向运行CRC的宿主机的地址（即“${NAME_SERVER}”），这样远程节点就可以解析“crc.testing”和“apps-crc.testing”域名了。

从远程节点访问CRC的OpenShift

在远程节点上访问CRC中的OpenShift。

$ oc login -u <USERNAME> -p <PASSWORD> https://api.crc.ocp:6443



在远程节点上用浏览器访问 https://console-openshift-console.apps-crc.testing/
登录运行 CRC 的虚拟机

运行CRC的虚拟机IP地址统一是192.168.130.11，我们可以用虚拟机对应的私钥登录这个虚拟机。

$ ssh -i /home/crc/.crc/machines/crc/id_ecdsa core@192.168.130.11
Red Hat Enterprise Linux CoreOS 49.83.202102090044-0
  Part of OpenShift 4.9, RHCOS is a Kubernetes native operating system
  managed by the Machine Config Operator (`clusteroperator/machine-config`).
 
WARNING: Direct SSH access to machines is not recommended; instead,
make configuration changes via `machineconfig` objects:
  https://docs.openshift.com/container-platform/4.9/architecture/architecture-rhcos.html
 
---
[core@crc-l6qvn-master-0 ~]


自动安装配置CRC的Shell脚本

可以将以下内容保存在运行CRC虚机的宿主机上，然后使用非root用户按照shell运行，即可完成CRC下载、安装和远程访问的设置。
注意：

    请用运行CRC虚机的宿主机的IP替换以下“<YOUR_IP>”。
    请通过CRC_VERSION参数指定使用的CRC版本号。
    请通过CPU、MEMORY_SIZE、DISK_SIZE参数设置CRC使用资源量（其中内存的单位是MB，存储单位是GB）。以下是最小的资源使用量。
    以下shell脚本不包含准备libvirt环境。如需要安装，请参见本文开始部分。

export NAME_SERVER=<YOUR_IP>
##将常用变量写入~/.bashrc文件
cat << EOF >> ~/.bashrc
export CRC_PATH=/apps/crc
export CRC_VERSION=1.32.1
export CPU=8
export MEMORY_SIZE=20480
export DISK_SIZE=100
export PATH=\${CRC_PATH}:\$PATH
EOF
source ~/.bashrc
#-----------------------------------------------------------------------------------------------------
##下载最新版CRC文件并解压到指定目录
sudo mkdir -p ${CRC_PATH}
sudo curl http://mirror.openshift.com/pub/openshift-v4/x86_64/clients/crc/latest/crc-linux-amd64.tar.xz -o ${CRC_PATH}/crc-linux-amd64.tar.xz
sudo tar -xvf ${CRC_PATH}/crc-linux-amd64.tar.xz -C ${CRC_PATH}
sudo mv ${CRC_PATH}/crc-linux-${CRC_VERSION}-amd64/* ${CRC_PATH}
sudo rm -rf ${CRC_PATH}/crc-linux-${CRC_VERSION}-amd64
sudo rm -f ${CRC_PATH}/crc-linux-amd64.tar.xz
sudo chmod -R 757 ${CRC_PATH}
#-----------------------------------------------------------------------------------------------------
##从redhat网站获得pull secret
read -p "Please input the pull secret string from https://cloud.redhat.com/openshift/install/pull-secret:" PULL_SECRET
echo ${PULL_SECRET} > ${CRC_PATH}/pull-secret.json
#-----------------------------------------------------------------------------------------------------
##可选，配置yum repo
cat << EOF > ~/myrepo.repo
[base]
name=CentOS-7 - Base
baseurl=http://mirrors.163.com/centos/7/os/x86_64/
gpgcheck=0

[updates]
name=CentOS-7 - Updates
baseurl=http://mirrors.163.com/centos/7/updates/x86_64/
gpgcheck=0

[extras]
name=CentOS-7 - Extras
baseurl=http://mirrors.163.com/centos/7/extras/x86_64/
gpgcheck=0

EOF

sudo mv ~/myrepo.repo /etc/yum.repos.d/
#-----------------------------------------------------------------------------------------------------

sudo yum -y install NetworkManager
sudo yum -y install policycoreutils-python
sudo yum -y install haproxy
#-----------------------------------------------------------------------------------------------------
##配置启动脚本并启动CRC
crc setup
echo "crc start -c \${CPU} -m \${MEMORY_SIZE} -d \${DISK_SIZE} -p \${CRC_PATH}/pull-secret.json" > ~/crc-start
echo "crc oc-env" >> ~/crc-start
echo "crc console --url" >> ~/crc-start
chmod +x ~/crc-start
~/crc-start
#-----------------------------------------------------------------------------------------------------
##设置firewall和SELinux
sudo systemctl stop firewalld
sudo semanage port -a -t http_port_t -p tcp 6443
#-----------------------------------------------------------------------------------------------------
##配置允许远程节点访问CRC的haproxy
sudo cp /etc/haproxy/haproxy.cfg{,.bak}
export CRC_IP=$(crc ip)
sudo tee /etc/haproxy/haproxy.cfg &>/dev/null <<EOF
global
    debug

defaults
    log global
    mode http
    timeout connect 5000
    timeout client 5000
    timeout server 5000

frontend apps
    bind 0.0.0.0:80
    option tcplog
    mode tcp
    default_backend apps

backend apps
    mode tcp
    balance roundrobin
    server webserver1 $CRC_IP:80 check

frontend apps_ssl
    bind 0.0.0.0:443
    option tcplog
    mode tcp
    default_backend apps_ssl

backend apps_ssl
    mode tcp
    balance roundrobin
    option ssl-hello-chk
    server webserver1 $CRC_IP:443 check

frontend api
    bind 0.0.0.0:6443
    option tcplog
    mode tcp
    default_backend api

backend api
    mode tcp
    balance roundrobin
    option ssl-hello-chk
    server webserver1 $CRC_IP:6443 check
EOF

sudo systemctl restart haproxy
#-----------------------------------------------------------------------------------------------------
##配置允许远程节点访问CRC的内部DNS
sudo yum -y install bind bind-utils
sudo systemctl enable named --now

sudo cp /etc/named.conf{,_bak}
sudo sed -i -e "s/listen-on port.*/listen-on port 53 { any; };/" /etc/named.conf
sudo sed -i -e "s/allow-query.*/allow-query { any; };/" /etc/named.conf
sudo sed -i '/recursion yes;/a \
        forward first; \
        forwarders { 114.114.114.114; 8.8.8.8; };' /etc/named.conf
sudo sed -i -e "s/dnssec-enable.*/dnssec-enable no;/" /etc/named.conf
sudo sed -i -e "s/dnssec-validation.*/dnssec-validation no;/" /etc/named.conf

sudo cat >> /etc/named.rfc1912.zones << EOF
zone "crc.testing" IN {
        type master;
        file "crc.testing.zone";
        allow-update { none; };
};

zone "apps-crc.testing" IN {
        type master;
        file "apps-crc.testing.zone";
        allow-update { none; };
};
EOF

sudo cat > /var/named/crc.testing.zone << EOF
\$TTL 1D
@       IN SOA  crc.testing. admin.crc.testing. (    
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry 
                                        1W      ; expire
                                        3H )    ; minimum
        NS      ns.crc.testing.          
*       IN A    ${NAME_SERVER}
EOF

sudo cat > /var/named/apps-crc.testing.zone << EOF
\$TTL 1D
@       IN SOA  apps-crc.testing. admin.apps-crc.testing. (    
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry 
                                        1W      ; expire
                                        3H )    ; minimum
        NS      ns.apps-crc.testing.          
*       IN A    ${NAME_SERVER}
EOF

sudo systemctl restart named
