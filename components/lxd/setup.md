# [基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://www.wangt.cc//2021/09/%E5%9F%BA%E4%BA%8Elxd%E6%90%AD%E5%BB%BA%E5%A4%9A%E4%BA%BA%E5%85%B1%E7%94%A8gpu%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%8C%E7%AE%80%E5%8D%95%E6%98%93%E7%94%A8%EF%BC%8C%E5%85%A8%E7%BD%91%E6%9C%80%E8%AF%A6/)

### 基于LXD搭建多人共用GPU服务器

- 一、引言
- 二、方案对比
- - 2.1 单用户
  - 2.2 多用户
  - 2.3 KVM虚拟机
  - 2.4 Docker
  - 2.5 LXC
  - 2.6 LXD
  - 2.7 OpenPAI
  - LXD最终能实现什么
- 三、安装与配置
- - 3.1 安装显卡驱动
  - 3.2 安装LXD、ZFS和Bridge-utils：
  - 3.3 配置存储池
  - 3.4 初始化LXD
  - 3.5 创建容器
  - 3.6 配置容器
  - - 3.6.1 共享文件夹
    - 3.6.2 安装显卡驱动
    - 3.6.3 配置网络
- 四、容器管理
- - 4.1 zfs
  - 4.2 容器参数
  - 4.3 可视化界面
  - 4.3 容器快照
  - 4.4 容器镜像
- 五、用户手册
- - 5.1 SSH
  - 5.2 X11-Forwarding
  - 5.3 远程桌面
- 六、结束撒花🎉

# 一、引言

随着人工智能技术的发展，越来越多的团队开始迈入了人工智能领域。而研究人工智能技术必不可少的就是拥有一台配置较高的GPU服务器。当前半导体价格日益趋增，显卡价格更是因为虚拟货币居高不下。这就导致了一个团队中必然会面对多人共用一台GPU服务器的情况，但是每个人的使用方式和操作习惯都不一样，对于系统的软件、环境、文件、配置等要求也各不相同，甚至还有小白运行损害系统的命令。那么如何让多人井井有条的共用服务器，还不影响服务器性能呢？那就是**通过虚拟化容器技术来隔离每个人的操作系统，并通过共享文件夹的形式达到多人共用的数据资源。**

# 二、方案对比

服务器简单来说还是一台高性能的主机而已，那服务器上装完操作系统后大家怎么同时使用就成了一个问题。通常大家的做法如下：

## 2.1 单用户

即大家都使用同一个用户来使用服务器，这样会导致每个用户文件都存放在一起，太乱且容易误删；一个用户更改系统环境后会影响到其他用户使用，比如CUDA版本等；多个用户之间不能方便的协调管理；

## 2.2 多用户

多用户管理虽然可以解决每个人的文件存储管理问题，但仍然会导致每个人都有可能修改系统环境和配置影响其他用户使用。并且如果某人将系统损坏所有人都将受到影响。

## 2.3 KVM虚拟机

虚拟机可以通过软件模拟的具有完整硬件系统功能的、运行在一个完全隔离环境中的完整计算机系统。可以达到我们想要的系统隔离效果， 但使用虚拟机会浪费一定资源用于硬件虚拟化，且硬件只能独占，不能共享，资源利用率低。

## 2.4 Docker

虽然是容器化的环境，但Docker是应用级容器，他更偏向于PaaS平台，还是没办法做到让每个用户拥有一个独立的操作系统。

## 2.5 LXC

系统级虚拟化方案，用在单个主机上运行多个隔离的Linux系统容器。但LXC也有缺点：如无法有效支持跨主机之间的容器迁移、管理复杂等。而LXD很好地解决了这些问题。  
LXC与Docker的区别可以看这张图，主要就是Docker是应用级，LXC是系统级：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/9403680ce54448a0aabf0af74a726d1e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_60,color_FFFFFF,t_70,g_se,x_16)

## 2.6 LXD

LXD底层也是使用LXC技术，并可以提供更多灵活性和功能。因此LXD可以视作LXC的升级版。LXD的管理命令和LXC的管理命令大多相同。

## 2.7 OpenPAI

微软先进的任务隔离方法，主要适用于任务型隔离，比较适合集群化部署，人数较多的使用场景。

基于上面常见的七种方法，能拥有系统级隔离、容器化成本最低、操作方便简单的方案就是使用：LXD了。

## LXD最终能实现什么

- 每个用户都有用了独立的系统以及所有权限，但不被允许之间操作宿主机；
- 每个容器拥有可以在局域网内访问的独立IP地址，用户可以使用SSH方便地访问自己的“机器”；
- 所有用户都可以使用所有的资源，包括CPU、GPU、硬盘、内存等；
- 可以创建共享文件夹，将共用数据集、模型、安装文件等进行共享，减少硬盘浪费；
- 可以安装图形化桌面进行远程操作；
- 容器与宿主机使用同一个内核，性能损失小；
- 轻量级隔离，每个容器拥有自己的系统互不影响；
- 容器可以共享地使用宿主机的所有计算资源。

LXD也有缺点：

- 显卡驱动不方便更新；
- 容器与宿主机共同内核，一个容器内核出错，全体爆炸。

# 三、安装与配置

服务器系统还没装好的的可以参考我的这篇文章：Dell服务器配置与安装Ubuntu Server20.04操作系统，超详细！  
先介绍一下我操作的这台服务器环境：

> 显卡： GTX 3090  
> CPU： i9-10900X  
> 主板： Asus Pro WS X299 SAGE II  
> 系统版本： Ubuntu 20.04 LTS

## 3.1 安装显卡驱动

系统安装好后，先将显卡驱动做好，如果你本身装的不是Server版的系统，则会自带Nouveau桌面程序，它会在系统启动的时候默认启动，我们装显卡驱动要卸载禁止掉所有驱动，包括Nouveau。

1. 卸载旧驱动：

```
sudo apt-get purge nvidia*
sudo apt-get autoremove
sudo reboot 
```

2. 禁止Nouveau：

```
sudo vim /etc/modprobe.d/blacklist.conf 
# 在文件最后增加下面两行：
blacklist nouveau  
options nouveau modeset=0 
```

3. 更新重启

```
sudo update-initramfs -u
```

4. 检查禁止是否成功

```
lsmod | grep nouveau
```

如果没有任何输出则代表禁止成功。

```
sudo -i
systemctl isolate multi-user.target
modprobe -r nvidia-drm
```

取得超级权限，关闭所有NVIDIA驱动。

5. 安装显卡驱动  
   注意，这里建议用其他电脑ssh远程操作，因为如果你要直接显示器操作还需要切换到命令行界面需要用到lightdm，比较麻烦。

```
sudo chmod a+x NVIDIA-Linux-x86_64-470.63.01.run
sudo ./NVIDIA-Linux-x86_64-470.63.01.run -no-x-check -no-nouveau-check -no-opengl-files
```

安装过程中除了这个界面需要选择Yes，其他都默认即可。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/18058640b93c43eb9a8d97c637036661.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_40,color_FFFFFF,t_70,g_se,x_16)

7. 检查是否安装成功  
   输入：`nvidia-smi`命令：  
   ![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/e2f0952614784636af0d5fc82656f18e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
   能出来这个界面就算是安装成功了！

## 3.2 安装LXD、ZFS和Bridge-utils：

```
sudo apt-get install lxd zfsutils-linux bridge-utils
```

LXD 实现虚拟化容器  
ZFS 用于管理物理磁盘，支持LXD高级功能  
Bridge-utils 用于搭建网桥

## 3.3 配置存储池

安装完软件后，我们要选一块区域来存储LXD所使用的空间。我们可以在一个磁盘上分出一块分区，也可以把整个磁盘作为存储池。我们先看一下磁盘情况：`sudo fdisk -l`：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/38686d59dffe4395afc18a6b6e8214d3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

找到你想操作的磁盘，如这里的/dev/sda，可以直接`sudo fdisk /dev/sda`来对磁盘进行分区，fdisk命令如果不记得可以输入`m`查看帮助说明：  
主要用到的就是我下面标注出来的这几个命令  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/b8ce27d8aa6c4a8db44cac7072e0073e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
如果已经有分区了，可以输入`d`删除分区，然后输入`n`创建分区，最后`w`保存分区就可以了，我这里选择/dev/sda磁盘下的`/dev/sda1`分区作为我的zfs存储池。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/4852ac591b5a42e3bd97cf1bff179598.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

## 3.4 初始化LXD

执行：`sudo lxd init`  
LXD初始化脚本将询问你存储、网络、容器各种配置项的默认值：

```
Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]: yes
Name of the new storage pool [default=default]: default
Name of the storage backend to use (btrfs, dir, lvm, zfs) [default=zfs]: zfs
Create a new ZFS pool? (yes/no) [default=yes]: yes
Would you like to use an existing block device? (yes/no) [default=no]: yes
# 这里输入我们刚刚做的分区
Path to the existing block device:/dev/sda1
# 每个容器的默认大小
Size in GB of the new loop device (1GB minimum) [default=30GB]: 1024G
Would you like to connect to a MAAS server? (yes/no) [default=no]:
# 是否创建桥接网络
Would you like to create a new local network bridge? (yes/no) [default=yes]: yes
What should the new bridge be called? [default=lxdbr0]: lxdbr0
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: auto
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: auto
Would you like the LXD server to be available over the network? (yes/no) [default=no]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```

网络配置那里有两种方式，一种是全部走一个公网，容器都是局域网ip，访问每个容器都需要通过唯一的公网IP+端口号的形式，也就是我上面采用的方式。还有一种形式是不创建桥接网络，直接让所有容器都获取上游独立ip，相当于每个容器都能够获取独立ip。我这边是只有一个公网，所以采用了这种方式，你可以根据自己需求修改这里的网络配置。  
相关配置输入错了也没关系，可以通过`sudo lxc profile edit default`或者再运行一遍`sudo lxd init`来再次修改配置：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/d8e75e9cf1a54610bd64968f4dd6dd4d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

## 3.5 创建容器

所有准备工作准备齐全后就可以来创建容器了，和Docker的使用方式很类似，我们先选个镜像，我这里选择Ubuntu 20.04，然后直接通过launch命令启动容器（如果本机镜像找不到则会去网上自动下载并使用）：

```
lxc launch ubuntu:20.04 tf
```

tf是我容器的名字，启动成功后，我们可以通过`lxc list`命令查看现在运行的容器：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/63749345ec184fad8229ba1c22f3523b.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
通过`lxc image ls`查看本机已有的镜像：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/4a897d1940b14c0a958858c450e7e60b.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
通过`lxc exec tf bash`可以进入容器内进行操作：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/d4aa9b9d0b8f4704b952da667805848d.png)  
`exit`：退出容器  
`lxc stop tf`：停止容器  
`lxc delete tf`：删除容器  
`lxc restart tf`：重启容器

## 3.6 配置容器

现在容器已经创建好了，我们也可以进去了，现在还需要做三件事才可以让其他伙伴使用：

### 3.6.1 共享文件夹

想往容器里传输文件，有两种方式，一种是你可以直接使用命令把单个文件传送给容器：

```
# 复制文件夹需要在最后加 -r
sudo lxc file push <source path> <container>/<path> # 表示从宿主机复制文件到容器
sudo lxc file pull <container>/<path> <target path> # 表示将容器的文件复制到宿主机
```

还有一种方式是在宿主机创建个共享文件夹，然后共享给每个容器。这样容器之间就可以相互存取文件，比较适合放一些共用的软件包和数据集：

```
sudo lxc config set <container> security.privileged true
sudo lxc config device add <container> <device-name> disk source=/home/xxx/share path=/home/xxx/share
```

其中 path 为容器路径，source 为宿主机路径。device-name 随意取名字即可。

```
# 例子
sudo lxc config device add tf data disk source=/data/lxd-data path=/root/data
```

移除共享文件夹：

```
sudo lxc config device remove <container> <device-name>
```

然后我们进入容器，可以看到`/root/data`文件夹下就是我们宿主机`/data/lxd-data`文件夹下的文件了：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/4b3ccc0a88af4effae55e18305ac985d.png)

### 3.6.2 安装显卡驱动

1. 添加GPU硬件  
   在宿主机中执行以下命令

```
lxc config device add tf gpu gpu
```

然后进入容器，安装显卡驱动。驱动程序可以放到宿主机的共享文件里，这样进入容器就可以直接使用了。

3. 安装驱动  
   因为LXD是复用了Linux内核，所以在容器内安装显卡驱动就不用安装内核了：

```
sudo sh ./NVIDIA-Linux-x86_64-470.63.01.run --no-kernel-module
```

安装过程和宿主机一样，安装成功后，输入：`nvidia-smi`可以输出信息，则容器内的驱动也装好啦。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/9777e573a44649b8bbb2b480423d5764.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

### 3.6.3 配置网络

现在东西都有了，我们可以通过端口转发的形式让别的小伙伴通过宿主机的ip访问到这个容器：

```
sudo lxc config device add tf proxy1 proxy listen=tcp:10.0.5.11:6002 connect=tcp:10.214.214.169:22 bind=host
sudo lxc config device add tf proxy0 proxy listen=tcp:10.0.5.11:6003 connect=tcp:10.214.214.169:3389 bind=host
```

主要需要注意的地方是：`tf`是我的容器名，`10.0.5.11`是我宿主机的ip，`10.214.214.169`是我容器的ip。每个人占俩端口，分别用来映射ssh的22端口，和rdp协议的3389端口。容器的ip可以通过`lxc list`查看，本机的ip可以通过`ifconfig`查看。  
这样都做好后，我们就可以把10.0.5.11:6002 、10.0.5.11:6003 给到小伙伴，让他远程访问了。当然，root密码你如果忘了，可以进入容器通过`passwd root`修改root密码。如果显示服务器拒绝密码，则可能是ssh默认不接受密码登录：

```
vim /etc/ssh/sshd_config
#PermitRootLogin without-password改为
PermitRootLogin yes
#重启ssh服务
/etc/init.d/ssh restart
```

到这一步，其他小伙伴应该是可以远程访问到这个容器，并开心使用了。

# 四、容器管理

## 4.1 zfs

还记得最开始我们配置zfs存储池嘛，你可以通过`zpool list`、`zfs list -t all`来查看存储情况：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/13e743cdba24492f8641a5eae28894f9.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_60,color_FFFFFF,t_70,g_se,x_16)

## 4.2 容器参数

通过`lxc config edit tf`配置容器的参数：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/f01316380c564dc7a990493f7b7a2e21.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_60,color_FFFFFF,t_70,g_se,x_16)  
配置参数说明：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/5c4b50637b14401db12de6838d291079.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_60,color_FFFFFF,t_70,g_se,x_16)

## 4.3 可视化界面

这个时候可能有朋友要问了，这配置好繁琐，这么多命令参数，有没有现成的GUI工具可以鼠标点点就可以操作呢？当然是有，要不然就不会有这段话，因为LXD 在 LXC 基础上增加了 RESTful API，所以是有基于这个API操作的可视化界面：lxdui。  
照着Github仓库说明安装就可以了，我这里贴一下我的操作：

1. 检查Python3和pip是否安装成功，必须。
2. Clone仓库，并进入目录：

```
git clone https://github.com/AdaptiveScale/lxdui.git
cd lxdui
```

3. python3 -m venv mytestenv，创建虚拟环境，可选。

```
# 激活虚拟环境
source mytestenv/bin/activate
```

4. 安装依赖包

```
python3 setup.py install
```

5. 运行程序

```
# 启动: 
python3 run.py start
# 或者使用CLI启动:   
lxdui start
# 后台运行
nohup python3 run.py start > python.log3 2>&1 &
```

6. 管理界面  
   启动成功后，可以浏览器访问宿主机`ip:15151`  
   ![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/37bd49cd74534d158e5c3700cb4c5e41.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
   用户名密码默认均是：admin  
   ![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/3a75fa4aa18d4e4281bb7d2ed22e2a97.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
   然后就可以看到可视化界面了，是不是很安逸~  
   ![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/a0a6d0fe21904428bd26d6291441b525.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

## 4.3 容器快照

![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/470260e4f43d4418aa85cd6e8f6cc690.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
点击创建容器后会一直转圈圈，等待即可。创建完的容器默认是关闭的，我们需要打开它。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/709969c7ab7d4f6ebd313194949ce63e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
由于是基于快照创建，原来我们装好的驱动应用程序都会在，是需要对该容器添加硬件、共享文件夹、映射端口，就可以达到和快照容器一样的效果。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/3027e95547d7492fbd5dfc0d82b445a8.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
配置共享文件、网络端口映射和之前一样，这里就不再做赘述了。上面使用图形化界面，有喜欢用命令行的同学也可以使用下面命令，效果都是一样的：

```
# 创建快照
sudo lxc snapshot <container> <snapshot name>
# 恢复快照
sudo lxc restore <container> <snapshot name>
# 从快照新建一个容器
sudo lxc copy <source container>/<snapshot name> <destination container>
```

## 4.4 容器镜像

镜像和快照的不同是，通过镜像做出来的容器MAC 地址等关键信息也会同样被复制，并且镜像也方便保存与分享。  
图形化界面：进入容器，点击Export，输入Image别名。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/c72b2325c12b4e6d9f405469d6b8baa8.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
点击Export等待片刻就可以了，点击Images，可以看到已经有了，后面那个五千多GB别慌，是xcdui的bug，其实是MB。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/e6d8ed5b9a944e79b449a0a6e0d63b09.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

不喜欢图形化界面用命令也可以：

```
# 停止容器
sudo lxc stop test
# 创建并保存image
sudo lxc publish test --alias ubuntudemo --public
# 查看image
sudo lxc image ls
```

![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/108d92941d4a4a39932853b560d2eff7.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

# 五、用户手册

对于用户使用来说，每个用户都可以操作一台干净的操作系统（容器），系统本身也是支持SSH、RDP协议的，用户可以按自己的习惯一样使用它。总体来说，远程服务器有以下三种形式：

## 5.1 SSH

最常用的远程操作方式，可以通过命令行窗口执行各种命令及脚本任务。无论你是Windows、Mac、Linux每个操作系统终端都支持了远程SSH协议，可以使用：`ssh -p 端口号 服务器用户名@ip`的格式来远程连接。不过由于系统自带的终端功能比较简陋，没有存储功能，每次都需要重新输入连接，比较麻烦。所以我们通常使用这些软件：

- Putty（⭐️）
- Termius（⭐️⭐️⭐️）
- iTerm 2 （⭐️⭐️）
- SecureCRT（⭐️）
- XManager（⭐️⭐️）

当然，现在的IDE如IDEA系列都自带了SSH连接功能，也可以直接使用。我平常会用Termius + VS Code，这里演示一下VS 
Code，因为它免费且可以图形化编辑，支持命令行，并可以直接使用VS Code的插件对服务器进行管理。首先要在VS Code种安装`Remote-SSH`插件：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/90b016eaacb24397a90c71a518ef6685.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_90,color_FFFFFF,t_70,g_se,x_16)  
依次点击如下菜单：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/8257572ed98940aeb793bf9007dcb166.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_90,color_FFFFFF,t_70,g_se,x_16)  
分别输入别名、主机名、用户名，可以创建多个远程主机。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/35adebc8ecb246cab0b042d474ec08e1.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_90,color_FFFFFF,t_70,g_se,x_16)  
点击Connect to host就可以远程连接到服务器了，VS Code像是在远程服务器上运行的软件，你在这个窗口的所有操作都是针对服务器的，非常方便易用。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/5b0f30b5b6f74483a9f5bdd07fb672d2.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
注：如果不想每次连接都需要密码，你可以通过ssh将本地私钥传到服务器上即可免密登陆。

## 5.2 X11-Forwarding

使用X11-forwarding转发单个应用的图形界面，可以下载MobaXterm软件来操作。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/e9b033ba950f4ef19e318916d2720f40.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/7585f0fb957a44c5801214a1f0bd77ec.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)  
在终端直接输入执行软件命令  
例如执行 `/opt/pycharm-2018.3.4/bin/pycharm.sh` 启动pycharm  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/903a96ebf00740dcbf456cb6a8816d5a.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

## 5.3 远程桌面

虽然Linux对桌面支持相对来说都不算太好，但桌面的方式简单易用深受大众喜爱。远程桌面的协议这里使用微软的RDP，Window用户可以直接输入：`mstsc`命令打开自带的远程桌面工具进行连接；Mac用户可以使用：Microsoft Remote Desktop ；Linux用户则可以使用Remmina。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/72e74f26daf247fda221d61d0034ce56.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_16,color_FFFFFF,t_70,g_se,x_16)  
输入宿主机ip地址+rdp协议端口：  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/95250887c519443eae3dc45d69577a18.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_19,color_FFFFFF,t_70,g_se,x_16)  
你也可以展开菜单配置相关的选项，点击连接  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/5fe4c1e224954d22b989ffed33b6fc15.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_19,color_FFFFFF,t_70,g_se,x_16)  
选是即可，也可以勾选不再询问，局域网自家人用，没必要配置证书  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/059c7988db76405a9e59ab0dc6597a24.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_18,color_FFFFFF,t_70,g_se,x_16)  
连接成功，默认用户名密码均为：ubuntu  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/7b0b37c359f44e0bb3ddbaeae8df9c21.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_60,color_FFFFFF,t_70,g_se,x_16)  
微软自带的mstsc支持远程桌面和本机电脑粘贴板互传，使用起来还是很方便的。  
![基于LXD搭建多人共用GPU服务器，简单易用，全网最详细！](https://pic.wangt.cc/download/pic_router.php?path=https://img-blog.csdnimg.cn/6a47112f609441cbac3f0a401dfc71bf.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5q-U54m55qGD,size_20,color_FFFFFF,t_70,g_se,x_16)

# 六、结束撒花🎉

如果我的文章有给你一些帮助，请给我一个点赞👍吧！如果有任何问题，可以留言相互交流。关于部署应用服务器的搭建可以看我之前发的文章，祝搭建顺利！
