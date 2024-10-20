#!/bin/bash

# 获取容器IP
CONTAINER_IP=$(hostname -i)
UPSTREAM_PROXY=${UPSTREAM_PROXY}
echo "CONTAINER_IP: $CONTAINER_IP"
echo "UPSTREAM_PROXY: $UPSTREAM_PROXY"
# 更新dnsmasq配置
sed -i "s/CONTAINER_IP/$CONTAINER_IP/g" /etc/dns2proxy/dnsmasq.conf
sed -i "s|UPSTREAM_PROXY|$UPSTREAM_PROXY|g" /etc/dns2proxy/glider.conf
# 启动glider
glider -config /etc/dns2proxy/glider.conf &

# 设置iptables规则
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 8445
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 8445

# 启动dnsmasq
dnsmasq -C /etc/dns2proxy/dnsmasq.conf --no-daemon