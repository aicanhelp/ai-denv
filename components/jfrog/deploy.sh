#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

docker stop artifactory-pro
docker rm artifactory-pro

docker run --name artifactory-pro -d -v artifactory:/var/opt/jfrog/artifactory -p 8085:8081 docker.bintray.io/jfrog/artifactory-pro:latest


cd $curDir