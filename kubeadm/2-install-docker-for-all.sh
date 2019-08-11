#!/bin/sh

# 安装docker
# 执行范围：所有主机

yum install -y docker-ce-18.09.8-3.el7.x86_64.rpm docker-ce-cli-18.09.8-3.el7.x86_64.rpm containerd.io-1.2.6-3.3.el7.x86_64.rpm

# 编辑systemctl的Docker启动文件和配置文件

sed -i "13i ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT" /usr/lib/systemd/system/docker.service
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m"
  },
    "storage-driver": "overlay2"
  }
EOF

# 启动docker

systemctl daemon-reload
systemctl enable docker
systemctl start docker
