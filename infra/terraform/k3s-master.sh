#!/usr/bin/env bash

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin

# Install K3s on the master node
# curl -sfL https://get.k3s.io | sh -

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none --disable-network-policy --cluster-cidr=192.168.0.0/16" sh -

# Make sure kubectl is set up for the ubuntu user
sudo mkdir -p /home/ubuntu/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
sudo chown -R vagrant:vagrant /home/ubuntu/.kube/config

# Get the token for the worker nodes
# TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# # Store the token for the workers to use
# echo "$TOKEN" > /ubuntu/token

# # Install Docker
# curl -fsSL https://get.docker.com -o install-docker.sh
# sudo sh install-docker.sh
# sudo usermod -aG docker "$USER"

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# install docker
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh

# Clone kuberay project
git clone https://github.com/ray-project/kuberay.git
