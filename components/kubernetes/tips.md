#### 没法拉取  pause 镜像
修改/etc/containerd/config.toml 的sandbox_image
   sandbox_image = "registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.9"

#### 配置不安全的registry
修改/etc/containerd/config.toml 的sandbox_image
下面两个修改，还没有验证哪个正确：
```
[plugins."io.containerd.grpc.v1.cri".registry]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
      endpoint = ["https://docker.io"]
  insecure_registries = ["my-insecure-registry.com:5000"]
```


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

#### 配置cri-io
/etc/containers/registries.conf
unqualified-search-registries = ["example.com"]

[[registry]]
prefix = "example.com/foo"
insecure = false
blocked = false
location = "internal-registry-for-example.com/bar"

[[registry.mirror]]
location = "example-mirror-0.local/mirror-for-foo"

[[registry.mirror]]
location = "example-mirror-1.local/mirrors/foo"
insecure = true

[[registry]]
location = "registry.com"

[[registry.mirror]]
location = "mirror.registry.com"



```
systemctl restart crio
```


遇到不信任的ca机构发布的证书时（比如自签名的），需要把跟证书放到集群的各个节点
（1）对于containerd的容器，需要放到：
/etc/containerd/certs.d/registry.xxxxxxxxx.cn/registry.xxxxxxxxx.cn.crt
（2）同时，ubuntu还需要放到/usr/local/share/ca-certificates/下，并运行 update-ca-certificates 进行导入
（3）centos，需要放到：/etc/pki/ca-trust/source/anchors/
   ln -s /etc/pki/ca-trust/source/anchors/registry.xxxxxxxxx.cn.crt /etc/ssl/certs/registry.xxxxxxxxx.cn.crt
   update-ca-trust
（4）然后，重启：systemctl restart containerd 