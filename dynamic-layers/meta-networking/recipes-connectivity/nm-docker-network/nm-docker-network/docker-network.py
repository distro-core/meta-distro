import gi
gi.require_version('NM', '1.0')
from gi.repository import GLib, NM
import docker
import signal
import sys
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class DockerNetworkPlugin(NM.ObjectPlugin):
    """
    NetworkManager plugin to manage Docker networks using the Docker Python API.
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._connections = {}
        self._client = None
        self._running = True

    def do_load(self):
        """
        Called when the plugin is loaded.
        """
        logger.info("DockerNetworkPlugin: Loaded")
        try:
            self._client = docker.from_env()
            self._client.ping() # test docker connection
        except docker.errors.DockerException as e:
            logger.error(f"DockerNetworkPlugin: Error connecting to Docker: {e}")
            return False

        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)
        return True

    def do_unload(self):
        """
        Called when the plugin is unloaded.
        """
        logger.info("DockerNetworkPlugin: Unloaded")
        if self._client:
            self._client.close()

    def do_add_connection(self, connection):
        """
        Called when a new connection is added.
        """
        settings = connection.get_settings()
        if settings.get_connection_type() == "docker-network":
            logger.info(f"DockerNetworkPlugin: Adding connection: {connection.get_uuid()}")
            self._connections[connection.get_uuid()] = connection
            self._apply_docker_network(connection)
            return True
        return False

    def do_remove_connection(self, connection):
        """
        Called when a connection is removed.
        """
        settings = connection.get_settings()
        if settings.get_connection_type() == "docker-network":
            logger.info(f"DockerNetworkPlugin: Removing connection: {connection.get_uuid()}")
            self._remove_docker_network(connection)
            del self._connections[connection.get_uuid()]
            return True
        return False

    def do_modify_connection(self, connection, old_connection):
        """
        Called when a connection is modified.
        """
        settings = connection.get_settings()
        if settings.get_connection_type() == "docker-network":
            logger.info(f"DockerNetworkPlugin: Modifying connection: {connection.get_uuid()}")
            self._remove_docker_network(old_connection)
            self._apply_docker_network(connection)
            self._connections[connection.get_uuid()] = connection
            return True
        return False

    def _apply_docker_network(self, connection):
        """
        Applies the Docker network configuration.
        """
        settings = connection.get_settings()
        docker_settings = settings.get_setting("docker-network")

        if not docker_settings:
            logger.warning(f"DockerNetworkPlugin: No docker-network settings found for {connection.get_uuid()}")
            return

        name = docker_settings.get_property("name")
        driver = docker_settings.get_property("driver")
        subnet = docker_settings.get_property("subnet")
        gateway = docker_settings.get_property("gateway")
        iprange = docker_settings.get_property("ip-range")
        options = docker_settings.get_property("options") or {}

        ipam_pool = docker.types.IPAMPool(subnet=subnet, gateway=gateway, iprange=iprange)
        ipam_config = docker.types.IPAMConfig(pool_configs=[ipam_pool])
        try:
            self._client.networks.create(name, driver=driver, ipam=ipam_config, options=options)
            logger.info(f"DockerNetworkPlugin: Created Docker network: {name}")

        except docker.errors.APIError as e:
            logger.error(f"DockerNetworkPlugin: Error creating Docker network: {e}")

    def _remove_docker_network(self, connection):
        """
        Removes the Docker network.
        """
        settings = connection.get_settings()
        docker_settings = settings.get_setting("docker-network")

        if not docker_settings:
            logger.warning(f"DockerNetworkPlugin: No docker-network settings found for {connection.get_uuid()}")
            return

        name = docker_settings.get_property("name")

        try:
            network = self._client.networks.get(name)
            network.remove()
            logger.info(f"DockerNetworkPlugin: Removed Docker network: {name}")
        except docker.errors.NotFound as e:
            logger.warning(f"DockerNetworkPlugin: Docker network not found: {e}")
        except docker.errors.APIError as e:
            logger.error(f"DockerNetworkPlugin: Error removing Docker network: {e}")

    def _signal_handler(self, sig, frame):
        """
        Handles signals.
        """
        logger.info(f"DockerNetworkPlugin: Received signal {sig}")
        self._running = False
        if self._client:
            self._client.close()
        sys.exit(0)
