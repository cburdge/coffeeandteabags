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
