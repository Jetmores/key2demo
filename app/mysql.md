### 容器构建
```bash
!docker run --name mysql_ -e MYSQL_ROOT_PASSWORD=catgo -d mysql:latest
```

### base usage
```bash
# 密码如上,MYSQL_ROOT_PASSWORD=catgo
mysql -h 127.0.0.1 -P 3306 -u root -D mysql -p
mysql -p
```