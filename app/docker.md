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
# 查看容器latest对应的版本
docker image inspect mysql:latest | grep -i version
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
docker compose -f docker-compose-kafka-redis.yml up -d  
yaml:用缩进对齐来展示层级,#表示注释,
```yaml
version: "3"

services:
    redis:
        image:  redis:6.2.7
        container_name: redis
        restart: always
        volumes:
            - "C:/workdir/other/redis/data:/data"
        ports:
            - '7000:7000'
            - '17000:17000'
            - '6379:6379'
        environment:
            REDIS_PORT: '7000'
        command: redis-server --appendonly yes
        networks:
            kafka-net:
                ipv4_address: "172.20.0.20"
        logging:
            driver: "json-file"
            options:
                max-size: "200k"
                max-file: "10"
                
    mysql:
        image:  mysql
        container_name: mysql
        restart: always
        volumes:
            - "C:/workdir/other/mysql:/data"
        ports:
            - '3306:3306'
        environment:
            MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
        networks:
            kafka-net:
                ipv4_address: "172.20.0.21"
        logging:
            driver: "json-file"
            options:
                max-size: "200k"
                max-file: "10"
         
networks:
    kafka-net:
        name: kafka-net
        driver: bridge
        ipam:
            driver: default
            config:
                - subnet: "172.20.0.0/24"

```

