#!/bin/bash

#下载离线安装包
yum install --downloadonly --downloaddir=./rpms \
    yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum --downloadonly --downloaddir=./rpms \
    install docker-ce docker-ce-cli containerd.io

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

## 下载 kube安装包
yum install --downloadonly --downloaddir=./rpms \
    kubelet kubeadm --disableexcludes=kubernetes

## 下载 docker 镜像
for image in `kubeadm config images list --kubernetes-version=$1`
do
  image_name=`echo ${image} | sed "s/k8s.gcr.io.//g"`
  docker pull "${image}"
  docker tag "${image}" "${image_name}"
  file_name="${image_name}.tgz"
  docker save "${image_name}" | gzip > "${file_name}"
  docker rmi "${image}"
  docker rmi "${image_name}"
done

# registry.k8s.io/kube-apiserver:v1.29.10
# registry.k8s.io/kube-controller-manager:v1.29.10
# registry.k8s.io/kube-scheduler:v1.29.10
# registry.k8s.io/kube-proxy:v1.29.10
# registry.k8s.io/coredns/coredns:v1.11.1
# registry.k8s.io/pause:3.9
# registry.k8s.io/etcd:3.5.10-0

wget https://github.com/kubernetes-sigs/kind/releases/download/v0.24.0/kind-linux-amd64 --no-check-certificate
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64


# 2 开始离线安装

## 2.1 生成CA证书
cat <<EOF > ca-csr.json
{
    "CN": "Kubernetes CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "ca": {
       "expiry": "87600h"
    }
}
EOF

## 更新证书
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
update-ca-trust enable
cp ca.pem /etc/pki/ca-trust/source/anchors/
update-ca-trust extract

