FROM nginx:1.29.0@sha256:2acbfcbbcfa44cd9571220dfd241b978e51df09e41ae06046182dba33207fb22

# 安装 redsocks 和 iptables
RUN apt-get update && apt-get install -y \
    redsocks iptables iproute2 \
    && rm -rf /var/lib/apt/lists/*

# 拷贝配置文件
COPY redsocks.conf /etc/redsocks.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 使用自定义入口脚本
ENTRYPOINT ["/entrypoint.sh"]
