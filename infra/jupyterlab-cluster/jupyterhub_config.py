c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'

# Use the Postgres database for authentication.
c.JupyterHub.db_url = 'postgresql://jupyterhub:jupyterhub@jupyterhub-db/jupyterhub'

# Use the DockerSpawner to start user containers.
from jupyterhub.spawner import DockerSpawner

class MyDockerSpawner(DockerSpawner):
    def _options_form_default(self):
        return '''
        <label for="cpu">CPU limit (in cores):</label>
        <input type="text" name="cpu" placeholder="1">
        <br>
        <label for="mem">Memory limit (in GB):</label>
        <input type="text" name="mem" placeholder="1">
        <br>
        <label for="gpu">GPU count:</label>
        <input type="text" name="gpu" placeholder="0">
        <br>
        <label for="image">Docker image:</label>
        <input type="text" name="image" value="jupyter/minimal-notebook">
        <br>
        <label for="name">Container name:</label>
        <input type="text" name="name" placeholder="{username}-notebook">
        '''

c.JupyterHub.spawner_class = MyDockerSpawner

# Set the hub IP address for use in the singleuser server.
c.JupyterHub.hub_ip = 'jupyterhub'