//os
#include <sys/socket.h>

//lib
#include <pthread.h>

//std
#include <cstdio>
#include <cstdlib>


void perrorExit(const char* str){
    perror(str);
    pthread_exit(NULL);
    exit(1);
}

int Listen(const char* ip,short post) {
    int fd=-1;

    fd=socket(AF_INET,SOCK_STREAM,0);
    if(fd==-1){
        perrorExit("socker error");
    }
    return 0;
}