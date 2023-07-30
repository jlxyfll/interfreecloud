# 使用基础镜像，可以根据需要选择其他适用的Linux镜像
FROM ubuntu:latest

# 安装所需的软件包
RUN apt-get update && apt-get install -y openssh-server python3 python3-pip

# 安装WebSSH
RUN pip3 install webssh

# 创建一个新用户admin并设置密码
RUN useradd -m admin && \
    echo "admin:!interfreevps@" | chpasswd

# 允许root用户远程登录
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 暴露容器端口
EXPOSE 22

# 启动SSH服务
CMD service ssh start && /usr/local/bin/webssh --port 8080

