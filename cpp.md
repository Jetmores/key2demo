### ?bind
```cpp
// （ _1 与 _2 来自 std::placeholders ，并表示将来会传递给 f1 的参数）
auto f1 = std::bind(f, _2, 42, _1, std::cref(n), n);
```

### ?lambda ?λ
```cpp
int& (*fpi)(int*) = [](int* a) -> int& { return *a; };
```

### ?继承 ?构造函数
```cpp
using Base::Base;
```

### 浏览器中设定cpp帮助文档 ?manpage
1. Chrome-设置-搜索引擎-管理搜索引擎和网站搜素-网站搜索-新增
2. Edge-设置-搜:地址栏和搜索-管理搜索引擎-添加
```
cc
cc
https://zh.cppreference.com/mwiki/index.php?title=Special:%E6%90%9C%E7%B4%A2&search=%s
```
