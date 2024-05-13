#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

docker run --name postgres \
  -e POSTGRES_PASSWORD=m123456% \
  -p 5432:5432 \
  -v $home/__data:/var/lib/postgresql/data \
  -d postgres
