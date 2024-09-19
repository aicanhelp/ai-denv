#!/usr/bin/env bash

# openssl genrsa -out "root-ca.key" 2048
# openssl req  -new -key "root-ca.key"  -out "root-ca.csr" -sha256  -subj '/C=CN/ST=beijing/L=beijing/O=cmri/CN=docker.cmri.com'
# openssl x509 -req  -days 3650  -in "root-ca.csr"  -signkey "root-ca.key" -sha256 -out "root-ca.crt" -extfile "root-ca.cnf" -extensions root_ca
# openssl genrsa -out "docker.margu.com.key" 2048
# openssl req -new -key "docker.cmri.com.key" -out "site.csr" -sha256  -subj '/C=CN/ST=beijing/L=beijing/O=cmri/CN=docker.cmri.com'
# openssl x509 -req -days 750 -in "site.csr" -sha256  -CA "root-ca.crt" -CAkey "root-ca.key"  -CAcreateserial  -out "docker.cmri.com.crt" -extfile "site.cnf" -extensions server


curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

function start(){

    docker stop docker-registry
    docker rm docker-registry

    docker run -d \
      -p 5000:5000 \
      --restart=always \
      --name docker-registry \
      -v /udata/repository:/var/lib/registry \
      registry:latest

    # docker stop registry-web
    # docker rm registry-web

    # docker run -d \
    #       -p 8088:8080 \
    #       --name registry-web  \
    #       --link registry -e REGISTRY_URL=http://0.0.0.0:5000/v2  \
    #       -e REGISTRY_NAME=registry:5000 hyper/docker-registry-web


    #  -v ${home}/config-cache.yml:/etc/docker/registry/config.yml \

    cd $curDir
}

function setup(){
    sudo cp registry-cli.py /usr/local/bin/registry
    sudo chmod +x /usr/local/bin/registry
}

$1
