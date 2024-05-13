#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`

function deploy_(){
    sudo docker stop gitlab
    sudo docker rm gitlab

    sudo docker run --detach \
        --hostname 0.0.0.0 \
        --privileged  \
        --env GITLAB_SKIP_UNMIGRATED_DATA_CHECK=true \
        --env GITLAB_OMNIBUS_CONFIG="external_url 'http://test.cn'; gitlab_rails['lfs_enabled'] = true; gitlab_rails['gitlab_shell_ssh_port'] = 522;" \
        --env GITLAB_LOG_LEVEL=info \
        --publish 9443:9443 --publish 9080:80 --publish 522:522 \
        --name gitlab \
        --restart always \
        --volume  $home/gitlab/config:/etc/gitlab \
        --volume  $home/gitlab/logs:/var/log/gitlab \
        --volume  $home/gitlab/data:/var/opt/gitlab \
        gitlab/gitlab-ce:latest

    cd $curDir

    docker logs -f -n 10 gitlab
}

function deploy_test(){
    _name_=gitlab_test
    sudo docker stop ${_name_}
    sudo docker rm ${_name_}

    sudo docker run --detach \
        --hostname 0.0.0.0 \
        --privileged  \
        --env GITLAB_SKIP_UNMIGRATED_DATA_CHECK=true \
        --env GITLAB_OMNIBUS_CONFIG="external_url 'http://0.0.0.0:9080'; gitlab_rails['lfs_enabled'] = true; gitlab_rails['gitlab_shell_ssh_port'] = 522;" \
        --env GITLAB_LOG_LEVEL=WARN \
        --name ${_name_} \
        --restart always \
        --volume  $home/${_name_}/config:/etc/gitlab \
        --volume  $home/${_name_}/logs:/var/log/gitlab \
        --volume  $home/${_name_}/data:/var/opt/gitlab \
        gitlab/gitlab-ce:latest

    cd $curDir

    docker logs -f -n 10 ${_name_}
}

deploy_$1
