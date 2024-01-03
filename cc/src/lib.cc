//os
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>

//lib
#include <pthread.h>

//std
#include <cstdio>
#include <cstdlib>

#define handle_error(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)


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