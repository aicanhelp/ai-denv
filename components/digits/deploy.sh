#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

DOCKER_PROXY="10.146.3.105:8083/"

sudo docker stop chartmuseum
sudo docker rm chartmuseum

sudo docker run -d --name chartmuseum --restart=unless-stopped \
  -p 8098:8080 \
  -e PORT=8080 \
  -e DEBUG=1 \
  -e STORAGE="local" \
  -e STORAGE_LOCAL_ROOTDIR="/chartstorage" \
  -v $home/chartstorage:/chartstorage \
  ${DOCKER_PROXY}chartmuseum/chartmuseum:latest

cd $curDir