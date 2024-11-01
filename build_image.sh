cd ddim_v2
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) \
             -t rabbit313/cuda:11.6-cudnn8-devel-pytorch1.13.1.ddimv2 .

# docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) \
#              --build-arg IMAGE_NAME=nvidia/cuda --build-arg TARGETARCH=amd64 \
#              -t rabbit313/cuda:9.2-cudnn7-devel-ubuntu18.04.rcan .

# docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) \
#              -t rabbit313/cuda:9-cudnn7-devel-pytorch0.4.1.vaegan
