// read when no data
// block return -1 and set errno=EINTR or immediately return -1 and set errno=EAGAIN
// write when no stream sapce
// block return -1 and set errno=EINTR or immediately return -1 and set errno=EAGAIN
// write when client closed
// return -1 and set EPIPE(need catch SIGPIPE and do nothing)

#include <errno.h>
#include <signal.h>
#include <unistd.h>

#include "lib.cc"

using namespace std;

int main(void)
{
  int cfd = -1;
  struct sockaddr_in caddr;
  socklen_t clen = 0;
  int n = -1;
  char buf[8] = {
    0,
  };

  // signal(SIGPIPE,doNothing);//默认重启被打断的慢速read调用,就是恢复read的阻塞等待
  struct sigaction action;
  action.sa_handler = doNothing;
  action.sa_flags = SA_INTERRUPT; // 切记要=,不要|=
  // kill -10 pid or kill -SIGUSR1 pid
  sigaction(SIGUSR1, &action, NULL); // 默认重启被打断的慢速read调用,但可手动设置=SA_INTERRUPT从而不重启
  sigaction(SIGUSR2, &action, NULL);
  // kill -13 pid
  sigaction(SIGPIPE, &action, NULL);
  int lfd = Listen("0.0.0.0", 9990);

  for (;;) // while (1)
  {
    cfd = accept(lfd, (struct sockaddr*)&caddr, &clen);
    if (cfd == -1) {
      handle_error("accept");
    }
    // set_fl(cfd,O_NONBLOCK);
    for (;;) // while (1)
    {
    ReadAgain:
      n = read(cfd, buf, sizeof(buf));
      if (n == -1) {
        if (errno == EAGAIN || errno == EWOULDBLOCK) { // no data to read, read reback immediately
          // printf("read again\n");
          goto ReadAgain;
        } else if (errno == EINTR) { // block mode only
          printf("read EINTR\n");
          goto ReadAgain;
        } else {
          handle_error("read");
        }
      } else if (n == 0) {
        printf("read zero\n");
        close(cfd);
        break;
      }
      usleep(1000000); // us
    WriteAgain:
      n = write(cfd, buf, n);
      printf("write :%d\n", n);
      if (n == -1) { // do after ignore SIGPIPE
        if (errno == EAGAIN || errno == EWOULDBLOCK) { // errno==EINTR,not happen when nonblock
          goto WriteAgain;
        } else if (errno == EINTR) { // block mode only
          printf("write EINTR\n");
          goto WriteAgain;
        } else if (errno == EPIPE) {
          close(cfd);
          break;
        } else {
          handle_error("write");
        }
      } else if (n == 0) {
        printf("write zero\n");
        close(cfd);
        break;
      }
    }
  }
  return 0;
}