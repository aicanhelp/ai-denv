
#### 1、docker
在使用docker容器运行时，配置访问http私有仓库的方法较为简单，类似如下即可：
```
#  cat /etc/docker/daemon.json 
{
  "insecure-registries": ["192.168.0.4:5500"]
}

``` 

#### 2、containerd

而当Kubernetes使用containerd时，其配置文件就相对复杂了。总的来说，有两种方式可以实现http仓库的访问。

#####  方法一：registry.configs
修改/etc/containerd/config.toml中如下位置，默认配置为：
```
    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = ""
      [plugins."io.containerd.grpc.v1.cri".registry.auths]
      [plugins."io.containerd.grpc.v1.cri".registry.configs]
      [plugins."io.containerd.grpc.v1.cri".registry.headers]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
```

例如添加私有仓库http://192.168.0.4:5500，则添加如下配置：
```
    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = ""
      [plugins."io.containerd.grpc.v1.cri".registry.auths]
      [plugins."io.containerd.grpc.v1.cri".registry.configs]
        [plugins."io.containerd.grpc.v1.cri".registry.configs."192.168.0.4:5500".tls]
          insecure_skip_verify = true
      [plugins."io.containerd.grpc.v1.cri".registry.headers]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.0.4:5500"]
          endpoint = ["http://192.168.0.4:5500"]
```

修改完成后重启containerd：
```
systemctl restart containerd
```

查看最新配置
```
containerd config dump
```

测试镜像拉取：
```
#  crictl pull 192.168.0.4:5500/registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.3.0
Image is up to date for sha256:69547dffc18fcddd4f41b7696a046ad7252ceeabce944106da94fa4bfb3c6b24
``` 

如需配置仓库认证信息，可参考：https://github.com/containerd/containerd/blob/main/docs/cri/registry.md

按照文档的说法，这种配置方式只支持到v1.6，目前我们的生产环境最高版本也是1.6，因此尚未测试这种方式在v1.7是否可行。

#### 方法二：hosts.toml
这种方式较为推荐，因为它可以做到不同仓库的配置文件分开管理，首先我们将默认配置文件修改为（即修改config_path）：
```
    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = "etc/containerd/certs.d"

      [plugins."io.containerd.grpc.v1.cri".registry.auths]

      [plugins."io.containerd.grpc.v1.cri".registry.configs]

      [plugins."io.containerd.grpc.v1.cri".registry.headers]

      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
```

接着创建配置文件夹：
```
cd /etc/containerd/
mkdir certs.d
```

然后创建仓库配置文件夹（以下也称主机命名空间namespace）及配置文件hosts.toml，文件夹名称为仓库域名或者[IP address][:port]，本例中为：
```
mkdir certs.d/192.168.0.4:5500
touch certs.d/192.168.0.4:5500/hosts.toml
```

创建完成后文件树如下：
```
#  tree /etc/containerd/certs.d
/etc/containerd/certs.d
└── 192.168.0.4:5500
    └── hosts.toml
```


hosts.toml写入如下配置：
```
#  cat /etc/containerd/certs.d/192.168.0.4\:5500/hosts.toml 
server = "http://192.168.0.4:5500"

[host."http://192.168.0.4:5500"]
  capabilities = ["pull", "resolve", "push"]
  skip_verify = true
```

重启containerd，并测试镜像拉取：
```
#  systemctl restart containerd

#  crictl pull 192.168.0.4:5500/registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.3.0
Image is up to date for sha256:69547dffc18fcddd4f41b7696a046ad7252ceeabce944106da94fa4bfb3c6b24
``` 
- hosts.toml文件详解  
    hosts.toml中指定的文件必须为绝对路径或相对于hosts.toml的相对路径
    - server字段
      该主机命名空间的默认服务器地址，也即Registry
    - host字段  
    即Mirror，镜像地址（server与host的关系，就是Registry和mirror的关系，例如Docker Hub是Registry，而国内的镜像源如阿里镜像源则是Mirror），如果配置了host，当客户端试图拉取或推送镜像时，会根据配置文件中定义的顺序和能力去尝试这些镜像服务器。
    - capabilities字段  
    表示该主机被信任执行的一系列操作集合。
    - skip_verify  
    表示是否跳过证书链验证，默认为false，即不跳过验证。
    - ca字段  
    指定ca证书路径或路径集合。
    - client字段  
    指定客户端证书或证书集合。
    - header字段  
    指定请求header，由一系列键值对组成
    - override_path字段  
    表示主机的API根路径是在URL路径中定义的，而不是通过API规范定义的。这个参数主要用于与那些不遵循OCI（Open Container Initiative）标准、缺少/v2前缀的非合规Registry配合使用。在Docker或其他容器引擎与Registry交互时，默认情况下会按照OCI规范去访问Registry API，即请求通常以 /v2/ 开头，例如：https://registry.example.com/v2/<image>/<tag>。然而，某些非标准的Registry可能并未遵循这一规范，其API根路径可能直接是注册表名之后的某个自定义路径。在这种情况下，通过将 override_path 设置为 true 并提供相应的路径，客户端就可以正确地定位到这些非标准Registry的API根路径，以实现与它们的有效通信。例如，如果API根路径是 https://registry.example.com/custom/api，则可以通过配置 override_path 来适应这种特殊格式。

一个示例配置文件如下：
```
server = "https://registry-1.docker.io"

[host."https://mirror.registry"]
  capabilities = ["pull"]
  ca = "/etc/certs/mirror.pem"
  skip_verify = false
  [host."https://mirror.registry".header]
    x-custom-2 = ["value1", "value2"]

[host."https://mirror-bak.registry/us"]
  capabilities = ["pull"]
  skip_verify = true

[host."http://mirror.registry"]
  capabilities = ["pull"]

[host."https://test-1.registry"]
  capabilities = ["pull", "resolve", "push"]
  ca = ["/etc/certs/test-1-ca.pem", "/etc/certs/special.pem"]
  client = [["/etc/certs/client.cert", "/etc/certs/client.key"],["/etc/certs/client.pem", ""]]

[host."https://test-2.registry"]
  client = "/etc/certs/client.pem"

[host."https://test-3.registry"]
  client = ["/etc/certs/client-1.pem", "/etc/certs/client-2.pem"]

[host."https://non-compliant-mirror.registry/v2/upstream"]
  capabilities = ["pull"]
  override_path = true

```

注意一：两种方法不能混用
注意二：这两种方法是用来配置cri的，因此不适用于ctr或nerdctl命令