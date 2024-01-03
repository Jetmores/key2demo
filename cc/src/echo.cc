#include <unistd.h>
#include <signal.h>

#include "lib.cc"

using namespace std;

int main(void){
    //printf("Hello World\n");
    int cfd=-1;
    struct sockaddr_in caddr;
    socklen_t clen=0;
    int n=-1;
    char buf[8]={0,};

    signal(SIGPIPE,doNothing);
    int lfd=Listen("0.0.0.0",9990);

    while (1)
    {
        cfd = accept(lfd, (struct sockaddr *)&caddr, &clen);
        if (cfd == -1){
            handle_error("accept");
        }
        while (1){
            n = read(cfd, buf, sizeof(buf));
            if(n==-1){
                handle_error("read");
            }else if(n==0){
                printf("read zero\n");
                close(cfd);
                break;
            }
            usleep(1000000);
            n=write(cfd,buf,n);
            printf("write :%d\n",n);
            if(n==-1){//do after ignore SIGPIPE
                handle_error("write");
            }else if(n==0){
                printf("write zero\n");
                close(cfd);
                break;
            }
        }
    }
    return 0;
}