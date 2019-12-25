#!/usr/bin/env bash

set -e

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

function buildNexusHelm(){
    if ! test -e nexus-repository-helm; then
        git clone https://github.com/sonatype-nexus-community/nexus-repository-helm.git
    fi

    cd ${home}/nexus-repository-helm
    mvn -DskipTests clean install
    cd ${home}
}

function buildNexusApt(){
    if ! test -e nexus-repository-apt; then
        git clone https://github.com/sonatype-nexus-community/nexus-repository-apt.git
    fi

    cd ${home}/nexus-repository-apt
    mvn -DskipTests clean install
    cd ${home}
}

function buildPlugins(){
    buildNexusHelm
    buildNexusApt
}

function buildFinalDocker(){
    sudo docker build -t nexus-repos:1.0 -f Dockerfile .
}

function build(){
    buildPlugins
    buildFinalDocker
}

build