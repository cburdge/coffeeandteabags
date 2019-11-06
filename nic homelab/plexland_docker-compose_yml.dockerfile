version: '3'

services:
  sonarr:
    image: linuxserver/sonarr
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/plexland/sonarr:/config
      - /mnt/nfs/data/tvshows:/tv
      - /mnt/nfs/downloads:/downloads
    ports:
      - 8989:8989
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
    depends_on:
      - jackett
  radarr:
    image: linuxserver/radarr
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/plexland/radarr:/config
      - /mnt/nfs/data/movies:/movies
      - /mnt/nfs/downloads:/downloads
    ports:
      - 7878:7878
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
    depends_on:
      - jackett
  bazarr:
    image: linuxserver/bazarr:development
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/plexland/bazarr:/config
      - /mnt/nfs/data/movies:/movies
      - /mnt/nfs/data/tvshows:/tv
      - /mnt/nfs/downloads:/downloads
    ports:
      - 6767:6767
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
    depends_on:
      - sonarr
      - radarr
  jackett:
    image: linuxserver/jackett
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/plexland/jackett:/config
      - /mnt/nfs/downloads:/downloads
    ports:
      - 9117:9117
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
  plexpy:
    image: linuxserver/tautulli:latest
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/plexland/tautulli:/config
      - /dockerconfigs/plexland/plex/Library/Application\ Support\Plex\ Media\ Server/Logs:/logs:ro
    ports:
      - 8181:8181
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
    depends_on:
      - plex
  qbittorrent:
    image: linuxserver/qbittorrent
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
      - WEBUI_PORT=9090
      - UMASK_SET=022
    volumes:
      - /dockerconfigs/plexland/qbittorrent:/config
      - /mnt/nfs/downloads:/downloads
    ports:
      - 6881:6881
      - 6881:6881/udp
      - 9090:9090
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
  plex:
    image: plexinc/pms-docker:plexpass
    environment:
      - PLEX_UID=1001
      - PLEX_GID=1001
      - TZ=America/Chicago
      - PLEX_CLAIM="claim-hkcBxx5Xa2ZvvEUaW5ut"
      - CHANGE_CONFIG_DIR_OWNERSHIP=false
    network_mode: host
    volumes:
      - /dockerconfigs/plexland/plex:/config
      - /mnt/nfs/data:/data
      - /mnt/nfs/data/transcode:/transcode
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
  ombi:
    image: linuxserver/ombi
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=America/Chicago
    volumes:
      - /dockerconfigs/plexland/ombi:/config
    ports:
      - 3579:3579
    logging:
        driver: "json-file"
        options:
            max-file: "5"
            max-size: "10m"
