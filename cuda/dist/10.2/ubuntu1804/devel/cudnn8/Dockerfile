ARG IMAGE_NAME
FROM ${IMAGE_NAME}:10.2-devel-ubuntu18.04 as base

FROM base as base-amd64

ENV NV_CUDNN_PACKAGE_VERSION 8.6.0.163-1
ENV NV_CUDNN_VERSION 8.6.0.163

ENV NV_CUDNN_PACKAGE_NAME libcudnn8
ENV NV_CUDNN_PACKAGE ${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}+cuda10.2
ENV NV_CUDNN_PACKAGE_DEV ${NV_CUDNN_PACKAGE_NAME}-dev=${NV_CUDNN_PACKAGE_VERSION}+cuda10.2

FROM base-${TARGETARCH}

ARG TARGETARCH

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

ENV CUDNN_VERSION ${NV_CUDNN_VERSION}

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} && \
    rm -rf /var/lib/apt/lists/*


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
    unzip \
    build-essential \
    python3-dev \
    python3-pip \
    gcc \
    libssl-dev \    
    libffi-dev \ 
    && apt-get clean

# Anacondaのインストールスクリプトをダウンロード
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -r Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

# # Install TensorFlow
RUN pip install -U pip &&  \
    conda update -n base -c defaults conda && \ 
    conda create -n myenv python=3.7.2 && \
    conda init && \
    echo "conda activate myenv" >> ~/.bashrc 

ENV CONDA_DEFAULT_ENV myenv && \
    PATH /opt/conda/envs/myenv/bin:$PATH

COPY requirements.txt .
RUN /bin/bash -c "source activate myenv && pip install -r requirements.txt"

CMD ["/bin/bash"]
