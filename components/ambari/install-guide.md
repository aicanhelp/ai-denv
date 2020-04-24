



## １.简介.
本人介绍ubuntu 18.04下Hortonwork 的ambari 2.7.3 和HDP 3.1.0的安装，效果如下。HDP与CDH的对比，HDP版本更新较快，因为Hortonworks内部大部分员工都是apache代码贡献者，尤其是Hadoop 2.0的贡献者。

目前Apache社区Hadoop最新版本：3.2.0
目前CDH最新版支持Hadoop版本：3.0.0
目前HDP最新版支持Hadoop版本：3.1.1

![ambari安装效果图](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70.png)

## ２.环境准备
先下载需要用到的官方安装包，分别有如下４个文件：

项目	Value
ambari	http://public-repo-1.hortonworks.com/ambari/ubuntu18/2.x/updates/2.7.3.0/ambari-2.7.3.0-ubuntu18.tar.gz
HDP	http://public-repo-1.hortonworks.com/HDP/ubuntu18/3.x/updates/3.1.0.0/HDP-3.1.0.0-ubuntu18-deb.tar.gz
HDP-UTILS	http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.22/repos/ubuntu18/HDP-UTILS-1.1.0.22-ubuntu18.tar.gz
HDP-GPL	http://public-repo-1.hortonworks.com/HDP-GPL/ubuntu18/3.x/updates/3.1.0.0/HDP-GPL-3.1.0.0-ubuntu18-gpl.tar.gz
## ３.配置http服务  
完成软件源的更新后，输入以下的命令进行安装Apache服务器。

#sudo apt-get install apache2
#mkdir -p /var/www/html

将上文的　ambari HDP HDP-GPL HDP-UTILS 解压后放入　/var/www/html

## ４.配置apt本地安装 
在/etc/apt/sources.list.d目录下，新增以下文件
ambari.list

deb http://127.0.0.1/ambari/ubuntu18/2.7.3.0-139/ Ambari main

ambari-hdp.list

deb http://127.0.0.1/HDP-GPL/ubuntu18/3.1.0.0-78/ HDP-GPL main
deb http://127.0.0.1/HDP-UTILS/ubuntu18/1.1.0.22/ HDP-UTILS main
deb http://127.0.0.1/HDP/ubuntu18/3.1.0.0-78/ HDP main

在浏览器输入url进行简单验证
![http服务检查](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200322235857048.png)

最后运行 apt-get update　进行更新

##  ５.安装ambari-server   
### 5.1 ambari配置  
执行 apt-get install ambari-server成功后，执行
ambari-server setup 开始建立配置

改变端口，打开文件,/etc/ambari-server/conf/ambari.conf, add:
client.api.port=

选择自定义JDK

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200322235932869.png)

/usr/local/jdk1.8.0_181

一直选择y，到选择数据库选择1，后一直回车即可
![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200322235942565.png)

最后成功有这样的提示

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000121319.png)

### 5.2 ambri-server 启动   

执行 ambari-server start ，成功后，打开外网8080端口，即可访问，输入admin/admin
![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000137912.png)



![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000458084.png)



# ６. 安装组件

## 6.1 输入集群名字

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000509738.png)

## 6.2 选择hdp版本

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000523743.png)

选择本地仓库，只保留ubuntu,url 输入：
HDP-GPL http://127.0.0.1/HDP-GPL/ubuntu18/3.1.0.0-78/
HDP-UTILS http://127.0.0.1/HDP-UTILS/ubuntu18/1.1.0.22/
HDP http://127.0.0.1/HDP/ubuntu18/3.1.0.0-78/

## 6.3 配置本机免密

ssh-keygen -t rsa 后，一直回车
cd ~/.ssh
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
然后测试ssh localhost ,如果正确即可，有问题可以自己排查一下



## 6.4 配置私钥

cat /root/.ssh/id_rsa 或者内容后，copy到输入框

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000607406.png)



![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000614144.png)

## 6.5 选择组件

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000626888.png)
![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000627159.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000639801.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000648712.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000655093.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000701402.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000707545.png)

###  6.6 安装hive数据库  
安装mysql ：
sudo apt-get install mysql-server

执行mysql后，执行下面脚本：

create database hive;
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON *.* TO 'hive'@ '%' IDENTIFIED BY 'hive' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'localhost' IDENTIFIED BY 'hive' WITH GRANT OPTION;
FLUSH PRIVILEGES;

注册mysql驱动，在shell下面执行：

ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java-8.0.13.jar

配置对应信息，注意修改主机名
![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000742414.png)

## 6.7 继续完成安装

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000753455.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000801531.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000812102.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000817965.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000823863.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000829611.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000835616.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000841491.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000847023.png)

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000853044.png)

# 7. 组件shell命令验证

## 7.1 hadoop

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000905222.png)

## 7.2 hive

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000914963.png)

## 7.3 hbase

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000931039.png)

## 7.4 spark

![在这里插入图片描述](imgs/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaWppYXNoZW5n,size_16,color_FFFFFF,t_70-20200323000939056.png)