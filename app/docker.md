### setting
daemon.json
```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "50GB",
      "enabled": true
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

### 查看docker容器挂载目录信息:
```bash
docker inspect -f "{{.Mounts}}" argo_mysql
```

### docker command
```bash
docker pull ubuntu:22.04
docker commit ubt ubt:yh001
docker save -o ubt_yh001.tar ubt:yh001
docker load -i argo_yh001.tar
docker tag ubuntu:latest ubuntu:22.04
docker rm container
docker rmi image
docker ps
docker images

docker run -it --name ubt -p 25:22 -v C:\workdir\ubt:/root ubuntu:22.04 /bin/bash
docker exec -it --detach-keys="ctrl-q,q" ubt /bin/bash
docker start ubt
docker stop ubt
```

### Dockerfile:[参考文档](https://docs.docker.com/engine/reference/builder/)
docker build -t mclient:1.10 .
1. FROM ubuntu:22.04
2. WORKDIR $HOME
3. COPY/ADD #ADD zig-linux-x86_64-0.11.0.tar.xz /root/ #COPY neovim-config/ /root/
4. RUN yes|unminimize && && apt-get install -y --no-install-recommends man-db
5. CMD/ENTRYPOINT #ENTRYPOINT ["/bin/bash","-c"]
6. ARG CODE_VERSION=latest #FROM base:${CODE_VERSION} #仅在构建期间的变量
7. ENV key=value ...
8. EXPOSE 80/tcp 443/tcp #需要配合run中参数--net=host,更好的方法是docker run -p 80:80/tcp -p 80:80/udp ...
9. VOLUME ["/data","/bin"] #貌似更好docker run -v
10. USER user[:group]
11. SHELL ["/bin/sh", "-c"]

### docker compose

