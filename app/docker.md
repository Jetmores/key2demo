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

docker run -it --name ubt -p 25:22 -v C:\workdir\ubt:/root ubuntu:22.04 /bin/bash
docker exec -it --detach-keys="ctrl-q,q" ubt /bin/bash
docker start ubt
docker stop ubt
```

### Dockerfile
1. FROM
2. WORKDIR
3. COPY/ADD
4. RUN
5. CMD/ENTRYPOINT
6. ARG
7. ENV
8. EXPOSE
9. VOLUME
10. USER
11. SHELL bin/bash
