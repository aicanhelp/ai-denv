#!/usr/bin/env bash

set -e

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

components_dir=${baseDir}/components
component=$1
components=`ls ${components_dir}`

function checkComponent(){
     if [ "$component" = "" ]; then
         echo "Please input the component name: ${components}"
         exit 1
     fi

     if ! ls ${components_dir}|grep ${component}; then
        echo "Please input the correct component name: ${component} ; component options: ${components}"
         exit 1
     fi
}

function deployComponent(){
     sh ${components_dir}/${component}/deploy.sh
}

function start(){
    checkComponent
    deployComponent
}

start