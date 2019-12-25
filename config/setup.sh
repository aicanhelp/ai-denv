#!/usr/bin/env bash

set -e

os=

function setupCentosRepos() {
    echo "Setup Centos Repositoris ..."
    sudo mkdir /etc/repos.d.bak
    sudo mv /etc/repos.d/*   /etc/repos.d.bak
    sudo cp centos/etc/repos.d/nexus.repo   /etc/repos.d
}

function setupDocker(){
    echo "Setup Docker ..."

    sudo groupadd docker || sudo gpasswd -a ${USER} docker || sudo systemctl restart docker

    ! sudo test -e /etc/docker && sudo mkdir /etc/docker
    sudo cp common/etc/docker/daemon.json  /etc/docker
}

function setupCentosPki(){
    echo "Setup Centos Pki ..."
    sudo cp centos/etc/pki/rpm-gpg/*     /etc/pki/rpm-gpg
}

function setupUbuntuSource(){
    echo "Setup Ubuntu Sources ..."
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo cp $os/etc/apt/sources.list /etc/apt
}

function setupUbuntuGPG(){
    echo "Setup Ubuntu gpg ..."
    for gpg in `ls ubuntu/gpg`
    do
        sudo apt-key add ubuntu/gpg/$gpg
    done
}

function isCentos(){
    test -e /etc/redhat-release
}

function isUbuntu(){
    uname -a | grep ubuntu > /dev/null
}

function checkOS(){
    echo "Check OS ..."
    if isCentos; then
        os=centos
        return
    fi

    if isUbuntu; then
        os=ubuntu
        return
    fi

}

function run_on_centos(){
    setupCentosRepos
    setupDocker
    setupCentosPki
}

function run_on_ubuntu(){
    setupUbuntuSource
    setupDocker
    setupUbuntuGPG
}

function run(){
    checkOS

    if [ "$os" = "" ]; then
       echo "Not supported on this OS!"
       exit 1
    fi

    run_on_$os

    echo "The setup is completed."
}

run