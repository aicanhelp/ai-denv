Ubuntu18搭建CDH6环境02
Posted on 2019/08/16 by neohope — No Comments ↓

1、cdt01安装

#添加cloudera仓库
wget https://archive.cloudera.com/cm6/6.3.0/ubuntu1804/apt/archive.key
sudo apt-key add archive.key
wget https://archive.cloudera.com/cm6/6.3.0/ubuntu1804/apt/cloudera-manager.list
sudo mv cloudera-manager.list /etc/apt/sources.list.d/
 
#更新软件清单
sudo apt-get update
 
#安装jdk8
sudo apt-get install openjdk-8-jdk
 
#安装cloudera
sudo apt-get install cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server
2、安装及配置mysql
2.1、安装mysql

sudo apt-get install mysql-server mysql-client libmysqlclient-dev libmysql-java
2.2、停止mysql

sudo service mysql stop
2.3、删除不需要的文件

sudo rm /var/lib/mysql/ib_logfile0
sudo rm /var/lib/mysql/ib_logfile1
2.4、修改配置文件

sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
 
#修改或添加以下信息
[mysqld]
transaction-isolation = READ-COMMITTED
max_allowed_packet = 32M
max_connections = 300
innodb_flush_method = O_DIRECT
2.5、启动mysql

sudo service mysql start
2.6、初始化mysql

sudo mysql_secure_installation
3、创建数据库并授权

sudo mysql -uroot -p
-- 创建数据库
-- Cloudera Manager Server
CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Activity Monitor
CREATE DATABASE amon DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Reports Manager
CREATE DATABASE rman DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Hue
CREATE DATABASE hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Hive Metastore Server
CREATE DATABASE hive DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Sentry Server
CREATE DATABASE sentry DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Cloudera Navigator Audit Server
CREATE DATABASE nav DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Cloudera Navigator Metadata Server
CREATE DATABASE navms DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Oozie
CREATE DATABASE oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
 
#创建用户并授权
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm123456';
GRANT ALL ON amon.* TO 'amon'@'%' IDENTIFIED BY 'amon123456';
GRANT ALL ON rman.* TO 'rman'@'%' IDENTIFIED BY 'rman123456';
GRANT ALL ON hue.* TO 'hue'@'%' IDENTIFIED BY 'hue123456';
GRANT ALL ON hive.* TO 'hive'@'%' IDENTIFIED BY 'hive123456';
GRANT ALL ON sentry.* TO 'sentry'@'%' IDENTIFIED BY 'sentry123456';
GRANT ALL ON nav.* TO 'nav'@'%' IDENTIFIED BY 'nav123456';
GRANT ALL ON navms.* TO 'navms'@'%' IDENTIFIED BY 'navms123456';
GRANT ALL ON oozie.* TO 'oozie'@'%' IDENTIFIED BY 'oozie123456';
4、初始化数据库

sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql amon amon amon123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql rman rman rman123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql hue hue hue123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql hive hive hive123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql sentry sentry sentry123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql nav nav nav123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql navms navms navms123456
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql oozie oozie oozie123456
5、启动

#启动cloudera-scm-server
sudo systemctl start cloudera-scm-server
 
#查看启动日志，等待Jetty启动完成
sudo tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log
6、启动
浏览器访问
http://172.16.172.101:7180
用户名：admin
密码：admin