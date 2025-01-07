.PHONY: raycluster

kuberay_version = 0.6.0

## Build and push images to private registry
publish:
	docker build -t localhost:5100/ray:latest -f infra/docker/ray.Dockerfile .
	docker build -t localhost:5100/jupyterhub:latest -f infra/docker/jupyterhub.Dockerfile .
	docker push ray:latest
	docker push jupyterhub:latest

publish-ray:
	docker build -t localhost:5100/ray:latest -f infra/docker/ray.Dockerfile .
	docker push ray:latest

publish-jupyterhub:
	docker build -t localhost:5100/jupyterhub:latest -f infra/docker/jupyterhub.Dockerfile .
	docker push jupyterhub:latest

## install kuberay operator using quickstart manifests
kuberay:
# add helm repo and update to latest
	kubectl label node k3s-worker1 node-role.kubernetes.io/worker=worker
	helm repo add kuberay https://ray-project.github.io/kuberay-helm/
	helm repo update kuberay
	helm upgrade --install kuberay-operator kuberay/kuberay-operator --version $(kuberay_version) --wait --debug > /dev/null

## create ray cluster
raycluster:
	helm upgrade --install raycluster kuberay/ray-cluster --version $(kuberay_version) --values infra/raycluster/values.yaml --wait --debug > /dev/null
# restart needed because of https://github.com/ray-project/kuberay/issues/234
	make restart

## restart the ray cluster
restart:
	kubectl delete pod -lapp.kubernetes.io/name=kuberay --wait=false || true

cluster = kuberay
service = raycluster-$(cluster)-head-svc

## install k3d ingress
k3d-ingress:
	helm upgrade --install example-cluster-ingress infra/ingress --set cluster=raycluster-$(cluster) --wait

## get shell on head pod
shell:
	kubectl exec -i -t service/$(service) -- /bin/bash

## port forward the service
ray-forward:
	kubectl port-forward svc/$(service) 10001:10001 8265:8265 6379:6379 --address=0.0.0.0

## status
status: $(venv)
	$(venv)/bin/ray status --address 192.168.122.10:6379 -v

## print ray commit
version: $(venv)
	$(venv)/bin/python -c 'import ray; print(f"{ray.__version__} {ray.__commit__}")'

## remove cluster
delete:
	kubectl delete raycluster raycluster-$(cluster)

## ping server endpoint
ping: $(venv)
	$(venv)/bin/python -m raydemo.ping

## head node logs
logs-head:
	kubectl logs -lray.io/cluster=raycluster-kuberay -lray.io/node-type=head -c ray-head -f

## worker node logs
logs-worker:
	kubectl logs -lray.io/group=workergroup -f

## auto-scaler logs
logs-as:
	kubectl logs -lray.io/cluster=raycluster-kuberay -lray.io/node-type=head -c autoscaler -f

## enable trafefik debug loglevel
tdebug:
	kubectl -n kube-system patch deployment traefik --type json -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/0", "value":"--log.level=DEBUG"}]'

## tail traefik logs
tlogs:
	kubectl -n kube-system logs -l app.kubernetes.io/name=traefik -f

## forward traefik dashboard
tdashboard:
	@echo Forwarding traefik dashboard to http://192.168.122.10:9000/dashboard/
	tpod=$$(kubectl get pod -n kube-system -l app.kubernetes.io/name=traefik -o custom-columns=:metadata.name --no-headers=true) && \
		kubectl -n kube-system port-forward $$tpod 9000:9000

## run tf_mnist on cluster
tf_mnist: $(venv)
	$(venv)/bin/python -m raydemo.tf_mnist --address ray://192.168.122.10:10001

## list jobs
job-list: $(venv)
	$(venv)/bin/ray job list --address http://192.168.122.10:8265

## JupyterHub initilize

## Forward JupyterHub services
kubectl port-forward service/hub 8081:8081 -n jupyterlab --address=0.0.0.0
kubectl port-forward service/proxy-api 8001:8001 -n jupyterlab --address=0.0.0.0
kubectl port-forward service/proxy-public 8080:80 -n jupyterlab --address=0.0.0.0

