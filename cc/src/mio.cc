// 前提1:正常关闭client
// 结果1:epollin,read=0
// 前提2:服务端还在写时关闭client
// 结果2:epollin,epollhup,write=-1 errno=EPIPE;此时需要检测epollhup摘除对应fd

#include <errno.h>
#include <signal.h>
#include <sys/epoll.h>
#include <unistd.h>

#include "lib.c"

using namespace std;

void doUseFdEt(int cfd);
void doUseFd(int fd);
void pEventBit(uint32_t events);

int efd = -1;
int main(void)
{
  struct sockaddr_in addr;
  socklen_t addrlen;
  int n = -1, cfd = -1;
  struct epoll_event ev, events[3];
  struct sigaction action;
  action.sa_handler = doNothing;
  // action.sa_flags =SA_INTERRUPT;
  // 默认重启被打断的慢速read调用,但可手动设置=SA_INTERRUPT从而不重启
  sigaction(SIGUSR1, &action, NULL);
  sigaction(SIGPIPE, &action, NULL);

  int lfd = Listen("0.0.0.0", 9990);
  efd = epoll_create(1);
  if (efd == -1) {
    handle_error("epoll_create");
  }
  ev.events = EPOLLIN;
  ev.data.fd = lfd;
  if (-1 == epoll_ctl(efd, EPOLL_CTL_ADD, lfd, &ev)) {
    handle_error("epoll_ctl");
  }
  for (;;) {
    n = epoll_wait(efd, events, 3, -1);
    if (n == -1) {
      handle_error("epoll_wait");
    }
    for (int i = 0; i < n; ++i) {
      pEventBit(events[i].events);
      if (events[i].data.fd == lfd) {
        cfd = accept(lfd, (struct sockaddr*)&addr, &addrlen);
        if (cfd == -1) {
          handle_error("accept");
        }
        printf("accept cfd:%d\n", cfd);
        set_fl(cfd, O_NONBLOCK); // match doUseFdEt
        ev.events = EPOLLIN | EPOLLET; // match doUseFdEt
        // ev.events = EPOLLIN;
        //  ev.events=EPOLLIN|EPOLLONESHOT;//only once,need register again
        ev.data.fd = cfd;
        if (-1 == epoll_ctl(efd, EPOLL_CTL_ADD, cfd, &ev)) {
          handle_error("epoll_ctl after accept");
        }
      } else {
        printf("events[%d].data.fd:%d\n", i, events[i].data.fd);
        // doUseFd(events[i].data.fd);
        doUseFdEt(events[i].data.fd);
      }
    }
  }
  return 0;
}

void doUseFdEt(int cfd)
{
  char buf[8] = {
    0,
  };
  int n = -1;
  for (;;) {
    n = read(cfd, buf, sizeof(buf));
    if (n == -1) {
      if (errno == EAGAIN || errno == EWOULDBLOCK) { // no data to read, read reback immediately
        // printf("read again\n");
        break;
      } else {
        handle_error("read");
      }
    } else if (n == 0) {
      printf("read zero\n");
      epoll_ctl(efd, EPOLL_CTL_DEL, cfd, NULL);
      close(cfd);
      return;
    }

    usleep(1000000); // us
    n = write(cfd, buf, n);
    printf("write :%d\n", n);
    if (n == -1) { // do after ignore SIGPIPE
      if (errno == EAGAIN || errno == EWOULDBLOCK) {
        printf("write EAGAIN\n");
        continue;
      } else if (errno == EPIPE) {
        return;
      } else {
        handle_error("write");
      }
    } else if (n == 0) {
      printf("write zero\n");
      epoll_ctl(efd, EPOLL_CTL_DEL, cfd, NULL);
      close(cfd);
      return;
    }
  }
  return;
}

void doUseFd(int cfd)
{
  char buf[8] = {
    0,
  };
  int n = -1;
ReadAgain:
  n = read(cfd, buf, sizeof(buf));
  if (n == -1) {
    if (errno == EAGAIN || errno == EWOULDBLOCK) { // no data to read, read reback immediately
      // printf("read again\n");
      // goto ReadAgain;
      return;
    } else if (errno == EINTR) { // block mode only
      printf("read EINTR\n");
      goto ReadAgain;
    } else {
      handle_error("read");
    }
  } else if (n == 0) {
    printf("read zero\n");
    epoll_ctl(efd, EPOLL_CTL_DEL, cfd, NULL);
    close(cfd);
    return;
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
      // epoll_ctl(efd, EPOLL_CTL_DEL, cfd, NULL);
      // close(cfd);//此处关闭,下次epoll_wait会出现epollerr
      return;
    } else {
      handle_error("write");
    }
  } else if (n == 0) {
    printf("write zero\n");
    epoll_ctl(efd, EPOLL_CTL_DEL, cfd, NULL);
    close(cfd);
    return;
  }
  return;
}

void pEventBit(uint32_t events)
{
  printf("events:%#x\n", events);
  if (events & EPOLLIN) {
    printf("EPOLLIN\n");
  }
  if (events & EPOLLPRI) {
    printf("EPOLLPRI\n");
  }
  if (events & EPOLLOUT) {
    printf("EPOLLOUT\n");
  }
  if (events & EPOLLERR) {
    printf("EPOLLERR\n");
  }
  if (events & EPOLLHUP) {
    printf("EPOLLHUP\n");
  }
  if (events & EPOLLRDNORM) {
    printf("EPOLLRDNORM\n");
  }
  if (events & EPOLLRDBAND) {
    printf("EPOLLRDBAND\n");
  }
  if (events & EPOLLWRNORM) {
    printf("EPOLLWRNORM\n");
  }
  if (events & EPOLLWRBAND) {
    printf("EPOLLWRBAND\n");
  }
  if (events & EPOLLMSG) {
    printf("EPOLLMSG\n");
  }
  if (events & EPOLLRDHUP) {
    printf("EPOLLRDHUP\n");
  }
  if (events & EPOLLEXCLUSIVE) {
    printf("EPOLLEXCLUSIVE\n");
  }
  if (events & EPOLLWAKEUP) {
    printf("EPOLLWAKEUP\n");
  }
  if (events & EPOLLONESHOT) {
    printf("EPOLLONESHOT\n");
  }
  if (events & EPOLLET) {
    printf("EPOLLET\n");
  }
  return;
}