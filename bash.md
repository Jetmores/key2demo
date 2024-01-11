### gdb tips
gdb [OPTIONS] [program [procID or progfile core]]
gdb -p pid
```bash
info threads
thread id
#只有当前被调试线程会执行|默认全部执行|当next or step时同on,continue-until-finish等大跳转则全部运行,此时遇到断点(包括另一线程处的断点)则切换为当前线程
set scheduler-locking on|off|step
#默认,fork之后父子独立://默认追踪父进程//追踪子进程
detach-on-fork on;follow-fork-mode parent
detach-on-fork on;follow-fork-mode child
#fork之后block在该位置://默认追踪父进程,子进程block在fork位置//追踪子进程,父进程block在fork位置
detach-on-fork off;follow-fork-mode parent
detach-on-fork off;follow-fork-mode child

#汇编
disas[semble]
```

### valgrind内存泄漏分析
```bash
valgrind ./app
```

### perf性能热点分析
```bash
perf stat -p pid
```

### sed
```bash
# 执行文件的第5行命令
sed -n '5p' cmd |bash
# 批量查找替换文件内容
sed -i 's/LD_LIBRARY_PATH=./LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH/g' *.sh
```

### gcc/g++
<https://www.runoob.com/w3cnote/gcc-parameter-detail.html>
```bash
# 同时链接动态库(默认)和静态库
g++ -Wl,-Bstatic -L. -lx -Wl,-Bdynamic -L. -ly
# 生成intel汇编语法
cc -S -masm=intel add.c
```
* 编译时链接库需要分为两类:
    1. 直接引用:被源码中直接调用的库
    2. 间接引用:被调用库的依赖库
* -lxxx: 指定具体的库名称,编译时需要显式指定直接引用的库名称
* -L: 指定链接库的位置,编译时需要显式指定直接引用的库位置
* -Wl,-rpath-link: 用于编译时指定间接引用的库位置  
如果知道所有间接引用的库文件名称,并且不嫌麻烦,也可以用-lxxx显式指定每一个库(不推荐-lxxx)
* -Wl,-rpath: 有两个作用
    1. 用于编译时指定间接引用的库位置,作用同-Wl,-rpath-link
    2. 用于运行时指定所有引用库的位置,作用同修改环境变量(LD_LIBRARY_PATH),并且库路径引用优先级高于LD_LIBRARY_PATH
* 使用建议
    1. 编译命令中使用-Wl,-rpath-link 指定间接引用库位置(编译时),使用-Wl,-rpath 指定引用库位置(运行时)
    2. -Wl,-rpath-link 在 -Wl,-rpath 前


### 快捷拷贝程序依赖的动态库
```bash
ldd app |awk '{print $3}' |xargs -i cp -L {} mdir/
```

### ssh
```bash
# 生成.ssh/id_rsa.pub
ssh-keygen -t rsa -C "lets2rs@126.com"
# ssh代理连接
ssh -v -i id_rsa -oProxyCommand="ssh -i id_rsa yh@35.75.184.13 -p 10022 -N -W %h:%p" yh@10.64.4.45
# ssh免(输入)密码连接
sshpass -p BoyuUbuntu ssh boyu@192.168.0.20
```

### 远程拷贝
```bash
scp dlib.tar.xz cat@119.27.182.173:/home/cat/tp
rsync --partial -z -e 'ssh -v -i id_rsa -oProxyCommand="ssh -i id_rsa yh@35.75.184.13 -p 10022 -N -W %h:%p"' mCtrl.tar.xz yh@10.64.4.45:~
```

### 测试udp连通性:端口占用-存在即使成功也不起作用的情况
```bash
nc -vuz 172.18.0.12 36802
```

### 测试udp连通性:端口占用
```bash
server:nc -lu 36802
client:nc -u 127.0.0.1 36802
```

### 查看程序占用的ip和端口号
```bash
netstat -[a|4]pn
```

### tcpdump:抓取100源地址和36802的目的端口,tcp/udp用来修饰端口的
```bash
tcpdump -i ens5 -An src host 10.64.2.100 and udp dst port 36802
```

### curl
```bash
# 模拟HTTP请求
curl 127.0.0.1:9909
# 下载文件类似wget,加k不进行ssl校验
curl -LOk https://ziglang.org/download/0.11.0/zig-0.11.0.tar.xz
```

### ps查看进程
```bash
ps -ef
# 查看某进程的线程
ps -T -p pid
top -H -p pid
```

### git
```bash
# name,email,then need id_rsa for clone in git@
git config --global -e
git config --global user.name "[name]"
git config --global user.email "[email address]"
git config --global core.editor vi
git config --global http.sslverify false
# 暂存与恢复
git stash
git stash pop
# 丢弃工作区的修改或删除,不含新增或未追踪
git checkout .
# 删除所有未追踪的文件或目录,保险起见先查即将删除项:git clean -nxdf
git clean -df
git clean -xdf
# 加入暂存(当前目录不含.xx|当前目录|版本库所有目录)
git add [*|.|-A]
```

### 查看log文件
```bash
tail -f x.log #退出ctrl+c
less +F x.log #退出ctrl+c;q
```

### kill
```bash
kill -9 pid
pkill -f marketCtrl
```
