# Deploy Rancher


Before installing Rancher, you need to configure the docker correctly to use the docker registry installed
in step (1) . The file [/etc/docker/daemon.json](../etc/docker/daemon.json) is the docker configuration example,
which you can refer to make your docker configuration file and you should
put the file into the folder /etc/docker of your machine, and the file name should be daemon.json as well.