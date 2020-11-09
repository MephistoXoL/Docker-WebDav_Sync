![Docker-WebDav_Sync](https://raw.githubusercontent.com/MephistoXoL/Docker-WebDav_Sync/master/WebDav_Sync.png)

# Docker-WebDav_Sync
Multi Arch to Sync 2 WebDav Folders Bidirectionaly

[![Docker Pulls](https://img.shields.io/docker/pulls/mephistoxol/webdav_sync?logo=docker)](https://hub.docker.com/r/mephistoxol/webdav_sync)
[![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/mephistoxol/webdav_sync/latest?logo=linux&logoColor=white)](https://hub.docker.com/r/mephistoxol/webdav_sync)
[![MicroBadger Layers](https://img.shields.io/microbadger/layers/mephistoxol/webdav_sync/latest)](https://hub.docker.com/r/mephistoxol/webdav_sync)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/mephistoxol/webdav_sync/latest)](https://hub.docker.com/r/mephistoxol/webdav_sync)
[![Docker Stars](https://img.shields.io/docker/stars/mephistoxol/webdav_sync)](https://hub.docker.com/r/mephistoxol/webdav_sync)
[![Paypal](https://img.shields.io/badge/paypal-donate-orange?logo=paypal)](https://www.paypal.me/mephistoxol)

## Environment Variables
You can add ```EXTENSION``` env. variable to sync only one type of files. 

| Env. Variable | Description |
| --- | --- |
| REMOTE_WEBDAV| Your Remote WebDav Folder |
| LOCAL_WEBDAV| Your Local WebDav Folder |
| REMOTE_USER| webdav remote user |
| REMOTE_PASSWORD| webdav remote password |
| LOCAL_USER| webdav local user |
| LOCAL_PASSWORD| webdav local user |
| EXTENSION**| file extension |
| TIMEZONE| Your timezone, e.g. Europe/Madrid |
| CRON_MINUTES***| Cron Schedule every X minutes |

** Extension File can be set by this variable, leave empty for all files

*** CRON_MINUTES, leave empty for default = every 3 min.

## Install
Command line:
```
 docker run --name=Sync_WebDav --privileged --cap-add=ALL \
 -e REMOTE_WEBDAV="Your Remote WebDav Folder" \
 -e LOCAL_WEBDAV="Your Local WebDav Folder" \
 -e REMOTE_USER="webdav remote user" \
 -e REMOTE_PASSWORD="webdav remote password" \
 -e LOCAL_USER="webdav local user" \
 -e LOCAL_PASSWORD="webdav local user" \
 -e EXTENSION="file extension" \
 -e TIMEZONE="Europe/Madrid" \
 -e CRON_MINUTES="15" \
 mephistoxol/webdav_sync
```

Docker Compose:
```
version: '3.2'
services:
  app:
    container_name: Sync_WebDav
    image: mephistoxol/webdav_sync
    cap_add:
      - ALL
    privileged: true
    restart: unless-stopped
    env:
      - REMOTE_WEBDAV="Your Remote WebDav Folder"
      - LOCAL_WEBDAV="Your Local WebDav Folder"
      - REMOTE_USER="webdav remote user"
      - REMOTE_PASSWORD="webdav remote password" 
      - LOCAL_USER="webdav local user"
      - LOCAL_PASSWORD="webdav local user"
      - EXTENSION="file extension"
      - TIMEZONE="Europe/Madrid"
      - CRON_MINUTES="15"
    # Traefik v1.7 optional
    labels:
      - traefik.enable: "False"   
    networks:      
      - internal-network

```

Ansible:
```
      docker_container:
        name: Sync_WebDav
        image: mephistoxol/webdav_sync
        capabilities: ALL
        privileged: yes
        env:
          REMOTE_WEBDAV: "Your Remote WebDav Folder"
          LOCAL_WEBDAV: "Your Local WebDav Folder"
          REMOTE_USER: "webdav remote user"
          REMOTE_PASSWORD: "webdav remote password" 
          LOCAL_USER: "webdav local user"
          LOCAL_PASSWORD: "webdav local user"
          EXTENSION: "file extension"
          TIMEZONE="Europe/Madrid"
          CRON_MINUTES="15"
        restart_policy: unless-stopped
        # Traefik v1.7 optional
        labels:
          ttraefik.enable: "False" 
        networks:
          - name: internal-network
      register: result
```

## Changelog
```
10-05-2020
- v1.08
  · Added new Feature: Stop cronjob while Replica is running.
```
```
25-04-2020
- v1.07
  · Fixed error sed command in Sync_Folders script.
  · Added date in log when replica start and end.
```
```
19-04-2020
- v1.06
  · Change to unison for replication.
  · Added new env. variable TIMEZONE.
  · Added new env. variable CRON_MINUTES.
  · Minor changes in Entrypoint and Sync_Folders scripts.
```
```
28-03-2020
- v1.04
  · Fixed error when include all files (No file extension).
```
```
24-11-2019
- v1.03
  · Added 5 attempts to mount the folders
```
```
16-11-2019
- v1.02
  · Fix old .pid files. Removing them after restart to mount again.
  · Added version as label
```
```
13-11-2019
- v1.01
  · Fix include files when use EXTENSION env. variable
```
```
13-11-2019
- Initial Release
```

## Donate
[![Paypal](https://raw.githubusercontent.com/MephistoXoL/Things/master/paypal.png)](https://www.paypal.me/mephistoxol)
