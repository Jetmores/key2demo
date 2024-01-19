### ?嵌套类 ?nested
```cpp
int x,y; // 全局变量
class enclose // 外围类
{
public:
    struct inner // 嵌套类
    {
        void f(int i)
        {
            x = i; // 错误：不能不带实例地写入非静态的 enclose::x
            int a = sizeof x; // C++11 前错误，C++11 中 OK：sizeof 的操作数不求值，
                              // 可以这样使用非静态的 enclose::x 。
            s = i;   // OK：可以赋值给静态 enclose::s
            ::x = i; // OK：可以赋值给全局 x
            y = i;   // OK：可以赋值给全局 y
        }
 
        void g(enclose* p, int i)
        {
            p->x = i; // OK：赋值给 enclose::x
        }
    };
private:
    int x;
    static int s;
};
```

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

### vscode c/cpp format settings
* F1->Preferences: Open User Settings(json)
* Ctrl+,->search formatting->C/C++ /Formatting->C_Cpp:Clang_format_style->{ BasedOnStyle: WebKit, IndentWidth: 2, TabWidth: 2}
* Editor:Format On Paste

### vscode Keyboard Shortcuts
File->Preferences->Keyboard Shortcuts->cursorLineEnd->Ctrl+;

### log
1. 同步日志:实时性好,便于记录异常崩溃日志;但写io阻塞当前业务
2. 异步日志:业务线程生成日志信息,打印线程消费;
