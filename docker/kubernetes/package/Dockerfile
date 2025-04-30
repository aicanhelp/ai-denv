FROM docker:cli

ARG K8S_VERSION=v1.30.7

WORKDIR /k8s_package

RUN wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubeadm && \
    wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubelet && \
    wget https://dl.k8s.io/${K8S_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubeadm kubelet kubectl

RUN wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz


