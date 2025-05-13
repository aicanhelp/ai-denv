FROM --platform=amd64 openeuler/openeuler:20.03-lts-sp4 as builder20-amd

WORKDIR /tmp

RUN dnf check-update && dnf install -y rsync gcc libffi-devel createrepo git

COPY bin/* .
COPY bin/pip.conf /etc/

RUN bash prepare.sh


FROM --platform=arm64 openeuler/openeuler:20.03-lts-sp4 as builder20-arm

WORKDIR /tmp

RUN dnf check-update && dnf install -y rsync gcc libffi-devel createrepo git

COPY bin/* .
COPY bin/pip.conf /etc/

RUN bash prepare.sh


FROM --platform=amd64 openeuler/openeuler:22.03-lts-sp4 as builder22-amd

RUN dnf check-update && dnf install -y rsync gcc libffi-devel createrepo git

COPY bin/* .
COPY bin/pip.conf /etc/

RUN bash prepare.sh


FROM --platform=arm64 openeuler/openeuler:22.03-lts-sp4 as builder22-arm

RUN dnf check-update && dnf install -y rsync gcc libffi-devel createrepo git

COPY bin/* .
COPY bin/pip.conf /etc/

RUN bash prepare.sh


FROM ${IMAGE_BASE}/operations/registry-nginx:2.8.3-${ARCH}
LABEL version=1.0.0 description="For collecting the resources of operations"

WORKDIR /jt-ops/resources

RUN mkdir -p "openeuler_20.03_amd64"
COPY --from=builder20-amd /tmp/outputs openeuler_20.03_amd64

RUN mkdir -p "openeuler_20.03_arm64"
COPY --from=builder20-arm /tmp/outputs openeuler_20.03_arm64

RUN mkdir -p "openeuler_22.03_amd64"
COPY --from=builder22-amd /tmp/outputs openeuler_22.03_amd64

RUN mkdir -p "openeuler_22.03_arm64"
COPY --from=builder22-arm /tmp/outputs openeuler_22.03_arm64


