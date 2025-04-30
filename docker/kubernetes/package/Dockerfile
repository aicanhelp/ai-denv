FROM openeuler/openeuler:22.03-lts-sp4

WORKDIR /k8s_package

RUN yum -y update

RUN yum -y install net-tools wget yum-utils

RUN curl -o helm-v3.16.3-linux-${ARCH}.tar.gz https://get.helm.sh/helm-v3.16.3-linux-${ARCH}.tar.gz \
    && tar xzf helm-v3.16.3-linux-${ARCH}.tar.gz \
    && mv linux-${ARCH}/helm /usr/local/bin \
    && rm -rf linux-${ARCH} helm-v3.16.3-linux-${ARCH}.tar.gz

RUN wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubeadm && \
wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubelet && \
wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubectl && \

RUN wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz
    
RUN sudo yumdownloader --resolve cri-o    
      