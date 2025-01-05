helm repo add kuberay https://ray-project.github.io/kuberay-helm/
helm repo update
helm install kuberay-operator kuberay/kuberay-operator --version 1.2.2

kubectl label node k3s-worker1 node-role.kubernetes.io/worker=worker
