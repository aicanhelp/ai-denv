```
yum install bash-completion -y
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)

```
您还可以为 kubectl 使用一个速记别名，该别名也可以与 completion 一起使用：
cat >>/root/.bashrc
alias k=kubectl
complete -F __start_kubectl k
EOF
source /root/.bashrc

