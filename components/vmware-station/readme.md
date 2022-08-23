(1) 安装后需要安装 open-vm-tools来设置共享文件夹，同时需要在fstab 设置：
     .host:/ /mnt/hgfs fuse.vmhgfs-fuse allow_other 0 0

