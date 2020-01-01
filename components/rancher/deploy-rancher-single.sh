#!/usr/bin/env bash

source config.default

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

docker_cmd="sudo docker"

$docker_cmd stop rancher
$docker_cmd rm rancher

$docker_cmd run -d --name rancher --restart=unless-stopped \
  -p 8001:80 -p 8002:443 \
  -v $home/rancher:/var/lib/rancher \
  rancher/rancher:latest

cd $curDir