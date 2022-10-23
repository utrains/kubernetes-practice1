#!/bin/bash

##Nodes set up

apt-get install -y curl openssh-server vim 
sed -e 's/^.*PermitRootLogin prohibit-password/PermitRootLogin yes/g' -i  /etc/ssh/sshd_config
systemctl restart sshd 
systemctl disable --now ufw
hostnamectl set-hostname node1.k8s
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
 sudo apt-get install -y  containerd.io

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml

systemctl daemon-reload
sudo systemctl restart containerd

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.23.0-00  kubeadm=1.23.0-00  kubectl=1.23.0-00 
echo "Please wait... Your system will now be rebooted. Wait for 2 minutes and then relogin"
sleep 10
reboot

