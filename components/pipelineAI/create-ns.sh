#!/usr/bin/env bash
kubectl create namespace kubeflow

kubectl config set-context $(kubectl config current-context) --namespace=kubeflow

