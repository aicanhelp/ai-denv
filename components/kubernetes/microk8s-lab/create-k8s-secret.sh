#create k8s secret
microk8s kubectl create secret tls kube-dasboard-ssl --key kube-dashboard.key --cert kube-dashboard.crt -n kube-system

