

## 扩容问题

在VMWare初创虚拟机环境的时候分配的空间太小，比如默认的20G。在实践中发现需要更多的空间。使用`df -h`查看跟文件系统（`/`目录）的情况。发现它对应`/dev/mapper/ubuntu--vg-ubuntu--lv`这样的逻辑设备，也就是这个文件系统放在逻辑卷管理系统上。

```text
root@master:~# df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               1.9G     0  1.9G   0% /dev
tmpfs                              391M  1.6M  389M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   19G  9.9G  7.8G  56% /
```

在VMWare上给虚拟机硬盘扩展空间，首先要关机，然后点击设置，对硬盘进行设置，点击`扩展`按钮就可以**设置扩展后的总硬盘容量了**。

![](https://pic3.zhimg.com/80/v2-f65779e98cfa0fcb410e2f5c6532ef2a_720w.jpg)

扩展完之后，还需要在操作系统中扩展文件系统容量，下面是解决过程。

## 解决过程

这里简单罗列一下解决过程：

- 修复PMBR分区表
- 创建新的分区
- 并入卷组
- 扩展逻辑卷
- 修改文件系统大小

### 修复PMBR分区表

直接写进分区表就好了，也就是先`fdisk /dev/sda`，然后`w`写进。

```text
root@node1:~# fdisk /dev/sda

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

GPT PMBR size mismatch (41943039 != 83886079) will be corrected by write.

Command (m for help): w

The partition table has been altered.
Syncing disks.

root@node1:~# fdisk /dev/sda

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.
```

### 创建新的分区

两个操作：（1）创建新的分区；（2）将新分区写进分区表，也就是MBR。最终生成新的设备文件，这里是`sda4`。

```text
root@master:~# fdisk  /dev/sda

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): n
Partition number (4-128, default 4): 
First sector (41940992-83886046, default 41940992): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (41940992-83886046, default 83886046): 

Created a new partition 4 of type 'Linux filesystem' and of size 20 GiB.

Command (m for help): w
The partition table has been altered.
Syncing disks.
```

### 创建物理卷（PV）

使用`pvcreate /dev/sda4`可以在该设备上创建一个物理卷。

```text
root@master:~# pvcreate /dev/sda4 
  Physical volume "/dev/sda4" successfully created.
```

查看所有的物理卷。

```text
root@master:~# pvdisplay 
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-vg
  PV Size               <19.00 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              4863
  Free PE               0
  Allocated PE          4863
  PV UUID               tMMZb0-fQyx-z9jb-zNgE-1fzA-8oZf-GUaQ7O

  "/dev/sda4" is a new physical volume of "20.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sda4
  VG Name               
  PV Size               20.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               kOwxsE-w6cm-T5fS-0Sab-zlXY-wJmA-J84e8c
```

### 并入物理卷组（VG）

先查看物理卷组情况，可以看到卷组名为`ubuntu-vg`，我们要对它扩容。

```text
root@master:~# vgdisplay 
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <19.00 GiB
  PE Size               4.00 MiB
  Total PE              4863
  Alloc PE / Size       4863 / <19.00 GiB
  Free  PE / Size       0 / 0   
  VG UUID               NlfoWj-m3cO-C6X1-7X4I-FnMp-pvop-rnCY8d
```

当多个物理卷组合成一个卷组后时，LVM会在所有的物理卷上做类似格式化的工作，将每个物理卷切成一块一块的空间，这一块一块的空间就称为PE（Physical Extent ），它的默认大小是4MB。

接下来就是扩容，如下命令：

```text
root@master:~# vgextend ubuntu-vg /dev/sda4 
  Volume group "ubuntu-vg" successfully extended
```

再使用`vgdisplay`可以看到扩容增加了5119个`Free PE`了。

```text
root@master:~# vgdisplay 
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               38.99 GiB
  PE Size               4.00 MiB
  Total PE              9982
  Alloc PE / Size       4863 / <19.00 GiB
  Free  PE / Size       5119 / <20.00 GiB
  VG UUID               NlfoWj-m3cO-C6X1-7X4I-FnMp-pvop-rnCY8d
```

### 扩展逻辑卷（VL）

先使用`lvdisplay`看看情况，只有一个逻辑卷`ubuntu-lv`，它是建立在`ubuntu-vg`物理卷组上面。

```text
root@master:~# lvdisplay 
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                r6twfL-E0pS-mu5H-HlbN-AIpT-GVfi-k6Kat0
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2022-01-09 13:25:25 +0000
  LV Status              available
  # open                 1
  LV Size                <19.00 GiB
  Current LE             4863
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

使用`lvextend`扩展逻辑卷容量，`-l`选项后面加`+5119`表示增加`5119`个PE，其中5119是由`vgdisplay`命令显示的`Free PE`得到的。后面接设备名称，也就是`/dev/ubuntu-vg/ubuntu-lv`。

```text
root@master:~# lvextend -l+5119 /dev/ubuntu-vg/ubuntu-lv 
  Size of logical volume ubuntu-vg/ubuntu-lv changed from <19.00 GiB (4863 extents) to 38.99 GiB (9982 extents).
  Logical volume ubuntu-vg/ubuntu-lv successfully resized.
```

再来看逻辑卷容量，发现`LV Size`增大了。

```text
root@master:~# lvdisplay 
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                r6twfL-E0pS-mu5H-HlbN-AIpT-GVfi-k6Kat0
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2022-01-09 13:25:25 +0000
  LV Status              available
  # open                 1
  LV Size                38.99 GiB
  Current LE             9982
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

当然也可以在`lvextend`命令后面加`-r`选项，直接对文件系统扩容，即执行如下命令（而不是上面命令）。

```text
root@master:~# lvextend -l+5119 /dev/ubuntu-vg/ubuntu-lv -r
```

如果这样使用的话，就可以跳过下面一小节。

### 修改文件系统大小

使用resize2fs工具修改

```text
root@master:~# resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv 
resize2fs 1.45.5 (07-Jan-2020)
Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
old_desc_blocks = 3, new_desc_blocks = 5
The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 10221568 (4k) blocks long.

root@master:~# df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               1.9G     0  1.9G   0% /dev
tmpfs                              391M  1.6M  389M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   39G  9.9G   27G  28% /
tmpfs                              2.0G     0  2.0G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/loop1                          62M   62M     0 100% /snap/core20/1270
/dev/loop2                          71M   71M     0 100% /snap/lxd/21029
/dev/loop3                          68M   68M     0 100% /snap/lxd/21835
/dev/loop4                          44M   44M     0 100% /snap/snapd/14295
/dev/loop5                          56M   56M     0 100% /snap/core18/2253
/dev/loop6                          33M   33M     0 100% /snap/snapd/12704
tmpfs                              391M     0  391M   0% /run/user/0
/dev/loop7                          56M   56M     0 100% /snap/core18/2284
```
