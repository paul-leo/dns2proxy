# 使用Ubuntu作为基础镜像
FROM ubuntu:20.04

# 避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive
# 设置环境变量
ENV UPSTREAM_PROXY=
ENV FORWARD_DNS="8.8.8.8"

# 安装必要的软件
RUN apt-get update && apt-get install -y \
    dnsmasq
# 安装 glider
COPY glider/glider /usr/local/bin/glider
COPY proxy-go/* /usr/local/bin/proxy-go/
RUN chmod +x /usr/local/bin/proxy-go/proxy
RUN mkdir /etc/dns2proxy/
# 复制dnsmasq配置文件
COPY dnsmasq.conf /etc/dns2proxy/dnsmasq.conf

# 复制glider配置文件
COPY glider.conf /etc/dns2proxy/glider.conf
COPY coredns/* /usr/local/bin/coredns/
RUN chmod +x /usr/local/bin/coredns/coredns

# 复制启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 暴露DNS端口和代理端口
EXPOSE 53/udp 53/tcp

# 设置容器启动命令
CMD ["/start.sh"]