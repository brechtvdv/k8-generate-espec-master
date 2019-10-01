#!/usr/bin/env bash

apt-get update
apt-get install -y apt-transport-https software-properties-common bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo deb https://packages.cloud.google.com/apt/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
swapoff -a
apt-get install -y docker-ce=17.06.0~ce-0~ubuntu containerd.io
#apt-get install -y kubelet=1.7.8-00 kubeadm=1.7.8-00 kubectl=1.7.8-00 kubernetes-cni
apt-get install -y kubelet=1.14* kubeadm=1.14* kubectl=1.14* 
#kubernetes-cni

rm -rf /var/lib/kubelet/*

# This is necessary for crate-db
sysctl -w vm.max_map_count=262144
