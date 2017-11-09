# lidarr-docker
Lidarr docker image

[![Docker Pulls](https://img.shields.io/docker/pulls/volikon/lidarr.svg)](https://hub.docker.com/r/volikon/lidarr/)

https://github.com/lidarr/Lidarr

Based on Linuxserver's Sonarr:
https://github.com/linuxserver/docker-sonarr

## Usage
```
docker run \
        --name lidarr \
        -p 8686:8686 \
        -e PUID=<UID> -e PGID=<GID> \
        -e TZ=<timezone> \ 
        -v /etc/localtime:/etc/localtime:ro \
        -v </path/to/appdata>:/config \
        -v <path/to/tvseries>:/music \
        -v <path/to/downloadclient-downloads>:/downloads \
        volikon/lidarr:latest
```
volikon/lidarr:latest is nightly build.

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 8686` - the port lidarr webinterface
* `-v /config` - database and lidarr configs
* `-v /music` - location of Music library on disk
* `-v /etc/localtime` for timesync - see [Localtime](#localtime) for important information
* `-e TZ` for timezone information, Europe/London - see [Localtime](#localtime) for important information
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation

It is based on ubuntu xenial with S6 overlay, for shell access whilst the container is running do `docker exec -it lidarr /bin/bash`.

## Localtime

It is important that you either set `-v /etc/localtime:/etc/localtime:ro` or the TZ variable, mono will throw exceptions without one of them set.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" <sup>TM</sup>.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
Access the webui at `<your-ip>:8686`, for more information check out [Lidarr](https://github.com/lidarr/Lidarr).

## Info

Monitor the logs of the container in realtime `docker logs -f lidarr`.
