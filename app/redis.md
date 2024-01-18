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
```bash
DEL key [key ...]
EXISTS key [key ...]
EXPIRE key seconds [NX|XX|GT|LT]
TTL key
```

#### type
string list map(hash) set sorted-set
#### string:int,float,string
```bash
SET key value [NX]/[EX seconds]
MSET key value [key value ...]
GET key
MGET key [key ...]
INCR key # ++1
INCRBY key increment # incrby xx 2 # incrby xx -1
INCRBYFLOAT key increment # incrbyfloat xx 0.5
```

#### hash(map)
```bash
HSET key field value [field value ...] #hmset同,但被deprecated;且hash的超时仅可hset后expire key 10
HSETNX key field value
HDEL key field [field ...]
HGET key field
HMGET key field [field ...]
HGETALL key
HINCRBY key field increment
```

#### list
1. stack:入口与出口一致lpush-lpop或rpush-rpop
2. queue:入口出口不在一边lpush-rpop
3. 阻塞队列:同2,但pop要用block版本如lpush-brpop
```bash
L/RPUSH key element [element ...]
L/RPOP key [count]
BL/RPOP key [key ...] timeout # block and pop until timeout
LRANGE key start stop
```

#### set(类似hashmap,但无key-value的value)
```bash
SADD key member [member ...]
SREM key member [member ...]
SISMEMBER key member
SMEMBERS key
SCARD key
SINTER key [key ...] #A^B
SUNION key [key ...] #AvB
SDIFF key [key ...] #A-B
```

#### sorted-set(不是红黑树,是skiplist跳表+hash表)
```bash
ZADD key [NX|XX] [GT|LT] [CH] [INCR] score member [score member ...]
ZREM key member [member ...]
ZSCORE key member
ZINCRBY key increment member
ZRANK key member
ZCARD key
ZCOUNT key min max
ZRANGE key start stop [BYSCORE|BYLEX] [REV] [LIMIT offset count] [WITHSCORES]
ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
ZINTER numkeys key [key ...] [WEIGHTS weight [weight ...]] [AGGREGATE SUM|MIN|MAX] [WITHSCORES]
ZUNION numkeys key [key ...] [WEIGHTS weight [weight ...]] [AGGREGATE SUM|MIN|MAX] [WITHSCORES]
ZDIFF numkeys key [key ...] [WITHSCORES]
```

### redis与mysql如何保障数据一致性
1. 实时一致性方案:先写mysql,再删redis
2. 最终一致性方案:先写mysql,通过binlog,异步更新redis
