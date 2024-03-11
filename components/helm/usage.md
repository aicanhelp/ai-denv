

### 安装
$ Helm install --dry-run --namespace gitlab --debug cnp-order ./myChart

### 安装更新
$ Helm upgrade --install --dry-run --namespace gitlab --debug cnp-order ./myChart

###  更新依赖  
$ helm dependency update

###  Uninstall
$ helm uninstall {deploy_name}

