### redis setting
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