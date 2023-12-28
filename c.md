### ?遍历 ?目录 ?workdir
```c
#include "apue.h"
#include <dirent.h>

int main(int argc, char *argv[]){
    DIR *dp;
    struct dirent *dirp;

    if (argc != 2){
        err_quit("usage : ls directory_name");
    }

    if ((dp = opendir(argv[1])) == NULL){
        err_sys("Can't open %s", argv[1]);
    }

    while ((dirp = readdir(dp)) != NULL){
        printf("%s\n", dirp->d_name);
    }

    closedir(dp);
    exit(0);
}
```

### 多线程 ?epoll
1. 每个线程都处理自己的fd,从而完全避免多线程安全问题;
2. 使用EPOLLONESHOT标志,即在一次wait返回后禁止fd再产生事件,并在处理完成后使用epoll_ctl的MOD操作重新开启.
