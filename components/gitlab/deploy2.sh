#!/usr/bin/env bash

curDir=`pwd`
baseDir=$(dirname $0)
cd $baseDir
home=`pwd`
REGISTRY=registry.cmri.cn/aiip
PG_IMAGE=${REGISTRY}/sameersbn-postgresql:14-20230628
REDIS_IMAGE=${REGISTRY}/redis:6
GITLAB_IMAGE=${REGISTRY}/sameersbn-gitlab:latest

function deploy_pg(){
    DOCKER_PG=gitlab-postgresql

    docker stop ${DOCKER_PG}
    docker rm-f ${DOCKER_PG}
    docker run --name ${DOCKER_PG} -d \
    --env 'DB_NAME=gitlabhq_production' \
    --env 'DB_USER=gitlab' --env 'DB_PASS=password' \
    --env 'DB_EXTENSION=pg_trgm,btree_gist' \
    --volume $home/gitlab/postgresql:/var/lib/postgresql \
    ${PG_IMAGE}
}

function deploy_redis(){
    DOCKER_REDIS=gitlab-redis

    docker stop ${DOCKER_REDIS}
    docker rm-f ${DOCKER_REDIS}

    docker run --name ${DOCKER_REDIS} -d \
    --volume $home/gitlab/redis:/data \
    ${REDIS_IMAGE}
}

function deploy_gitlab(){
    DOCKER_DITLAB=gitlab

    docker stop ${DOCKER_DITLAB}
    docker rm-f ${DOCKER_DITLAB}

    docker run --name ${DOCKER_DITLAB} -d \
    --link gitlab-postgresql:postgresql --link gitlab-redis:redisio \
    --publish 10022:22 --publish 10080:9080 \
    --env 'GITLAB_HOST=0.0.0.0' \
    --env 'GITLAB_PORT=10080' --env 'GITLAB_SSH_PORT=10022' \
    --env 'GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string' \
    --env 'GITLAB_SECRETS_SECRET_KEY_BASE=long-and-random-alpha-numeric-string' \
    --env 'GITLAB_SECRETS_OTP_KEY_BASE=long-and-random-alpha-numeric-string' \
    --volume $home/gitlab/gitlab:/home/git/data \
    ${GITLAB_IMAGE}
}

deploy_$1