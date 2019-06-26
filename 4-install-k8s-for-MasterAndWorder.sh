#!/bin/sh

# 说明：安装kubernetes
# 执行位置：所有Master和Worker节点

yum install -y socat keepalived ipvsadm conntrack
cd /home/k8s-install/    # 假设上一步下载的安装文件存放在这个目录下
tar -xzvf k8s-v1.14.0-rpms.tgz
cd k8s-v1.14.0
rpm -Uvh * --force
systemctl enable kubelet
kubeadm version -o short
