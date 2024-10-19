ARG IMAGE_NAME
FROM ${IMAGE_NAME}:11.7.1-devel-ubuntu22.04 as base

FROM base as base-amd64

ENV NV_CUDNN_VERSION 8.5.0.96
ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"

ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION-1+cuda11.7"
ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION-1+cuda11.7"


FROM base as base-arm64

ENV NV_CUDNN_VERSION 8.5.0.96
ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"

ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION-1+cuda11.7"
ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION-1+cuda11.7"

FROM base-${TARGETARCH}

ARG TARGETARCH

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"
LABEL com.nvidia.cudnn.version="${NV_CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} \
    && rm -rf /var/lib/apt/lists/*

#############################################
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y \
    wget \
    bzip2 \
    build-essential \
    unzip \
    git \
    git-lfs \
    curl \
    ca-certificates \
    libsndfile1-dev \
    libgl1 \
    python3.9 \
    python3.9-distutils \
    python3-pip

# 必要に応じてpipをインストール
RUN apt-get install -y curl && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    update-alternatives --set python3 /usr/bin/python3.9 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 && \
    update-alternatives --set python /usr/bin/python3.9

COPY requirements.txt .

RUN pip install --upgrade "pip<24.1" && \
    pip install -r requirements.txt

COPY ./BasicSR /Basicsr
WORKDIR /Basicsr
RUN pip install -e .

WORKDIR /app

ARG USER_ID=1002
ARG GROUP_ID=1002
RUN groupadd -g ${GROUP_ID} itoru && \
    useradd -u ${USER_ID} -g itoru -m -s /bin/bash itoru

USER itoru

CMD ["/bin/bash"]
