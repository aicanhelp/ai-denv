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

RUN yum install -y --downloadonly --downloaddir=. cri-o \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/developer/x86_64/slirp4netns-0.4.3-4.el7_8.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/developer/x86_64/fuse-overlayfs-0.7.2-6.el7_8.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/developer/x86_64/fuse3-libs-3.6.1-4.el7.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm1/linux-ibiblio.old/distributions/smeserver/releases/testing/10.0.alpha4/smeupdates/x86_64/RPMS/python-IPy-0.75-6.el7.noarch.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/latest/x86_64/checkpolicy-2.5-8.el7.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/latest/x86_64/libsemanage-python-2.5-14.el7.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/latest/x86_64/setools-libs-3.3.8-4.el7.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/latest/x86_64/audit-libs-python-2.8.5-4.el7.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/latest/x86_64/libcgroup-0.41-21.el7.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm1/linux-ibiblio.old/distributions/smeserver/releases/testing/10.0.alpha4/smeupdates/x86_64/RPMS/policycoreutils-python-2.5-34.el7.x86_64.rpm \
wget ftp://ftp.icm.edu.pl/vol/rzm3/linux-oracle-repo/OracleLinux/OL7/developer/x86_64/container-selinux-2.119.2-1.911c772.el7_8.noarch.rpm   