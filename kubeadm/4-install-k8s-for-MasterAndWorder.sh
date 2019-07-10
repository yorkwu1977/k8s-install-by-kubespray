#!/bin/sh

# 说明：安装kubernetes
# 执行范围：所有Master和Worker节点

yum install -y socat keepalived ipvsadm conntrack
# cd /home/    # 默认安装包和脚本文件都都在同一个目录下。如果不是，这里要改成安装包实际所在位置
tar -xzvf k8s-v1.14.0-rpms.tgz
cd k8s-v1.14.0
rpm -Uvh * --force
systemctl enable kubelet
kubeadm version -o short
