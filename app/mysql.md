### 容器构建
```bash
!docker run --name mysql_ -e MYSQL_ROOT_PASSWORD=catgo -d mysql:latest
```

### base usage
```bash
# 密码如上,MYSQL_ROOT_PASSWORD=catgo
mysql [-h 127.0.0.1 -P 3306 -u root -D mysql] -p
```

setting
```bash
xxx
```

### 建库建表
```bash
create database mdb ;
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
xxx
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
```
