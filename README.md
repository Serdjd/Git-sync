# Git-sync
Satisfactory
version: '3'
services:
  satisfactory-server:

    container_name: satisfactory-server
    hostname: carvo
    image: wolveix/satisfactory-server:latest
    network_mode: host
    volumes:
      - /data/satisfactory:/config  # Montar el volumen compartido para archivos de guardado
    environment:
      - MAXPLAYERS=4
      - PGID=5000
      - PUID=5000
      - ROOTLESS=false
      - STEAMBETA=false
      - REPO_URL=https://github.com/Serdjd/Git-sync.git # URL del repositorio usando SSH
      - BRANCH=main
      - DIRECTORY=/config/saved/server
      - COMMIT_MESSAGE=Auto-commit, Updated save files
    ports:
      - '7777:7777/tcp'
      - '7777:7777/udp'
    entrypoint: ["/bin/bash", "-c", "
      apt-get update && \
      apt-get install -y git curl netcat && \
      curl -O https://raw.githubusercontent.com/Serdjd/Git-sync/main/sync.sh && \
      chmod +x sync.sh && \
      /init.sh & \

      while ! nc -z localhost 7777; do sleep 100; done && \
      ./sync.sh"]
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "bash", "/healthcheck.sh"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 120s
    deploy:
      resources:
        limits:
          memory: 6G
        reservations:
          memory: 4G
