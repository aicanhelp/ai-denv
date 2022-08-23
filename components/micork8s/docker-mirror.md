
设置 microk8s docker mirror

microk8s 使用的是自己的docker系统。外部的docker设置没有用，其实都不同装docker。

有两种方式加速micork8s内部的docker的获取
- （1）使用pullk8s，它的脚本有一个bug，其中两行代码需要改成这样(如果使用multipass）：
     docker save $saveImage > ~/.docker_image.tmp.tar
      multipass transfer ~/.docker_image.tmp.tar microk8s-vm:/tmp/image.tar
      microk8s ctr image import /tmp/image.tar
- （2）通过 multipass shell 进入虚拟机，
    编辑 /var/snap/microk8s/current/args/containerd-template.toml 文件,在 endpoint 添加 新的 国内 registry.mirrors ，
```
[plugins.cri.registry]
      [plugins.cri.registry.mirrors]
        [plugins.cri.registry.mirrors."docker.io"]
          endpoint = [
                "https://docker.mirrors.ustc.edu.cn",
                "https://hub-mirror.c.163.com",
                "https://mirror.ccs.tencentyun.com",
                "https://registry-1.docker.io"
          ]

```     
在新版中，需要修改如下:/var/snap/microk8s/current/args/certs.d/docker.io/hosts.toml
```
server = "https://docker.io"
  
[host."https://docker.mirrors.ustc.edu.cn"]
  capabilities = ["pull", "resolve"]

[host."https://hub-mirror.c.163.com"]
  capabilities = ["pull", "resolve"]

[host."https://mirror.ccs.tencentyun.com"]
  capabilities = ["pull", "resolve"]

[host."https://registry-1.docker.io"]
  capabilities = ["pull", "resolve"]

```
然后，先停止 microk8s，再启动 microk8s  

```
sudo microk8s stop
sudo microk8s start
```

