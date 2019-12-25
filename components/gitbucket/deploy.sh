#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

DOCKER_PROXY="10.146.3.105:8083/"

sudo docker stop gitbucket
sudo docker rm gitbucket

sudo docker run -d -p 9081:8080 -p 29418:29418 -v ${home}/gitbucket-data:/gitbucket f99aq8ove/gitbucket

cd $curDir