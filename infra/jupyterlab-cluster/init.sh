helm upgrade --cleanup-on-fail \
  --install jhub jupyterhub/jupyterhub \
  --namespace jhub \
  --create-namespace \
  --version=4.0.0 \
  --values config.yaml