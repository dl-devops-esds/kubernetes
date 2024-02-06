#!/bin/bash

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install Docker
sudo apt-get install -y docker.io

# Add Kubernetes repository and install Kubernetes components
sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl

# Initialize Kubernetes cluster
sudo kubeadm init

# Set up kubeconfig for regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install network plugin (Calico used as an example, change as needed)
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Print join command for worker nodes
echo "Kubernetes cluster has been initialized. Run the following command on worker nodes to join:"
sudo kubeadm token create --print-join-command
