RTR3InitEx failed with rc=-1912 (rc=-1912)


The VirtualBox kernel modules do not match this version of VirtualBox.The installation of VirtualB ox was apparently not successful. Please trycompletely uninstalling and reinstalling virtualBox.


where: supR3HardenedMainlnitRuntime what: 4

VERR_VM_DRIVER_VERSION_MISMATCH (-1912) - The installed supportdriver doesn't rmatch the version of the user.

主要原因是：

内核版本的错误，之前安装过virtualbox，导致系统内有多个virtualbox

Windows环境：
解决方法：先将所有的virtualbox卸载，然后再次重新安装


Linux环境：

解决方法：以管理权限shell终端修复

1. 查看vboxdrv内核信息

# modinfo vboxdrv

2. 删除内核文件

# rm /lib/modules/4.19.88-1-MANJARO/kernel/misc/vboxdrv.ko.xz

3. 验证删除；即无法找到内核信息

# modinfo vboxdrv

4. 重新配置

# /sbin/vboxconfig

5. 再次验证

# modinfo vboxdrv



where: suplibOsInit what: 3 VERR_VM_DRIVER_NOT_INSTALLED (-1908) - The support driver is not installed. On linux, open returned ENOENT



扩展VirtualBox虚拟机磁盘容量
1. 在cmd命令行下进入VirtualBox的安装目录，使用“VBoxManage list hdds”命令，找到需要修改磁盘容量的虚拟机的img路径或UUID：
VirtualBox安装目录>VBoxManage list hdds
 
2. 修改虚拟机的磁盘空间
VirtualBox安装目录>VBoxManage modifyhd "E:\CentOS.vdi" –resize 20480
20480的单位是MB

3. 使用windows的磁盘工具扩展磁盘

