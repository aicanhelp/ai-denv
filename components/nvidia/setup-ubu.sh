#!/usr/bin/env bash
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update

DIST=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$DIST/libnvidia-container.list | \
  sudo tee /etc/apt/sources.list.d/libnvidia-container.list
sudo apt-get update

# activated nvidia driver (I was using Intel "(Power Saving Mode)" via the "Nvidia X Server Settings"), then rebooted system.
nvidia-smi # to verify it works.
# Removed nvidia-docker2:
sudo apt-get remove nvidia-docker2
sudo apt-get autoremove # to also remove nvidia-container-runtime and libnvidia-container
#Download v1 here & install: https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
sudo dpkg -i ~/Downloads/nvidia-docker_1.0.1-1_amd64.deb
sudo service docker restart # slow?!
# Remove all docker containers and volumes
docker ps -a # removed any containers that exist with docker rm <container>
docker volume ls # removed any volumes that exit with docker volume rm <volume>
sudo apt-get purge -y nvidia-docker
sudo reboot
sudo service docker restart # fast?!
sudo apt-get install nvidia-docker2
sudo service docker restart # fast!!!
nvidia-smi # works!
docker run --runtime=nvidia -it --rm nvidia/cuda nvidia-smi # works!