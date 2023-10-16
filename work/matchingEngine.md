### 重新编译argo代码库
```bash
# Ubuntu22.04 0815版本(0915编译不过)
cp -r ~/ninja/Argo_modified_libs/quickfix-1.14.0 .
cp -r ~/ninja/Servers/ATP_third_party_libs_source/quickfix-1.14.0/ .
./build.sh
```

### 调试ME
将启动脚本start_matching_engine.sh中的#gdb行取消注释即可调试;或者如下走gdb attach pid
```bash
b NotificationApiManager.cpp:on_admin_notification
set scheduler-locking on
b NotificationApiManager.cpp:578
# QuickFast代码也有变更,但没报错,暂用旧版本
```

### 源码分析
