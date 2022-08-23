#!/usr/bin/env bash

sudo mysql -u root -pbeijing -e "
create database rangerkms;
CREATE USER 'rangerkms'@'%' IDENTIFIED BY 'ranger';
GRANT ALL PRIVILEGES ON *.* TO 'rangerkms'@'%' IDENTIFIED BY 'ranger' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangerkms'@'localhost' IDENTIFIED BY 'ranger' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"