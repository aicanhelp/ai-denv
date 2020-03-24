#!/usr/bin/env bash

sudo mysql -u root -pbeijing -e "
create database hive;
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%' IDENTIFIED BY 'hive' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'localhost' IDENTIFIED BY 'hive' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"