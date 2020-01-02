## JenkinX  

- 

Jenkins X 是基于 Kubernetes 的持续集成、持续部署平台

1、
首先，需要在你本地的机器上安装 jx 命令行工具 。
你可以使用 jx 命令 来创建一个新的 kubernetes 集群 ，然后 Jenkins X 就会自动安装。
或者，如果你已经有了一个 kubernetes 集群，那么可以在你的 kubernetes 集群上安装 Jenkins X。
（1）安装 jx
   - macOS
     在 Mac 上你可以使用 brew：
       brew tap jenkins-x/jx
       brew install jx
 (2)Linux
```
    curl -L "https://github.com/jenkins-x/jx/releases/download/$(curl --silent "https://github.com/jenkins-x/jx/releases/latest" | sed 's#.*tag/\(.*\)\".*#\1#')/jx-linux-amd64.tar.gz" | tar xzv "jx"

    sudo mv jx /usr/local/bin
```

2、创建Jenkins-x集群

