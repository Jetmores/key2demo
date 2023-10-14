### redis setting
!docker run --name redis_ -p 6379:6379 -v /mnt/d/work/redis/redis/redis.conf:/etc/redis/redis.conf -v /mnt/d/work/re    dis/redis/data:/data -d redis:latest redis-server /etc/redis/redis.conf --appendonly yes

!docker exec -it redis_ /bin/bash

1. /etc/redis/redis.conf
```bash
#bind 127.0.0.1 -::1
#protected-mode yes
daemonize no
requirepass 123456
appendonly yes
```
2. connect to
```bash
redis-cli
auth [default] 123456
```

3. list all and cleanup all
```bash
keys *
flushall
```

### redis usage