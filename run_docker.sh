#!/bin/bash

# イメージ名を辞書に格納
declare -A IMAGE_NAMES=(
    ["stylegan"]="nvidia/cuda:9.0-cudnn8-devel-ubuntu16.04"
    ["cyclegan"]="nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04"
    ["basicsr"]="rabbit313/cuda:11.7.1-cudnn8-devel-ubuntu22.04.basicsr"
    ["vae"]="nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04.vae"
    ["hat"]="rabbit313/cuda:11.7.1-cudnn8-devel-ubuntu22.04.hat"
    ["mae"]="rabbit313/cuda:11.7.1-cudnn8-devel-ubuntu22.04-pytorch2.0.1.mae"
    ["vaegan"]="rabbit313/cuda:9-cudnn7-devel-pytorch0.4.1.vaegan"
    ["ddpm"]="rabbit313/cuda:11.7.1-cudnn8-devel-ubuntu22.04-pytorch2.0.1.ddpm"
    ["ddim"]="rabbit313/cuda:10.1-cudnn7-devel-pytorch1.6.1.ddim"
    ["ddimv2"]="rabbit313/cuda:11.6-cudnn8-devel-pytorch1.13.1.ddimv2"

)

# Dockerコンテナを実行するための関数
run_docker_container() {
    local image_name="$1"  # 引数として渡されたイメージ名を取得

    # Dockerコンテナを実行
    docker run -it \
           --rm \
           --gpus all \
           --shm-size=64g \
           --volume ~/workspace:/home/ru\
           "${image_name}" \
           /bin/bash
}

# 使用するイメージを選択する
echo "使用するDockerイメージを選択してください: stylegan, cyclegan, basicsr, vae, hat, mae, vaegan, ddpm, ddim, ddimv2"
read -p "選択: " selected_image

# 選択されたイメージ名に対応する値を取得し、関数に渡す
if [[ -n "${IMAGE_NAMES[$selected_image]}" ]]; then
    run_docker_container "${IMAGE_NAMES[$selected_image]}"
else
    echo "選択されたイメージ名は無効です。"
fi
