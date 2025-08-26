#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

DB_TYPE=$1

if test -z "${DB_TYPE}" || ! echo " mysql pg " | grep " ${DB_TYPE} " >/dev/null; then
   echo "db type is required"
   echo "usage: $0 mysql|pg"
   exit 1
fi

function start_database(){
   local _type=$1
   sudo docker rm -f kingbase-pg
   sudo docker rm -f kingbase-mysql

   sudo docker run -d \
    --name kingbase-${DB_TYPE} \
    -p 54321:54321 \
    --privileged \
    --restart always \
    -v $home/__data:/home/kingbase/userdata/${DB_TYPE} \
    -e ENABLE_CI=no  \
    -e NEED_START=yes \
    -e DB_USER=root \
    -e DB_PASSWORD=root \
    -e DB_MODE=${DB_TYPE} \
    kingbase_v008r006c008b0014_single_x86:v1
}

start_database