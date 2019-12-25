# AI-Dev-Platform

This is a project for deploying a development for AI, especially for the case of internal network.

So, generally, the environment is as following:
   - One machine for deploying docker registry with the pull cache mode. Refer to [registry](registry/README.md) .
   - One machine for installing Rancher. Refer to [rancher](rancher/README.md) .
   - (Optional) If needed, make the ssh tunnel for accessing the Rancher. Refer to [sshtunnel](ssh/tunnel) .


Plan:

   - (1)  Docker Registry   (in proxy machine) . 
   - (2)  Nexus3-helm-repo  (in proxy machine, as the proxy of Docker, Helm, Yum, Maven, etc.)  
   - (3)  Rancher           (in production machine, management of the clusters of Kubernetes) 
   - (4)  chartmuseum       (in production machine, a tools for the installation of helms)
   - (5)  Openproject       (for project management)  
   - (6)  Eclipse-Che       (Web IDE)  
   - (7)  Kong              (API gateway, service mesh)  
   - (8)  Istio             (Service Mesh)  
   - (9)  Ceph              (Storage，怎么安装，kubernetes?)  
   - (10) Openshift         ()  
   - (11) GitLab            ()  
   - (12) Bitbucket         ()  
   - (13) Jenkins           ()  
   - (14) codis             ()
   - (15) Ambari            ()
   - (16) Gogs              (Git Server written by GO)  
   - (17) Jupyterhub        ()  
   - (18) Jupyterlab        ()  



