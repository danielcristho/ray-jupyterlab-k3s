#!/usr/bin/env bash

# Install Kubectl
sudo su
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin

# Get the token from the shared folder
# TOKEN=$(cat /ubuntu/token)

# Install K3s agent (worker) and join the master node
# curl -sfL https://get.k3s.io | K3S_URL=https://192.168.122.10:6443 K3S_TOKEN=$TOKEN sh -

# install docker
# curl -fsSL https://get.docker.com -o install-docker.sh
# sudo sh install-docker.sh
# sudo usermod -aG docker "$USER"
