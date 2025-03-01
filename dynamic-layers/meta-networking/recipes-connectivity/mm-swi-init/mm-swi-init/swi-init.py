import logging
import gi

gi.require_version('ModemManager', '1.0')
from gi.repository import ModemManager, GLib

class MyModemPlugin(ModemManager.Plugin):
    """
    A simple ModemManager plugin to send AT commands with logging and error handling.
    """

    def __init__(self):
        super().__init__()
        self._logger = logging.getLogger(__name__)
        self._logger.setLevel(logging.DEBUG)  # Set logging level as needed
        handler = logging.StreamHandler()
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        handler.setFormatter(formatter)
        self._logger.addHandler(handler)

    def do_probe_modem(self, modem):
        """
        Probe the modem.
        """
        self._logger.debug(f"Probing modem: {modem.get_path()}")
        return True

    def do_setup_modem(self, modem):
        """
        Setup the modem.
        """
        self._logger.debug(f"Setting up modem: {modem.get_path()}")
        return True

    def do_enable_modem(self, modem):
        """
        Enable the modem.
        """
        self._logger.debug(f"Enabling modem: {modem.get_path()}")
        return True

    def do_disable_modem(self, modem):
        """
        Disable the modem.
        """
        self._logger.debug(f"Disabling modem: {modem.get_path()}")
        return True

    def do_send_at_command(self, modem, command, timeout, cancellable, callback, user_data):
        """
        Send an AT command to the modem.
        """
        self._logger.debug(f"Sending AT command: {command} to {modem.get_path()}")
        try:
            modem.send_at_command(command, timeout, cancellable, self._send_at_command_ready, (callback, user_data))
        except GLib.Error as e:
            self._logger.error(f"Error sending AT command: {e}")
            callback(None, e, user_data)
        except Exception as e:
            self._logger.exception(f"Unexpected error sending AT command: {e}") #Log full stack trace.
            callback(None, GLib.Error(f"Unexpected error: {e}"), user_data)

    def _send_at_command_ready(self, modem, res, user_data):
        """
        Callback for send_at_command.
        """
        callback, user_data_inner = user_data
        try:
            response = modem.send_at_command_finish(res)
            self._logger.debug(f"AT command response: {response}")
            callback(response, None, user_data_inner)
        except GLib.Error as e:
            self._logger.error(f"Error receiving AT command response: {e}")
            callback(None, e, user_data_inner)
        except Exception as e:
            self._logger.exception(f"Unexpected error receiving AT command response: {e}")
            callback(None, GLib.Error(f"Unexpected error: {e}"), user_data_inner)

# Example usage (outside of ModemManager's plugin loading process)
if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG) #redundant, but useful for testing
    plugin = MyModemPlugin()

    class DummyModem:
        def get_path(self):
            return "/org/freedesktop/ModemManager1/Modem/0"

        def send_at_command(self, command, timeout, cancellable, callback, user_data):
            # Simulate a response or error
            if command == "AT+ERROR":
                callback(self, GLib.Error("Simulated AT error"), user_data)
            else:
                response = "OK"
                callback(self, response, user_data)

        def send_at_command_finish(self, res):
            if isinstance(res, GLib.Error):
                raise res
            return res

    def at_command_callback(response, error, user_data):
        if error:
            print(f"AT command failed: {error}")
        else:
            print(f"AT command succeeded: {response}")

    dummy_modem = DummyModem()
    plugin.do_probe_modem(dummy_modem)
    plugin.do_setup_modem(dummy_modem)
    plugin.do_enable_modem(dummy_modem)
    plugin.do_send_at_command(dummy_modem, "AT+CGMI", 10, None, at_command_callback, None)
    plugin.do_send_at_command(dummy_modem, "AT+ERROR", 10, None, at_command_callback, None) #Simulated Error
    plugin.do_disable_modem(dummy_modem)
