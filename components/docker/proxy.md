### dockerd代理

执行如下命令在systemd文件夹下创建代理配置文件

sudo mkdir -p /etc/systemd/system/docker.service.d
touch /etc/systemd/system/docker.service.d/http-proxy.conf
在http-proxy.conf文件中添加如下内容

[Service]
Environment="HTTP_PROXY=http://127.0.0.1:10080"
Environment="HTTPS_PROXY=http://127.0.0.1:10080"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"


其中NO_PROXY可以根据自己的需要配置。配置完成后，重启docker服务

sudo systemctl daemon-reload
sudo systemctl restart docker

### 容器代理
创建或者修改~/.docker/config.json文件，添加如下内容
```
	{
	 "proxies": {
	   "default": {
	     "httpProxy": "http://proxyAddress:port",
	     "httpsProxy": "http://proxyAddress:port",
	     "noProxy": "*.test.example.com,.example.org,127.0.0.0/8"
	   }
	 }
	}
```