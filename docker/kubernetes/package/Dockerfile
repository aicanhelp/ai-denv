FROM openeuler/openeuler:22.03-lts-sp4
ARG K8S_VERSION=v1.30.7

WORKDIR /k8s_package

RUN yum -y update

RUN yum -y install net-tools wget 

RUN wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubeadm && \
wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubelet && \
wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubectl 

RUN wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz

RUN curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_7/devel:kubic:libcontainers:stable.repo
RUN curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:1.28.4.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.28:/1.28.4/CentOS_7/devel:kubic:libcontainers:stable:cri-o:1.28:1.28.4.repo

RUN yum -y update && yum reinstall -y --downloadonly --downloaddir=. cri-o 
      