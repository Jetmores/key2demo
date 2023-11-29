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

### other
```bash
docker tag ubuntu:latest ubuntu:22.04
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
10. SHELL bin/bash
