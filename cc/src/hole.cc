#include "lib.cc"
#include <cstdio>
#include <fcntl.h>
#include <unistd.h>

int main(void) {
  int fd;
  if ((fd = creat("file.hole", 0644)) == -1) {
    handle_error("creat error");
  }
  if (write(fd, "helloworld", 10) != 10) {
    handle_error("write error");
  }
  if (lseek(fd, 32, SEEK_SET) == -1) {
    handle_error("lseek error");
  }
  if (write(fd, "HelloWorld", 10) != 10) {
    handle_error("write error");
  }

  exit(0);
}
