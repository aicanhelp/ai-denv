#!/usr/bin/env bash

source config.default

sudo docker run -d --privileged --restart=unless-stopped \
     --net=host -v /etc/kubernetes:/etc/kubernetes \
     -v /var/run:/var/run ${DOCKER_PROXY}rancher/rancher-agent:v2.1.1 \
     --server https://${SERVER_ADDRESS}:8443 \
     --token ${TOKEN} \
     --ca-checksum ${CA_CHECKSUM} \
     --address ${LOCAL_ADDRESS} --internal-address ${LOCAL_ADDRESS} \
     --node-name ${NODE_NAME} \
     --worker


