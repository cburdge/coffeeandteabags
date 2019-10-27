version: '3'

services:
  mqtt-bridge:
    image: stjohnjohnson/smartthings-mqtt-bridge
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/homeautomation/mqtt-bridge:/config
    ports:
      - 1884:8080
    depends_on:
      - mqtt
  mqtt:
    image: matteocollina/mosca
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/homeautomation/mqtt-mosca:/db
    ports:
      - 1883:1883
  home-assistant:
    image: homeassistant/home-assistant
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/homeautomation/hass:/config
    ports:
      - 8123:8123
    depends_on:
      - mqtt
      - mqtt-bridge