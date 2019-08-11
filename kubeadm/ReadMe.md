
# Kubernetes 1.14.0 脚本离线安装 by kubeadm

## 安装步骤说明

1. 准备安装资源
2. 预安装Kubernetes
3. 安装Kubernetes Control Plane

## 说明

#### 需要在线安装的资源

- socat 
- keepalived 
- ipvsadm 
- conntrack。

#### 需要手工执行的操作

- 设置所有服务器的Hosts。
- Master节点之间的免密码登录。

## 环境需求

- CentOS 7.3 +
- Linux内核版本 5.0.4 +

## 定制内容

a, 修改Cluster-info里面的IP，对应实际IP。
b, 修改3-config-registry-for-all.sh里的【REGISTRY_HOST】为实际的IP。
c, 修改allhosts里的IP为实际IP，这里的内容会复制到所有服务器的/etc/hosts文件内。
d, 修改ansible-hosts里的IP为实际IP, 并复制到/etc/ansible/hosts。(如果用Assible)

## 1. 准备安装资源 

#### 复制到K8s Master上的文件

复制如下资源到/home目录下：

- 1-preinstall-for-all.sh
- 2-install-docker-for-all.sh
- 3-config-registry-for-all.sh
- 4-install-k8s-for-MasterAndWorder.sh
- containerd.io-1.2.6-3.3.el7.x86_64.rpm
- docker-ce-cli-18.09.8-3.el7.x86_64.rpm
- docker-ce-18.09.8-3.el7.x86_64.rpm
- k8s-v1.14.0-rpms.tgz
- calico.yaml
- traefik.yaml
- metrics.yaml
- kubernetes-dashboard.yaml
- cluster-info
- kubeha-gen.sh

#### 复制到K8s Worker上的文件

复制如下资源到/home目录下：

- 1-preinstall-for-all.sh
- 2-install-docker-for-all.sh
- 3-config-registry-for-all.sh
- 4-install-k8s-for-MasterAndWorder.sh
- containerd.io-1.2.6-3.3.el7.x86_64.rpm
- docker-ce-cli-18.09.8-3.el7.x86_64.rpm
- docker-ce-18.09.8-3.el7.x86_64.rpm
- k8s-v1.14.0-rpms.tgz

#### 复制到K8s Registry上的文件

复制如下资源到/home目录下：

- 1-preinstall-for-all.sh
- 2-install-docker-for-all.sh
- 3-config-registry-for-all.sh
- containerd.io-1.2.6-3.3.el7.x86_64.rpm
- docker-ce-cli-18.09.8-3.el7.x86_64.rpm
- docker-ce-18.09.8-3.el7.x86_64.rpm
- k8s-repo-v1.14.0
- harbor-offline-installer-v1.8.1.tgz

## 2. 预安装Kubernetes

#### 所有K8s 集群节点

a. 复制allhosts的内容到所有服务器的/etc/hosts文件内。

b. 依次执行:

```
$ bash 1-preinstall-for-all.sh
$ bash 2-install-docker-for-all.sh
$ bash 3-config-registry-for-all.sh
$ bash 4-install-k8s-for-MasterAndWorder.sh
```

#### Registry节点

依次执行:

```
$ bash 1-preinstall-for-all.sh
$ bash 2-install-docker-for-all.sh
$ bash 3-config-registry-for-all.sh
$ docker load -i k8s-repo-v1.14.0
$ docker run --restart=always -d -p 80:5000 --name repo harbor.io:1180/system/k8s-repo:v1.14.0
```
## 3. 安装Kubernetes Control Plane

a, 设置3个Master节点之间的免密码登录。

b, 在Master node01 执行:

```
$ basd -c ./kubeha-gen.sh
```

## 5. 使用 Ansible 剧本执行

需要单独准备一台服务器。复制所有安装资源和ansible-playbook文件夹到Ansible服务器的/home目录。
  - ansible-hosts: ansible的iventory文件的参考格式，给所有服务器分组。
  - k8s-repo-setup.yaml: 在K8s Rregistry上执行的脚本。
  - k8s-presintall.yaml: 在K8s Master和K8s Worker上执行的脚本。 
  - k8s-cluster-hosts.yaml: 追加hosts配置到所有服务器上。