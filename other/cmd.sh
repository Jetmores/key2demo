!docker exec -it rust_ /bin/sh
!docker exec -it postgres_ /bin/bash
!docker exec -it mysql_ /bin/bash
!docker exec -it ubuntu_ /bin/bash
#then su postgres;psql
!docker exec -it nginx_ /bin/sh
!docker exec -it redis_ /bin/sh
!docker exec -it alpine_ sh --login

!docker run -it --name alpine_ -v /mnt/d/work/alpine/:/root alpine:latest /bin/sh
!docker run --privileged --name nginx_ -p 5080:80 -d nginx:alpine
!docker run --privileged --name nginx_ -p 5080:80 -v /mnt/d/work/nginx/nginx:/usr/share/nginx -v /mnt/d/work/nginx/etc_nginx/nginx.conf:/etc/nginx/nginx.conf -d nginx:alpine 
!docker run --name redis_ -p 6379:6379 -v /mnt/d/work/redis/redis/redis.conf:/etc/redis/redis.conf -v /mnt/d/work/redis/redis/data:/data -d redis:alpine redis-server /etc/redis/redis.conf --appendonly yes
!docker volume create pgdata
!docker volume inspect pgdata
!docker run -d --privileged --name postgres_ -p 5432:5432 -v pgdata:/var/lib/postgresql/data -e "POSTGRES_PASSWORD=catgo" postgres:alpine
!docker run -it --name rust_ -v /mnt/d/work/rust/:/root rust:alpine /bin/sh
!docker run -it --name ubuntu_ -v /mnt/d/work/ubt/:/root ubuntu:latest /bin/bash
!docker run --name mysql_ -e MYSQL_ROOT_PASSWORD=catgo -d mysql:latest
