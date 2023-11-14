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
set role kt;//切换角色
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
# /var/lib/postgresql/data/pg_hba.conf (local for Unix domain socket,即本机. 改完后即可密码进入,否则直接进入)
local   all             all                                     md5
# 改完配置,重启生效
pg_ctl reload
# 修改密码,需要进入该用户,或从postgres中set role kt切换角色(不用重启)
\password
```

### 建库建表
```bash
create database mdb [owner kt][TEMPLATE template0];
drop database mdb;
createdb [-T template0] mydb2 [-O postgres]
dropdb dbname
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
su postgres
pg_dump mydb > mydb.sql
# 恢复之前保证先有数据库名,也可仅删除数据库中的表再同样命令恢复(仅表)
# create database mydb2;//createdb [-T template0] mydb2 [-O postgres]
psql -f mydb.sql mydb2

pg_dump -Fc mydb > mydb.dump
pg_restore -d mydb3 mydb.dump

pg_dump -Fd mydb -f mydb_dir
pg_restore -d mydb4 mydb_dir

# 针对单个表的备份和恢复
pg_dump -t mytest2 mydb > mydb_2.sql
psql mydb -f mydb_2.sql

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
create role myrole
drop role myrole
createuser myrole
dropuser myrole
# 拥有登录权限的角色即用户,否则role "kt" is not permitted to log in
ALTER ROLE kt LOGIN;# 给role新增login权限
CREATE ROLE name LOGIN;
CREATE USER name;

select * from mytest2;
//ERROR:  permission denied for table mytest2
grant all privileges on mytest2 to public;//授权xx到所有
grant all privileges on mytest to kt;//授权xx到kt
revoke all privileges on mytest from kt;//撤回

create user kt with password 'catgo';
drop user kt;
# 以下命令均未起作用或意义不明白,未完待续
grant all privileges on database mdb to kt;//表无权访问,无法新建表和访问,仅连接等
revoke all privileges on database mdb from kt;
grant all privileges on all tables in schema public to kt;
revoke all privileges on all tables in schema public from kt;
```