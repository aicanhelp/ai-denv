查看用户组及成员

sudo cat /etc/group | grep docker

可以添加docker组

sudo groupadd docker 

添加用户到docker组 

sudo gpasswd -a ${USER} docker 

sudo usermod -aG docker ${USER}

增加读写权限

 sudo chmod a+rw /var/run/docker.sock

重启docker

sudo systemctl restart docker 

newgrp - docker
