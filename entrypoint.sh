#!/bin/bash
set -e

# 启动 redsocks
redsocks -c /etc/redsocks.conf &

# 清理并新建 REDSOCKS 链
iptables-legacy -t nat -F
iptables-legacy -t nat -X REDSOCKS || true
iptables-legacy -t nat -N REDSOCKS

# REDSOCKS 链 -> 转发到 12345
iptables-legacy -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345

# 匹配 9100-9200
iptables-legacy -t nat -A OUTPUT -p tcp --dport 9100:9200 -j REDSOCKS
#iptables-legacy -t nat -A PREROUTING -p tcp --dport 9100:9200 -j REDSOCKS

# 启动 nginx
nginx -g 'daemon off;'