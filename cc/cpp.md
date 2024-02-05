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

## 并发实战
### 基于atomic_flag的自旋锁
```cpp
class spinlock_mutex
{
 std::atomic_flag flag;
public:
 spinlock_mutex():
 flag(ATOMIC_FLAG_INIT)
 {}
 void lock()
 {
 while(flag.test_and_set(std::memory_order_acquire));
 }
 void unlock()
 {
 flag.clear(std::memory_order_release);
 }
};
```

### 可上锁和等待的线程安全队列
```cpp
template<typename T>
class threadsafe_queue
{
private:
 struct node
 {
 std::shared_ptr<T> data;
 std::unique_ptr<node> next;
 };
 std::mutex head_mutex;
 std::unique_ptr<node> head;
 std::mutex tail_mutex;
 node* tail;
 std::condition_variable data_cond;
public:
 threadsafe_queue():
 head(new node),tail(head.get())
 {}
 threadsafe_queue(const threadsafe_queue& other)=delete;
 threadsafe_queue& operator=(const threadsafe_queue& other)=delete;
 std::shared_ptr<T> try_pop();
 bool try_pop(T& value);
 std::shared_ptr<T> wait_and_pop();
 void wait_and_pop(T& value);
 void push(T new_value);
 bool empty();
};

template<typename T>
void threadsafe_queue<T>::push(T new_value)
{
 std::shared_ptr<T> new_data(
 std::make_shared<T>(std::move(new_value)));
 std::unique_ptr<node> p(new node);
 {
 std::lock_guard<std::mutex> tail_lock(tail_mutex);
 tail->data=new_data;
 node* const new_tail=p.get();
 tail->next=std::move(p);
 tail=new_tail;
 }
 data_cond.notify_one();
}

template<typename T>
class threadsafe_queue
{
private:
 node* get_tail()
 {
 std::lock_guard<std::mutex> tail_lock(tail_mutex);
 return tail;
 }
 std::unique_ptr<node> pop_head() // 1
 {
 std::unique_ptr<node> old_head=std::move(head);
 head=std::move(old_head->next);
 return old_head;
 }
 std::unique_lock<std::mutex> wait_for_data() // 2
 {
 std::unique_lock<std::mutex> head_lock(head_mutex);
 data_cond.wait(head_lock,[&]{return head.get()!=get_tail();});
 return std::move(head_lock); // 3
 }
 std::unique_ptr<node> wait_pop_head()
 {
 std::unique_lock<std::mutex> head_lock(wait_for_data()); // 4
 return pop_head();
 }
 std::unique_ptr<node> wait_pop_head(T& value)
 {
 std::unique_lock<std::mutex> head_lock(wait_for_data()); // 5
 value=std::move(*head->data);
 return pop_head();
 }
public:
 std::shared_ptr<T> wait_and_pop()
 {
 std::unique_ptr<node> const old_head=wait_pop_head();
 return old_head->data;
 }
 void wait_and_pop(T& value)
 {
 std::unique_ptr<node> const old_head=wait_pop_head(value);
 }
};

template<typename T>
class threadsafe_queue
{
private:
 std::unique_ptr<node> try_pop_head()
 {
 std::lock_guard<std::mutex> head_lock(head_mutex);
 if(head.get()==get_tail())
 {
 return std::unique_ptr<node>();
 }
 return pop_head();
 }
 std::unique_ptr<node> try_pop_head(T& value)
 {
 std::lock_guard<std::mutex> head_lock(head_mutex);
 if(head.get()==get_tail())
 {
 return std::unique_ptr<node>();
 }
 value=std::move(*head->data);
 return pop_head();
 }
public:
 std::shared_ptr<T> try_pop()
 {
 std::unique_ptr<node> old_head=try_pop_head();
 return old_head?old_head->data:std::shared_ptr<T>();
 }
 bool try_pop(T& value)
 {
 std::unique_ptr<node> const old_head=try_pop_head(value);
 return old_head;
 }
 bool empty()
 {
 std::lock_guard<std::mutex> head_lock(head_mutex);
 return (head.get()==get_tail());
 }
};
```

## 高级线程管理
### 线程池