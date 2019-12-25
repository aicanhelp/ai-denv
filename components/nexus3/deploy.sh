#!/usr/bin/env bash

set -e

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

DOCKER_PROXY="10.146.3.105:8083/"

sudo docker stop nexus-repos
sudo docker rm nexus-repos

sudo docker run -d --name=nexus-repos -p 8081:8081 -p 8082:8082 -p 8083:8083 -v nexus-data:/nexus-data nexus-repos:1.0

cd $curDir