ubuntu16.04,libva error: va_getDriverName() failed ,driver_name=(null)错误处理


ubuntu16.04,libva error :va_getDriverName() failed ,driver_name=(null)
在使用Qt编程一些视频相关的应用，报错
libva info: Trying to open /usr/lib/x86_64-linux-gnu/dri/nvidia_drv_video.so
libva error: va_getDriverName() failed with unknown libva error,driver_name=(null)

本机是 ubuntu16.04 i7-8700 GTX1060 显卡，并且安装了Nvidia驱动后报错，如果不安装Nvidia 就是ubuntu 默认显卡驱动是不会出现问题的，视频应用可以正常运行。但是这样相当于使用核显。所以需要解决这个问题。

查看驱动是否存在：
locate  nvidia_drv_video.so
输出为空，发现没有在本机找到这个驱动，分析应该是需要安装 VAAPI ：
在Linux / X11上，有两个用于硬件视频解码的竞争接口：

Intel的VA-API
NVIDIA的VDPAU
我们是Nvidia GTX1060显卡，所以需要安装这个 VDPAU
sudo apt install vdpau-va-driver
安装 vainfo:
(vainfo工具用于查看libva库调用信息。)

sudo apt install vainfo
配置环境变量
gedit .bashrc 
1
输入：

### libva
#Intel的VA-API 配置为 LIBVA_DRIVER_NAME=i965 
#NVIDIA的VDPAU 配置为 LIBVA_DRIVER_NAME=nvidia
export LIBVA_DRIVER_NAME=nvidia #iHD #i965 #nvidia

#驱动路径
export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
