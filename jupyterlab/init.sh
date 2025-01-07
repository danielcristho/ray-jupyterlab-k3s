helm upgrade --cleanup-on-fail \
  --install jupyterlab-deployment jupyterhub/jupyterhub \
  --namespace jupyterlab \
  --create-namespace \
  --version=0.11.1 \
  --values values.yaml