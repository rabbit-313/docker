#!/bin/bash

# イメージ名を辞書に格納
declare -A IMAGE_NAMES=(
    ["stylegan"]="nvidia/cuda:9.0-cudnn8-devel-ubuntu16.04"
    ["cyclegan"]="nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04"
    ["basicsr"]="rabbit313/cuda:11.7.1-cudnn8-devel-ubuntu22.04.basicsr"
    ["vae"]="nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04.vae"
    ["hat"]="rabbit313/cuda:11.7.1-cudnn8-devel-ubuntu22.04.hat"
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
echo "使用するDockerイメージを選択してください: stylegan, cyclegan, basicsr, vae, hat"
read -p "選択: " selected_image

# 選択されたイメージ名に対応する値を取得し、関数に渡す
if [[ -n "${IMAGE_NAMES[$selected_image]}" ]]; then
    run_docker_container "${IMAGE_NAMES[$selected_image]}"
else
    echo "選択されたイメージ名は無効です。"
fi
