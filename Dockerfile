# 使用基础镜像，可以根据需要选择其他适用的Linux镜像
FROM debian

# 安装所需的软件包
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install qemu-kvm *zenhei* xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system-monitor  git xfce4 xfce4-terminal tightvncserver wget python3 python3-pip -y

# 安装WebSSH
RUN pip3 install webssh

# 下载noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz

# 移动noVNC到合适的位置
RUN mv noVNC-1.2.0 /noVNC

# 创建VNC密码
RUN mkdir $HOME/.vnc
RUN echo 'luo' | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

# 设置VNC和SSH端口
ENV VNC_PORT=7900
ENV SSH_PORT=22

# 创建启动脚本
RUN echo "#!/bin/bash" > /startup.sh
RUN echo "vncserver :$VNC_PORT -geometry 1280x800" >> /startup.sh
RUN echo "/noVNC/utils/launch.sh --vnc localhost:$VNC_PORT --listen 8900 &" >> /startup.sh
RUN echo "webssh -H 0.0.0.0 -p $SSH_PORT -u admin -p '!interfreevps@' &" >> /startup.sh
RUN echo "tail -f /dev/null" >> /startup.sh
RUN chmod +x /startup.sh

# 暴露容器端口
EXPOSE $SSH_PORT 8900

# 启动服务
CMD ["/startup.sh"]
