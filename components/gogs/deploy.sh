#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

DOCKER_PROXY="10.146.3.105:8083/"

sudo docker stop gogs
sudo docker rm gogs


sudo docker run -d --name=gogs -p 10044:10044 -p 10080:3000 -v ${home}/data:/data gogs/gogs

cd $curDir