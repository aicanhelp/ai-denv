ARG IMAGE_BASE="0.0.0.0:5000/aiip"
ARG ARCH="amd64"
FROM ${IMAGE_BASE}/openeuler/openeuler:20.03-${ARCH} as builder20
ARG ARCH=${ARCH}
WORKDIR /tmp

RUN dnf check-update && dnf install -y rsync gcc libffi-devel createrepo git

COPY bin/* .
COPY bin/pip.conf /etc/

RUN bash prepare.sh


FROM ${IMAGE_BASE}/openeuler/openeuler:22.03-${ARCH} as builder22
ARG ARCH=${ARCH}

RUN dnf check-update && dnf install -y rsync gcc libffi-devel createrepo git

COPY bin/* .
COPY bin/pip.conf /etc/

RUN bash prepare.sh

FROM ${IMAGE_BASE}/operations/registry-nginx:2.8.3-${ARCH}
LABEL version=1.0.0 description="For collecting the resources of operations"

WORKDIR /jt-ops/resources

RUN mkdir -p "openeuler_20.03"
COPY --from=builder20 /tmp/outputs openeuler_20.03

RUN mkdir -p "openeuler_22.03"
COPY --from=builder22 /tmp/outputs openeuler_22.03


