### libev本地调试操作<https://gitlab.com/lets2rs/libev>
1. 依赖command:autoconf,automake,libtool,make,gcc/clang
2. sh autogen.sh
3. ./configure
4. make && make install
5. 删除ev.c和ev.h不依赖的文件
6. 添加自己的main函数,进行编译调试

### 通用接口
1. [epoll|poll|select]_init
2. [epoll|poll|select]_destory
3. [epoll|poll|select]_modify
4. [epoll|poll|select]_poll

### 事件注册
1. ev_[io|timer|signal]_init
2. ev_[io|timer|signal]_start

### 启动事件循环ev_run
