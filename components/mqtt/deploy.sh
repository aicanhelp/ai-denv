#!/bin/bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

name=eclipse-mqtt
sudo docker rm -f ${name}

# 启动容器
docker run -d \
    --hostname 0.0.0.0 \
    --privileged  \
    --name ${name} \
    --restart always \
    --publish 1883:1883 --publish 9001:9001 \
    --volume ${home}/__data/config:/mosquitto/config \
    --volume ${home}/__data/data:/mosquitto/data \
    --volume ${home}/__data/log:/mosquitto/log \
    0.0.0.0:5000/eclipse-mosquitto:2.0.15-amd64
