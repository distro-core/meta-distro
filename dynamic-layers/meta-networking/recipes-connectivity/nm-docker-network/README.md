# Netplan

Example

~~~ text
networks:
  nm-devices:
    NM-b2e4c72e-d7f4-40e9-bf3b-f9a9c2a23e3d:
    renderer: NetworkManager
    networkmanager:
      uuid: b2e4c72e-d7f4-40e9-bf3b-f9a9c2a23e3d
      name: docker-bridge
      passthrough:
        connection.type: docker-bridge
        connection.options:
          driver: bridge
~~~
