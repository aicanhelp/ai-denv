1、Failed to initialize NVML: Driver/library version mismatch
```text
cat /var/log/dpkg.log |grep nvidia  
2023-11-04 06:18:33 upgrade nvidia-driver-535:amd64 535.113.01-0ubuntu0.22.04.3 535.129.03-0ubuntu0.22.04.1  
已经被升级到535.129。可能是系统自动升级的。

cat /proc/driver/nvidia/version
NVRM version: NVIDIA UNIX x86_64 Kernel Module  535.113.01  Tue Sep 12 19:41:24 UTC 2023
内核版本还是535.113, 版本不一致。
```
（1）在终端重启，reboot。重启后内核可能会重新加载至版本一直。  
（2）卸载重装驱动：
```text
##卸载
sudo /usr/bin/nvidia-uninstall
sudo apt-get --purge remove nvidia-*
sudo apt-get purge nvidia*
sudo apt-get purge libnvidia*
#确认
sudo dpkg --list | grep nvidia-*

sudo chmod a+x NVIDIA-Linux-x86_64-450.80.02.run
sudo ./NVIDIA-Linux-x86_64-450.80.02.run -no-x-check -no-nouveau-check -no-opengl-files

 #–no-opengl-files 只安装驱动文件,不安装OpenGL文件
 #–no-x-check 安装驱动时不检查X服务
 #–no-nouveau-check 安装驱动时不检查nouveau

```

禁止驱动更新： sudo apt-mark hold  nvidia-版本




