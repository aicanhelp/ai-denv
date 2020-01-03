#!/usr/bin/env bash

#specify cluster: --kubeconfig /custom/path/kube.config

kubectl create namespace kubeflow

kubectl config set-context $(kubectl config current-context) --namespace=kubeflow

