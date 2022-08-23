借助 Travis CI 让其每天自动运行，将所有用得到的 gcr.io 下的镜像同步到了 Docker Hub 使用方法 目前对于一个 gcr.io 下的镜像，可以*直接将 k8s.gcr.io 替换为 gcrxio *用户名，然后从 Docker Hub 直接拉取，以下为一个示例:  
两个字，这大神，牛逼。  
方法二：网友同步方案（推荐，直接使用）

```bash
# 原始命令
docker pull k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0
# 使用国内第三方（网友）同步仓库
docker pull gcrxio/kubernetes-dashboard-amd64:v1.10.0
docker pull anjia0532/kubernetes-dashboard-amd64:v1.10.0
```
