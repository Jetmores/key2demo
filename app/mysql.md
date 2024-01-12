### 容器构建
```bash
!docker run --name mysql_ -e MYSQL_ROOT_PASSWORD=catgo -d mysql:latest
```

### 连接
```bash
# 密码如上,MYSQL_ROOT_PASSWORD=catgo
mysql [-h 127.0.0.1 -P 3306 -u root -D mysql] -p
```

配置
```bash
xxx
```

### 建库建表
```bash
create database mdb ;
drop database mdb;
# 整型(smallint-2,int[eger]-4,bigint-8,[small|big]serial自增类型2-4-8字节) 
#浮点(real-4,double precision-8,decimal/numeric等效的大精度数) 
#布尔(boolean:TRUE,FALSE,NULL);字符(char(n),varchar(n),text,BINARY[(n)],VARBINARY(n),BLOB[(n)]) 日期时间(date,time,timestamp)
create table test(id serial primary key, body varchar(100));
drop table test;
```

### 增删改查
```bash
insert into test(body) values('tom'),('jack');
delete from test where id=2;
update test set body='jm' where id=2;
select * from test;

# 插入或删除记录时出现外键约束错误
set foreign_key_checks=0;
```

### 备份恢复
```bash
# Usage:
mysqldump [OPTIONS] database [tables]
mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
mysqldump [OPTIONS] --all-databases [OPTIONS]

# 备份表
mysqldump -u root -p mdb test2 > /root/mdb_test2.sql
source mdb_test2.sql
mysql -u root -p mdb < mdb_test2.sql
# 备份库(单个,多个或所有)
mysqldump -u root -p [--databases|-B|--all_databases|-A] mdb > /root/mdb.sql
create database mdb;use mdb;source mdb.sql
create database mdb;mysql -u root -p mdb < mdb.sql
```

### 用户授权
```bash
# 用旧密码换新密码:root/localhost
mysqladmin -u root -p flush-privileges password ["catgo"]
# 先查询用户和host,再修改,最后刷新
mysql -u root -p -e "select user,host from mysql.user;"
mysql -u root -p -e "alter user 'root'@'localhost' identified by 'catgo';"
mysqladmin -u root -p flush-privileges #不刷新,实测也更改成功

create user kt identified by 'catgo';
drop user 'kt'@'localhost';
show grants for kt;
grant all on *.* to kt;
revoke all on *.* from kt;

# mysqldump权限(process)
mysql -u root -p -e "show grants for kt;"
mysql -u root -p -e "grant process on *.* to kt;"
mysql -u root -p -e "revoke process on *.* from kt;"
```
