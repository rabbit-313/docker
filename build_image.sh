cd cuda/dist/11.7.1/ubuntu2204/devel/cudnn8_hat
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) \
             --build-arg IMAGE_NAME=nvidia/cuda --build-arg TARGETARCH=amd64 \
             -t rabbit313/cuda:11.7.1-cudnn8-devel-ubuntu22.04.hat .
