FROM jupyterhub/jupyterhub:1.4

COPY ../jupyterlab-cluster/jupyterhub_config.yaml /srv/jupyterhub/jupyterhub_config.yaml