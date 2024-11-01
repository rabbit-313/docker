FROM ubuntu:18.04 as base

FROM base as base-amd64

ENV NVARCH x86_64
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2 brand=tesla,driver>=418,driver<419"
ENV NV_CUDA_CUDART_VERSION 10.2.89-1

FROM base as base-ppc64le

ENV NVARCH ppc64el
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2"
ENV NV_CUDA_CUDART_VERSION 10.2.89-1

FROM base-${TARGETARCH}

ARG TARGETARCH

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.2.89

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-10-2=${NV_CUDA_CUDART_VERSION} \
    cuda-compat-10-2 \
    && ln -s cuda-10.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

COPY NGC-DL-CONTAINER-LICENSE /

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

################################## カスタム部分 ##################################
ARG USER_ID
ARG GROUP_ID

# USER_IDとGROUP_IDが渡されなかった場合にエラーを出す
RUN if [ -z "${USER_ID}" ] || [ -z "${GROUP_ID}" ]; then \
        echo "Error: USER_ID and GROUP_ID must be provided"; \
        exit 1; \
    fi

# 受け取ったUSER_IDとGROUP_IDでユーザーとグループを作成
RUN groupadd -g ${GROUP_ID} ru && \
    useradd -u ${USER_ID} -g ru -m -s /bin/bash ru

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN apt-get update -y && apt-get install -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update \
    && apt-get install -y curl unzip \
        python3.6 python3-pip python3-setuptools \
    && ln -s /usr/bin/python3.6 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# update pip
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel

COPY requirements.txt .

RUN pip3.6 install -r requirements.txt
RUN pip3.6 install https://download.pytorch.org/whl/cu92/torch-0.4.1-cp36-cp36m-linux_x86_64.whl

WORKDIR /home/ru

USER ru

CMD ["/bin/bash"]
