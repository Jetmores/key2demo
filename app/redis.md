### redis setting
!docker run --name redis_ -p 6379:6379 -v /mnt/d/work/redis/redis/redis.conf:/etc/redis/redis.conf -v /mnt/d/work/re    dis/redis/data:/data -d redis:latest redis-server /etc/redis/redis.conf --appendonly yes

!docker exec -it redis_ /bin/bash

1. /etc/redis/redis.conf
```bash
bind 0.0.0.0
protected-mode yes
daemonize yes
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
1. DEL key [key ...]
2. EXISTS key [key ...]
3. EXPIRE key seconds [NX|XX|GT|LT]
4. TTL key
#### type
string list map(hash) set sorted-set
#### string:int,float,string
1.set/mset/get/mget
SET key value [NX]/[EX seconds]

MSET key value [key value ...]

GET key

MGET key [key ...]

INCR key # ++1

INCRBY key increment # incrby xx 2 # incrby xx -1

INCRBYFLOAT key increment # incrbyfloat xx 0.5
