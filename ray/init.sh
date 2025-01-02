# install ray operator
helm repo add kuberay https://ray-project.github.io/kuberay-helm/
helm repo update
helm install kuberay-operator kuberay/kuberay-operator --version 1.2.2
sudo k3s kubectl get pods

# add raycluster
helm install raycluster kuberay/ray-cluster --version 1.2.2
sudo k3s kubectl get rayclusters
sudo k3s kubectl get pods --selector=ray.io/cluster=raycluster-kuberay

sudo k3s kubectl port-forward service/raycluster-kuberay-head-v5bm 8265:8265
