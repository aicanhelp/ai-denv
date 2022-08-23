
#creating crt file for configuring k8s dashboard as ingress
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout kube-dashboard.key -out kube-dashboard.crt -subj "/CN=dashboard.kube.com/O=dashboard.kube.com"
