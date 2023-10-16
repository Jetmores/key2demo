### start command
完全重建容器,需要删除pgdata外挂盘,删除现有容器,完全重新执行如下指令方可正常
```bash
!docker volume create pgdata
!docker volume inspect pgdata
!docker run -d --privileged --name postgres_ -p 5432:5432 -v pgdata:/var/lib/postgresql/data -e "POSTGRES_PASSWORD=catgo" postgres:alpine
!docker exec -it postgres_ /bin/bash
```

### base usage
```bash
psql [-h 127.0.0.1] [-p 5432] -U postgres [-d postgres]
\l #list db
\c #connect db
\d #list tables
\d mtable #describe table
\du #list user
```

### setting
```bash
# /var/lib/postgresql/data/postgresql.conf (容器默认已配置)
listen_addresses = '*'
# /var/lib/postgresql/data/pg_hba.conf (更改密码方式,暂不动)
host all all 0.0.0.0/0 md5
```

### 建库建表
```bash
create database mdb [owner kt];
drop database mdb;
# 整型(smallint-2,int[eger]-4,bigint-8,[small|big]serial自增类型2-4-8字节) 
#浮点(real-4,double precision-8,decimal/numeric等效的大精度数) 
#字符(char(n),varchar(n),text) 日期时间(date,time,timestamp)
create table test(id serial primary key, body varchar(100));
drop table test;
```

### 增删改查
```bash
insert into test(body) values('tom'),('jack');
delete from test where id=2;
update test set body='jm' where id=2;
select * from test;
```

### 备份恢复
```bash
# 不知为何,尝试多次,均恢复失败
pg_dump -U kt -f mdb.bak mdb
psql -U kt -f mdb.bak mdb
pg_dump -U kt -f mdb.sql mdb
pg_dump -U kt -f mdb.sql -t test mdb #恢复mdb的test表
psql -U kt -f mdb.sql mdb
pg_dumpall >pg_backup.bak
pg_dump -U kt -F t -f mdb.tar mdb
pg_restore -U kt -d mdb ./mdb.tar
```

### 用户授权
```bash
# user 和 role 仅多了login,role不可login,需要另外alter
create user kt password 'catgo'; #password 没起作用,可能和配置pg_hba.conf中trust有关
drop user kt;
grant all privileges on database mdb to kt;
revoke all privileges on database mdb from kt;
grant all privileges on all tables in schema public to kt;
revoke all privileges on all tables in schema public from kt;
```