## PyTorch Release 20.3
The NVIDIA container image for PyTorch, release 20.03, is available on NGC.
Note: This docker definition is from nvidia. It's made for pulling the docker image by Aliyun easily.
from [PyTorch Release 20.3](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_20-03.html#rel_20-03)

### Contents of the PyTorch container
This container image contains the complete source of the version of PyTorch in /opt/pytorch. It is pre-built and installed in Conda default environment (/opt/conda/lib/python3.6/site-packages/torch/) in the container image.

### The container also includes the following:
- Ubuntu 18.04 including Python 3.6 environment
- NVIDIA CUDA 10.2.89 including cuBLAS 10.2.2.89
- NVIDIA cuDNN 7.6.5
- NVIDIA NCCL 2.6.3 (optimized for NVLink™ )
- APEX
- MLNX_OFED
- OpenMPI 3.1.4
- TensorBoard 2.1.0
- Nsight Compute 2019.5.0
- Nsight Systems 2020.1.1
- TensorRT 7.0.0
- DALI 0.19.0
- MAGMA 2.5.2
- Tensor Core optimized examples:
    - ResNeXt101-32x4d
    - SE-ResNext
    - TransformerXL
    - Jasper
    - BERT
    - Mask R-CNN
    - Tacotron 2 and WaveGlow v1.1
    - SSD300 v1.1
    - Neural Collaborative Filtering (NCF)
    - ResNet50 v1.5
    - GNMT v2
- Jupyter and JupyterLab:
    - Jupyter Client 6.0.0
    - Jupyter Core 4.6.1
    - Jupyter Notebook 6.0.3
    - JupyterLab 1.0.4
    - JupyterLab Server 1.0.6
    - Jupyter-TensorBoard

### Driver Requirements
Release 20.03 is based on NVIDIA CUDA 10.2.89, which requires NVIDIA Driver release 440.33.01. However, if you are running on Tesla (for example, T4 or any other Tesla board), you may use NVIDIA driver release 396, 384.111+, 410, 418.xx or 440.30. The CUDA driver's compatibility package only supports particular drivers. For a complete list of supported drivers, see the CUDA Application Compatibility topic. For more information, see CUDA Compatibility and Upgrades.

### GPU Requirements
Release 20.03 supports CUDA compute capability 6.0 and higher. This corresponds to GPUs in the Pascal, Volta, and Turing families. Specifically, for a list of GPUs that this compute capability corresponds to, see CUDA GPUs. For additional support details, see Deep Learning Frameworks Support Matrix.


### Key Features and Enhancements
This PyTorch release includes the following key features and enhancements.
- PyTorch container image version 20.03 is based on 1.5.0a0+8f84ded
- Latest version of DALI 0.19.0
- Performance improvements for elementwise operations
- Performance improvements for per-channel quantization
- Relaxation of cudnn batchnorm input shape requirements
- Ubuntu 18.04 with February 2020 updates

### Automatic Mixed Precision (AMP)
NVIDIA’s Automatic Mixed Precision (AMP) for PyTorch is available in this container through a preinstalled release of Apex. AMP enables users to try mixed precision training by adding only 3 lines of Python to an existing FP32 (default) script. Amp will choose an optimal set of operations to cast to FP16. FP16 operations require 2X reduced memory bandwidth (resulting in a 2X speedup for bandwidth-bound operations like most pointwise ops) and 2X reduced memory storage for intermediates (reducing the overall memory consumption of your model). Additionally, GEMMs and convolutions with FP16 inputs can run on Tensor Cores, which provide an 8X increase in computational throughput over FP32 arithmetic.

Comprehensive guidance and examples demonstrating AMP for PyTorch can be found in the documentation.

For more information about AMP, see the Training With Mixed Precision Guide.

### Tensor Core Examples
The tensor core examples provided in GitHub and NVIDIA GPU Cloud (NGC) focus on achieving the best performance and convergence from NVIDIA Volta tensor cores by using the latest deep learning example networks and model scripts for training.

Each example model trains with mixed precision Tensor Cores on Volta and Turing, therefore you can get results much faster than training without Tensor Cores. This model is tested against each NGC monthly container release to ensure consistent accuracy and performance over time. This container includes the following tensor core examples.
- ResNeXt101-32x4d model. The ResNeXt101-32x4d is a model introduced in the Aggregated Residual Transformations for Deep Neural Networks paper. It is based on regular ResNet model, substituting 3x3 convolutions inside the bottleneck block for 3x3 grouped convolutions. This model script is available on GitHub.
- SE-ResNext model. The SE-ResNeXt101-32x4d is a ResNeXt101-32x4d model with added Squeeze-and-Excitation (SE) module introduced in the Squeeze-and-Excitation Networks paper. This model script is available on GitHub.
- TransformerXL model. Transformer-XL is a transformer-based language model with a segment-level recurrence and a novel relative positional encoding. Enhancements introduced in Transformer-XL help capture better long-term dependencies by attending to tokens from multiple previous segments. Our implementation is based on the codebase published by the authors of the Transformer-XL paper. Our implementation uses modified model architecture hyperparameters. Our modifications were made to achieve better hardware utilization and to take advantage of Tensor Cores. his model script is available on GitHub
- Jasper model. This repository provides an implementation of the Jasper model in PyTorch from the paper Jasper: An End-to-End Convolutional Neural Acoustic Model. The Jasper model is an end-to-end neural acoustic model for automatic speech recognition (ASR) that provides near state-of-the-art results on LibriSpeech among end-to-end ASR models without any external data. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).
- BERT model. BERT, or Bidirectional Encoder Representations from Transformers, is a new method of pre-training language representations which obtains state-of-the-art results on a wide array of Natural Language Processing (NLP) tasks. This model is based on theBERT: Pre-training of Deep Bidirectional Transformers for Language Understanding paper. NVIDIA's implementation of BERT is an optimized version of the Hugging Face implementation, leveraging mixed precision arithmetic and Tensor Cores on V100 GPUs for faster training times while maintaining target accuracy. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).
- Mask R-CNN model. Mask R-CNN is a convolution based neural network for the task of object instance segmentation. The paper describing the model can be found here. NVIDIA’s Mask R-CNN model is an optimized version of Facebook’s implementation, leveraging mixed precision arithmetic using Tensor Cores on NVIDIA Tesla V100 GPUs for 1.3x faster training time while maintaining target accuracy. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).
- Tacotron 2 and WaveGlow v1.1 model. This text-to-speech (TTS) system is a combination of two neural network models: a modified Tacotron 2 model from the Natural TTS Synthesis by Conditioning WaveNet on Mel Spectrogram Predictions paper and a flow-based neural network model from the WaveGlow: A Flow-based Generative Network for Speech Synthesis paper. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).
- SSD300 v1.1 model. The SSD300 v1.1 model is based on the SSD: Single Shot MultiBox Detector paper. The main difference between this model and the one described in the paper is in the backbone. Specifically, the VGG model is obsolete and is replaced by the ResNet50 model. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).
- NCF model. The Neural Collaborative Filtering (NCF) model focuses on providing recommendations, also known as collaborative filtering; with implicit feedback. The training data for this model should contain binary information about whether a user interacted with a specific item. NCF was first described by Xiangnan He, Lizi Liao, Hanwang Zhang, Liqiang Nie, Xia Hu and Tat-Seng Chua in the Neural Collaborative Filtering paper. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).
- ResNet50 v1.5 model. The ResNet50 v1.5 model is a modified version of the original ResNet50 v1 model. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).
- GNMT v2 model. The GNMT v2 model is similar to the one discussed in the Google's Neural Machine Translation System: Bridging the Gap between Human and Machine Translation paper. This model script is available on GitHub as well as NVIDIA GPU Cloud (NGC).

### Known Issues
There is up to 5% performance drop on Transformer-XL mixed precision training in the 20.01 container compared to 19.11. Disabling the profiling executor at the beginning of your script might reduce this effect via:
torch._C._jit_set_profiling_executor(False)
torch._C._jit_set_profiling_mode(False)
A workaround for the WaveGlow training regression from our past containers is to use a fake batch dimension when calculating the log determinant via torch.logdet(W.unsqueeze(0).float()).squeeze() as is done in this release.