ARG IMAGE_NAME
FROM ${IMAGE_NAME}:9.0-runtime-ubuntu16.04 as base

FROM base as base-amd64

ENV NV_CUDA_LIB_VERSION 9.0.176-1
ENV NV_CUDA_CUDART_DEV_VERSION 9.0.176-1
ENV NV_NVML_DEV_VERSION 9.0.176-1
ENV NV_LIBCUSPARSE_DEV_VERSION 9.0.176-1
ENV NV_LIBNPP_DEV_VERSION 9.0.176-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME cuda-cublas-dev-9-0

ENV NV_LIBCUBLAS_DEV_VERSION 9.0.176-1
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}


FROM base as base-ppc64le

ENV NV_CUDA_LIB_VERSION 9.0.176-1
ENV NV_CUDA_CUDART_DEV_VERSION 9.0.176-1
ENV NV_NVML_DEV_VERSION 9.0.176-1
ENV NV_LIBCUSPARSE_DEV_VERSION 9.0.176-1
ENV NV_LIBNPP_DEV_VERSION 9.0.176-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME cuda-cublas-dev-9-0
ENV NV_LIBCUBLAS_DEV_VERSION 9.0.176-1
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

FROM base-${TARGETARCH}

ARG TARGETARCH
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-nvml-dev-9-0=${NV_NVML_DEV_VERSION} \
    cuda-command-line-tools-9-0=${NV_CUDA_LIB_VERSION} \
    cuda-npp-dev-9-0=${NV_LIBNPP_DEV_VERSION} \
    cuda-libraries-dev-9-0=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-9-0=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    --allow-unauthenticated && \
    rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

################ カスタム部分 ################
WORKDIR /app

RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git \
    build-essential \
    python3-dev \
    python3-pip \
    gcc \
    libssl-dev \    
    libffi-dev \ 
    && apt-get clean

# Anacondaのインストールスクリプトをダウンロード
RUN wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O /tmp/anaconda.sh

# スクリプトに実行権限を付与
RUN chmod +x /tmp/anaconda.sh

# Anacondaをインストール
RUN /tmp/anaconda.sh -b -p /opt/anaconda

# パスを設定
ENV PATH /opt/anaconda/bin:$PATH

# # Install TensorFlow
RUN pip install -U pip
RUN pip install tensorflow-gpu==1.10.0

# コンテナのデフォルトコマンド
CMD ["bash"]


