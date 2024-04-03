#创建docker组
sudo groupadd docker
#添加ithing进入docker组
sudo gpasswd -a ithing docker
#当前用户：newgrp docker
#重启docker服务
sudo systemctl restart docker
#接下来就可以使用你添加的用户（ithing）进行使用docker命令了