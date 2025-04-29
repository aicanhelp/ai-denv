
## 可以使用 vagrant的镜像来启动 基于 libvirt的虚拟机
https://hub.docker.com/r/vagrantlibvirt/vagrant-libvirt




Usage
The default image contains the full toolchain required to build and install vagrant-libvirt and it's dependencies. There is also a smaller image published with the -slim suffix if you just need vagrant-libvirt and don't need to install any additional plugins for your environment.

If you are connecting to a remote system libvirt, you may omit the -v /var/run/libvirt/:/var/run/libvirt/ mount bind. Some distributions patch the local vagrant environment to ensure vagrant-libvirt uses qemu:///session, which means you may need to set the environment variable LIBVIRT_DEFAULT_URI to the same value if looking to use this in place of your distribution provided installation.

To get the image with the most recent release:

docker pull vagrantlibvirt/vagrant-libvirt:latest
If you want the very latest code you can use the edge tag instead.

docker pull vagrantlibvirt/vagrant-libvirt:edge
Running the image:

docker run -it --rm \
  -e LIBVIRT_DEFAULT_URI \
  -v /var/run/libvirt/:/var/run/libvirt/ \
  -v ~/.vagrant.d:/.vagrant.d \
  -v $(realpath "${PWD}"):${PWD} \
  -w "${PWD}" \
  --network host \
  vagrantlibvirt/vagrant-libvirt:latest \
    vagrant status
It's possible to define a function in ~/.bashrc, for example:

vagrant(){
  docker run -it --rm \
    -e LIBVIRT_DEFAULT_URI \
    -v /var/run/libvirt/:/var/run/libvirt/ \
    -v ~/.vagrant.d:/.vagrant.d \
    -v $(realpath "${PWD}"):${PWD} \
    -w "${PWD}" \
    --network host \
    vagrantlibvirt/vagrant-libvirt:latest \
      vagrant $@
}
Extending the container image with additional vagrant plugins
By default the image published and used contains the entire tool chain required to install the vagrant-libvirt plugin and it's dependencies. This allows any plugin that requires native extensions to be installed and should be possible to use a simple FROM statement and ask vagrant to install additional plugins.

FROM vagrantlibvirt/vagrant-libvirt:latest

RUN vagrant plugin install <plugin>
Recently the image has now moved to bundling the plugin with the vagrant system plugins it should no longer attempt to reinstall each time. Eventually this will become the default so additional plugin installs will need to install any dependencies needed by them.