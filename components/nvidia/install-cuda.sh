#!/usr/bin/env bash

#wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
#sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
#sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
#sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
#sudo apt-get update
#sudo apt-get -y --allow-unauthenticated install cuda

https://developer.download.nvidia.cn/compute/cuda/10.0/secure/Prod/local_installers/cuda_10.0.130_410.48_linux.run?6MLjtqYt2Bov6gnjnHi_nxnm6RqJILshutUHtxpWMpy1HJVsZh5FmSAlrwofebPUkSg8KgUzjVbwSetagqY4RoTkab4vVMleI0QfFCKpoMQ1KKApAv7hochkoZ15FE0NYhEtQ8edtqHdio_urAewTv6r142oVn7Ib2jn6_pllByAPl54TYvDR5Q1TCc

wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
sudo sh cuda_10.2.89_440.33.01_linux.run

