#!/usr/bin/env bash
curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

docker stop docker-registry
docker rm docker-registry

docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name docker-registry \
  -v ${home}:/var/lib/registry \
  -v ${home}/registry-cache.yml:/etc/docker/registry/config.yml \
  registry:2

cd $curDir