#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

docker run -d --name kingbase \
 -p 54321:54321 \
 --privileged \
 -v $home/__data:/home/kingbase/userdata/ \
 -e ENABLE_CI=no  \
 -e NEED_START=yes \
 -e DB_USER=root \
 -e DB_PASSWORD=root \
 -e DB_MODE=mysql \
 kingbase_v008r006c008b0014_single_x86:v1