#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

DOCKER_PROXY="10.146.3.105:8083/"

sudo docker stop gitlab
sudo docker rm gitlab

sudo docker run --detach \
    --env GITLAB_OMNIBUS_CONFIG="external_url 'http://10.146.3.105:9080'; gitlab_rails['lfs_enabled'] = true; gitlab_rails['gitlab_shell_ssh_port'] = 522;" \
    --publish 9443:443 --publish 9080:9080 --publish 522:22 \
    --name gitlab \
    --restart always \
    --volume  $home/gitlab/config:/etc/gitlab \
    --volume  $home/gitlab/logs:/var/log/gitlab \
    --volume  $home/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

cd $curDir