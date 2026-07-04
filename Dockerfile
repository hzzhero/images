FROM python:3.10-slim

# 安装依赖
RUN apt-get update && \
    apt-get install -y \
        fonts-noto-core \
        fonts-noto-cjk \
        fontconfig \
        libgl1 \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libgomp1 \
        libexpat1 \
        && \
    fc-cache -fv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

# 安装 MinerU（增加重试和超时参数）
RUN pip install --default-timeout=100 --retries=5 -U 'mineru[core]' && \
    pip cache purge

# 下载模型（可选，或挂载本地模型目录）
RUN mineru-models-download -s huggingface -m all

# 设置入口
ENTRYPOINT ["/bin/bash", "-c", "export MINERU_MODEL_SOURCE=local && exec \"$@\"", "--"]
