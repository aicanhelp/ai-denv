FROM --platform=amd64 alpine:3.21.3

WORKDIR /k0s

RUN apk curl bash coreutils git gnupg grep k0sctl mtr openssl wget vim

RUN wget https://github.com/k0sproject/k0s/releases/download/v1.29.15%2Bk0s.0/k0s-airgap-bundle-v1.29.15+k0s.0-amd64
RUN wget https://github.com/k0sproject/k0s/releases/download/v1.29.15%2Bk0s.0/k0s-airgap-bundle-v1.29.15+k0s.0-arm64

