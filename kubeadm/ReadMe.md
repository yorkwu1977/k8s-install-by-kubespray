
# 安装指南 - 离线安装K8s 1.14.0

## 说明：

a，本安装大部分都是离线安装，除了4-install-k8s-for-MasterAndWorder.sh中如下组件需要使用yum源安装：
yum install -y socat keepalived ipvsadm conntrack

b，如果使用Ansible批量操作，需要单独准备一台服务器。复制所有安装资源和ansible-playbook文件夹到Ansible服务器的/home目录。
  - ansible-hosts: ansible的iventory文件的参考格式，给所有服务器分组。
  - k8s-repo-setup.yaml: 在K8s Rregistry上执行的脚本。
  - k8s-presintall.yaml: 在K8s Master和K8s Worker上执行的脚本。 
  - k8s-cluster-hosts.yaml: 追加hosts配置到所有服务器上。

## 1. 环境需求

CentOS 7.3 +
内核版本 5.0.4 +

## 2. 定制内容

a, 修改Cluster-info里面的IP，对应实际IP。
b, 修改3-config-registry-for-all.sh里的【REGISTRY_HOST】为实际的IP。
c, 修改ansible-hosts里的IP为实际IP, 并复制到/etc/ansible/hosts。(如果用Assible)
d, 修改allhosts里的IP为实际IP，这里的内容会复制到所有服务器的/etc/hosts文件内。

## 3. 准备安装资源 

#### 3.1. 复制到K8s Master上的文件

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

#### 3.2. 复制到K8s Worker上的文件

复制如下资源到/home目录下：

- 1-preinstall-for-all.sh
- 2-install-docker-for-all.sh
- 3-config-registry-for-all.sh
- 4-install-k8s-for-MasterAndWorder.sh
- containerd.io-1.2.6-3.3.el7.x86_64.rpm
- docker-ce-cli-18.09.8-3.el7.x86_64.rpm
- docker-ce-18.09.8-3.el7.x86_64.rpm
- k8s-v1.14.0-rpms.tgz

#### 3.3.复制到K8s Registry上的文件

复制如下资源到/home目录下：

- 1-preinstall-for-all.sh
- 2-install-docker-for-all.sh
- 3-config-registry-for-all.sh
- containerd.io-1.2.6-3.3.el7.x86_64.rpm
- docker-ce-cli-18.09.8-3.el7.x86_64.rpm
- docker-ce-18.09.8-3.el7.x86_64.rpm
- k8s-repo-v1.14.0
- harbor-offline-installer-v1.8.1.tgz

#### 3.4 配置hosts

复制allhosts的内容到所有服务器的/etc/hosts文件内。

## 4. 手工安装

#### 4.1. 预安装 - 所有K8s 集群节点

依次执行:

```
$ bash 1-preinstall-for-all.sh
$ bash 2-install-docker-for-all.sh
$ bash 3-config-registry-for-all.sh
$ bash 4-install-k8s-for-MasterAndWorder.sh
```

#### 4.2. 安装K8s 私有镜像库 - Registry节点

依次执行:

```
$ bash 1-preinstall-for-all.sh
$ bash 2-install-docker-for-all.sh
$ bash 3-config-registry-for-all.sh
$ docker load -i k8s-repo-v1.14.0
$ docker run --restart=always -d -p 80:5000 --name repo harbor.io:1180/system/k8s-repo:v1.14.0
```

#### 4.3. 安装K8s Control Plane - Master node01节点

a, 设置3个Master节点之间的免密码登录。

b, 在Master node01 依次执行:

```
$ basd -c ./kubeha-gen.sh
```

