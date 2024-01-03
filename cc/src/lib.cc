//os
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <fcntl.h>

//lib
#include <pthread.h>

//std
#include <cstdio>
#include <cstdlib>

#define handle_error(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)


void doNothing(int signo){
    return;
}


int Listen(const char* ip,short port) {
    int fd=-1;
    int opt=1;
    struct sockaddr_in addr;

    fd=socket(AF_INET,SOCK_STREAM,0);
    if(fd==-1){
        handle_error("socket");
    }
    setsockopt(fd,SOL_SOCKET,SO_REUSEADDR,&opt,sizeof(opt));
    addr.sin_family=AF_INET;
    addr.sin_port=htons(port);
    inet_pton(AF_INET,ip,&addr.sin_addr.s_addr);
    if(-1==bind(fd,(struct sockaddr*)&addr,sizeof(addr))){
        handle_error("bind");
    }
    if (listen(fd, 128) == -1){
        handle_error("listen");
    }
    return fd;
}


void set_fl(int fd, int flags){
    int val;

    if ((val = fcntl(fd, F_GETFL, 0)) < 0){
        handle_error("fcntl F_GETFL error");
    }

    val |= flags;

    if (fcntl(fd, F_SETFL, val) < 0){
        handle_error("fcntl F_SETFL error");
    }
}
