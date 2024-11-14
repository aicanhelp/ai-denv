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


function start1(){

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

function genkey(){
    docker run --rm \
    -v . :/root/registry \
    nginx:latest sh -c "cd /root/registry && ./registry.sh genkey_in_docker"

    cd ${cur_dir}
    echo "9、生成用户http 认证文件"
    docker run --rm  --entrypoint htpasswd  0.0.0.0:5000/aiip/httpd:alpine-amd64 -Bbn modongsong beijing > config/auth/registry
}

function genkey_in_docker(){
    mkdir config/ssl
    mkdir config/auth

    cur_dir=`pwd`
    cd config/ssl

    echo "1、创建 CA 私钥  config/ssl/root-ca.key"
    rm -rf root-ca.key
    openssl genrsa -out "root-ca.key" 2048

    echo "2、利用私钥创建 CA 根证书请求文件: config/ssl/root-ca.csr"
    rm -rf root-ca.csr
    openssl req  -new -key "root-ca.key"  -out "root-ca.csr" -sha256  -subj '/C=CN/ST=beijing/L=beijing/O=cmri/CN=cmri.cn'

    echo "3、签发根证书: config/ssl/root-ca.crt"
    rm -rf root-ca.crt
    openssl x509 -req  -days 3650  -in "root-ca.csr"  \
       -signkey "root-ca.key" -sha256 -out "root-ca.crt" \
       -extfile "root-ca.cnf" -extensions root_ca

    echo "5、生成站点 SSL 私钥: config/ssl/cmri.cn.key"
    rm -rf cmri.cn.key
    openssl genrsa -out "cmri.cn.key" 2048

    echo "6、使用私钥生成证书请求文件: config/ssl/cmri.cn.csr"
    rm -rf cmri.cn.csr
    openssl req -new -key "cmri.cn.key" -out "cmri.cn.csr" -sha256  -subj '/C=CN/ST=beijing/L=beijing/O=cmri/CN=cmri.cn'

    echo "8、签署站点 SSL 证书"
    rm -rf cmri.cn.crt
    openssl x509 -req -days 3650 -in "cmri.cn.csr" -sha256  -CA "root-ca.crt" \
            -CAkey "root-ca.key"  -CAcreateserial  -out "cmri.cn.crt" -extfile "cmri.cn.cnf" -extensions server

}

function start2(){
    docker stop docker-registry
    docker rm docker-registry

    pwd
    docker run -d \
      --privileged  \
      -p 8443:8443 \
      --restart=always \
      --name docker-registry \
      --volume `pwd`/config:/etc/docker/registry \
      --volume /udata/repository:/var/lib/registry \
      registry:latest 


    cd $curDir
}

$1
