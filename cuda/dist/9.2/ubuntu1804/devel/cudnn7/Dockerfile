ARG IMAGE_NAME
FROM ${IMAGE_NAME}:9.2-devel-ubuntu18.04 as base

FROM base as base-amd64

ENV NV_CUDNN_PACKAGE_VERSION 7.6.5.32-1
ENV NV_CUDNN_VERSION 7.6.5.32

ENV NV_CUDNN_PACKAGE_NAME libcudnn7
ENV NV_CUDNN_PACKAGE ${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}+cuda9.2
ENV NV_CUDNN_PACKAGE_DEV ${NV_CUDNN_PACKAGE_NAME}-dev=${NV_CUDNN_PACKAGE_VERSION}+cuda9.2

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


###############################################################
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
