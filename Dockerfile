# 使用基础镜像，可以根据需要选择其他适用的Linux镜像
FROM debian

# 更新软件包列表
RUN apt update

# 安装所需的软件包
RUN DEBIAN_FRONTEND=noninteractive apt install qemu-kvm *zenhei* xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system-monitor  git xfce4 xfce4-terminal tightvncserver wget -y

# 下载noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz

# 下载proot
RUN curl -LO https://proot.gitlab.io/proot/bin/proot
RUN chmod 755 proot
RUN mv proot /bin

# 解压noVNC
RUN tar -xvf v1.2.0.tar.gz

# 创建VNC密码
RUN mkdir  $HOME/.vnc
RUN echo '!interfreevps@' | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

# 创建启动脚本
RUN echo 'whoami ' >>/startup.sh
RUN echo 'cd ' >>/startup.sh
RUN echo "su -l -c  'vncserver :2000 -geometry 1280x800' "  >>/startup.sh
RUN echo 'cd /noVNC-1.2.0' >>/startup.sh
RUN echo './utils/launch.sh  --vnc localhost:7900 --listen 8900 ' >>/startup.sh
RUN chmod 755 /startup.sh

# 暴露容器端口
EXPOSE 8900

# 启动服务
CMD  /luo.sh
