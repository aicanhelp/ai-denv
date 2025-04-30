FROM docker:cli

ARG K8S_VERSION=v1.30.7

WORKDIR /k8s_package

RUN wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubeadm && \
    wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubelet && \
    wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubeadm kubelet kubectl

RUN docker pull registry.k8s.io/kube-apiserver:${K8S_VERSION} && \
    docker pull  registry.k8s.io/kube-controller-manager:${K8S_VERSION} && \
    docker pull registry.k8s.io/kube-scheduler:${K8S_VERSION} && \
    docker pull registry.k8s.io/kube-proxy:${K8S_VERSION} && \
    docker pull registry.k8s.io/coredns/coredns:v1.11.1 && \
    docker pull registry.k8s.io/pause:3.9 && \
    docker pull registry.k8s.io/etcd:3.5.10-0 

RUN docker save registry.k8s.io/kube-apiserver:${K8S_VERSION} -o kube-apiserver.tar && \
    docker save registry.k8s.io/kube-controller-manager:${K8S_VERSION} -o kube-controller-manager.tar && \
    docker save registry.k8s.io/kube-scheduler:${K8S_VERSION} -o kube-scheduler.tar && \
    docker save registry.k8s.io/kube-proxy:${K8S_VERSION} -o kube-proxy.tar && \
    docker save registry.k8s.io/coredns/coredns:v1.11.1 -o coredns.tar && \
    docker save registry.k8s.io/pause:3.9 -o pause.tar && \
    docker save registry.k8s.io/etcd:3.5.10-0  -o etcd:3.5.10-0.tar 

RUN wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz


