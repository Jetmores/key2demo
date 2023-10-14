### start command
删除pgdata外挂盘,删除现有容器,完全重新执行如下指令方可正常
```bash
!docker volume create pgdata
!docker volume inspect pgdata
!docker run -d --privileged --name postgres_ -p 5432:5432 -v pgdata:/var/lib/postgresql/data -e "POSTGRES_PASSWORD=catgo" postgres:alpine
!docker exec -it postgres_ /bin/bash
```

### base usage
```bash
psql -U postgres # \l list db
```
