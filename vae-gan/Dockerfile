# 1. ベースとなるimage（docker hubで公開されている）
FROM pytorch/pytorch:0.4.1-cuda9-cudnn7-devel as base

# 2. ARGでホストからUSER_IDとGROUP_IDを受け取れるようにする
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

# 3. コンテナ起動後はここで指定したディレクトリがホームディレクトリとなる
# コンテナ起動後に "cd /" を入力してルートディレクトリを確認してみてください
WORKDIR /home/ru

# # パッケージのインストールの際に y/n の入力が要らなくなる
# ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update && \
#     apt-get install -y wget && \
#     wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub && \
#     apt-key add 3bf863cc.pub && \
#     rm 3bf863cc.pub

# # パッケージリストの更新とソフトウェアのインストール
# RUN apt-get update && \
#     apt-get install -y software-properties-common

# # deadsnakesを利用してpython3.9をインストール
# # あとその他のパッケージもインストール
# RUN add-apt-repository ppa:deadsnakes/ppa && \
#     apt update && \
#     apt install -y \
#     wget \
#     bzip2 \
#     build-essential \
#     unzip \
#     git \
#     git-lfs \
#     curl \
#     ca-certificates \
#     libsndfile1-dev \
#     libgl1 \
#     python3.6 \
#     python3.6-distutils \
#     python3-pip

# # pipをインストール
# RUN apt-get install -y curl && \
#     curl -sS https://bootstrap.pypa.io/get-pip.py | python3.6

# # Python 3.9をデフォルトのPythonに設定
# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 && \
#     update-alternatives --set python3 /usr/bin/python3.6 && \
#     update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && \
#     update-alternatives --set python /usr/bin/python3.6

# ホストマシンにあるrequirements.txtをコピーする
# /home/user 直下にコピーされる
COPY requirements.txt .

# pipのupgradeとrequirement.txtを使ったpythonライブラリのインストール
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# 5. 作業ユーザを切り替える
# 作業ユーザーをホストのIDに基づくユーザーに切り替える
USER ru

# 6. コンテナを立ち上げたときにシェルが起動する
CMD ["/bin/bash"]

