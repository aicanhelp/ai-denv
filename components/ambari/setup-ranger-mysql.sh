#!/usr/bin/env bash

sudo mysql -u root -pbeijing -e "
create database ranger;
CREATE USER 'rangeradmin'@'%' IDENTIFIED BY 'ranger';
GRANT ALL PRIVILEGES ON *.* TO 'rangeradmin'@'%' IDENTIFIED BY 'ranger' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangeradmin'@'localhost' IDENTIFIED BY 'ranger' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"