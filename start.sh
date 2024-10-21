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
cd /usr/local/bin/coredns/ && ./coredns -quiet &

/usr/local/bin/proxy-go/proxy sps -P "http://192.168.3.80:8445" -p ":443,:80" -q 8.8.8.8:53
