### gdb tips
gdb [OPTIONS] [prog|prog procID|progfile core]
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
disassemble
```

### 执行文件的第5行命令
```bash
sed -n '5p' cmd |bash
```

### gcc/g++动态库(默认)同时和静态库加载声明
```bash
g++ -Wl,-Bstatic -L. -lx -Wl,-Bdynamic -L. -ly
```

### 快捷拷贝程序依赖的动态库
```bash
ldd app |awk '{print $3}' |xargs -i cp -L {} mdir/
```

### 远程拷贝
```bash
scp dlib.tar.xz cat@119.27.182.173:/home/cat/tp
rsync --partial -z -e 'ssh -v -i id_rsa -oProxyCommand="ssh -i id_rsa yh@35.75.184.13 -p 10022 -N -W %h:%p"' mCtrl.tar.xz yh@10.64.4.45:~
```

### cat .ssh/id_rsa.pub
```bash
ssh-keygen -t rsa -C "lets2rs@126.com"
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

### tcpdump:抓取100源地址和36802的目的端口,tcp/udp用来修饰端口的
```bash
tcpdump -i ens5 -An src host 10.64.2.100 and udp dst port 36802
```

### 提交代码时的用户信息
```bash
git config --global user.name "[name]"
git config --global user.email "[email address]"
git config --global -e //sometime not correct
```

### 丢弃工作区的修改或删除,不含新增或未追踪
```bash
git checkout .
```

### 删除所有未追踪的文件或目录,保险起见先查即将删除项:git clean -nxdf
```bash
git clean -df
git clean -xdf
```

### 生成intel汇编语法
```bash
cc -S -masm=intel add.c
```

### zig指定链接的libc库
```bash
zig build-exe hi.zig --library c -target x86_64-linux-musl
zig build-exe hi.zig -lc -target x86_64-linux-musl
zig build -Dtarget=x86_64-windows
zig build -Dtarget=x86_64-linux-gnu
```
### 模拟HTTP请求
```bash
curl 127.0.0.1:9909
```

