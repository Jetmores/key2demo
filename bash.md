### gdb tips
```bash
info threads
thread id
#只有当前被调试线程会执行|默认全部执行
set scheduler-locking on|off
#默认,fork之后父子独立
detach-on-fork on;follow-fork-mode parent//默认追踪父进程
detach-on-fork on;follow-fork-mode child//最终子进程
#fork之后block在该位置
detach-on-fork off;follow-fork-mode parent//默认追踪父进程,子进程block在fork位置
detach-on-fork off;follow-fork-mode child//追踪子进程,父进程block在fork位置
```