#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

mkdir bin

curl https://storage.googleapis.com/git-repo-downloads/repo > bin/repo

chmod +x bin/repo

