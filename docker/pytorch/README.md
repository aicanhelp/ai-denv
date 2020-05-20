## Running PyTorch
Before you can run an NGC deep learning framework container, your Docker environment must support NVIDIA GPUs. To run a container, issue the appropriate command as explained in the Running A Container chapter in the NVIDIA Containers And Frameworks User Guide and specify the registry, repository, and tags.

On a system with GPU support for NGC containers, the following occurs when running a container:
- The Docker engine loads the image into a container which runs the software.
- You define the runtime resources of the container by including additional flags and settings that are used with the command. These flags and settings are described in Running A Container.
- The GPUs are explicitly defined for the Docker container (defaults to all GPUs, but can be specified using NVIDIA_VISIBLE_DEVICES environment variable). Starting in Docker 19.03, follow the steps as outlined below. For more information, refer to the nvidia-docker documentation here.
The method implemented in your system depends on the DGX OS version installed (for DGX systems), the specific NGC Cloud Image provided by a Cloud Service Provider, or the software that you have installed in preparation for running NGC containers on TITAN PCs, Quadro PCs, or vGPUs.

1. Issue the command for the applicable release of the container that you want. The following command assumes you want to pull the latest container.
 `docker pull nvcr.io/nvidia/pytorch:20.03-py3`
2. Open a command prompt and paste the pull command. The pulling of the container image begins. Ensure the pull completes successfully before proceeding to the next step.
3. Run the container image. To run the container, choose interactive mode or non-interactive mode.
/**Interactive mode:**/

If you have Docker 19.03 or later, a typical command to launch the container is:
`docker run --gpus all -it --rm -v local_dir:container_dir nvcr.io/nvidia/pytorch:<xx.xx>-py3`
If you have Docker 19.02 or earlier, a typical command to launch the container is:
`nvidia-docker run -it --rm -v local_dir:container_dir nvcr.io/nvidia/pytorch:<xx.xx>-py3`
/**Non-interactive mode:**/

If you have Docker 19.03 or later, a typical command to launch the container is:
`docker run --gpus all -it --rm -v local_dir:container_dir nvcr.io/nvidia/pytorch:<xx.xx>-py3 <command>`
If you have Docker 19.02 or earlier, a typical command to launch the container is:
`nvidia-docker run -it --rm -v local_dir:container_dir nvcr.io/nvidia/pytorch:<xx.xx>-py3 <command>`
/**Note**/: If you use multiprocessing for multi-threaded data loaders, the default shared memory segment size that the container runs with may not be enough. Therefore, you should increase the shared memory size by issuing either:
`--ipc=host`
or
`--shm-size=<requested memory size>`
in the command line to
`docker run --gpus all`
You might want to pull in data and model descriptions from locations outside the container for use by PyTorch or save results to locations outside the container. To accomplish this, the easiest method is to mount one or more host directories as Docker® data volumes.