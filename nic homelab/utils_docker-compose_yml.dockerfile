version: '3'

services:
  unifi-controller:
    image: linuxserver/unifi-controller
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/plexland/unifi:/config
    ports:
      - 3478:3478/udp
      - 10001:10001/udp
      - 8080:8080
      - 8081:8081
      - 8443:8443
      - 8843:8843
      - 8880:8880
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
