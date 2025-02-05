#!/usr/bin/env bash

VAULT_TOKEN="dev-only-token"

function start(){

    docker stop docker-vault
    docker rm docker-vault

    docker run -d -p 8200:8200 \
       --restart=always \
       --name docker-vault \
       -e "VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN}" hashicorp/vault

    cd $curDir
}

function set(){
	store=$1
	key=$2
	value=$3

    data="{\"data\": {\"${key}\": \"${value}\"}}"
	 curl \
       --header "X-Vault-Token: $VAULT_TOKEN" \
       --header "Content-Type: application/json" \
       --request POST \
       --data '{"data": {"${key}": "${value}"}}' \
    http://127.0.0.1:8200/v1/secret/data/${store}
}


function get(){
	store=$1
	
    curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    http://127.0.0.1:8200/v1/secret/data/my-secret-password > secrets.json

}


start