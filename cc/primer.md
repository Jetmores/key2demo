### container
#### 顺序增删改查

#### 容器适配器stack-priority_queue-queue
1. push emplace
2. pop
3. top/back front

#### 关联增删改查


### algorithm
#### 增删改查

#### special
函数编程对象
* 函数对象:operator()(int a,int b){}
* lambda表达式
* bind
* function可调对象


高阶函数
1. accumulate
2. remove_if:erase(remove_if)
3. transform(b,e,d,call):d可等于b

#### 划分/排序/二分查找/排列/集合/大小


### numeric
* iota(b,e,val)
* accumulate(b,e,init)
* inner_product(b,e,b2,init)
* adjacent_difference(b,e,d)
* partial_sum(b,e,d)


### 智能指针
#### shared_ptr
1. shared_ptr<T> p(q);//拷贝构造
2. p=q;//拷贝赋值
3. make_shared<T>(args);
4. shared_ptr<T> p(ptr,d=delete);//拷贝构造,如ptr=new int(0)
5. shared_ptr<T> p(weak_ptr);//lock()为false时null,此时构造抛异常
6. shared_ptr<T> p(unique_ptr);
7. p.reset(ptr=nullptr,d=delete);
8. shared_ptr<int> sp(new int[10],[](int *p){delete[] p;});//c++17后用法类似unique
9. *(sp.get()+i)=i;//接上,索引;c++17之后支持直接索引

#### unique_ptr
1. unique_ptr<T[]> u;
2. unique_ptr<T[]> u(p);//unique_ptr<int[]> up(new int[10]);
3. u[i];
4. unique_ptr<T,D=decltype(delete)*> p(ptr,d=delete);
5. p.reset(ptr=nullptr);
6. auto p=p2.release();unique_ptr<int> p(p2.release());//单p2.release();是错误的,丢失了指针

#### weak_ptr
1. 在成环最后节点,用weak_ptr打破环状依赖,防止内存泄漏
```cpp
struct B;
struct A{
    //shared_ptr<B> sp_;//造成引用成环,内存泄漏
    weak_ptr<B> sp_;
};
struct B{
    shared_ptr<A> sp_;
};

void main(void){
    shared_ptr<A> sa=new A();
    shared_tr<B> sb=new B();
    sa->sp_=sb;
    sb->sp_=sa;
}
```
2. shared_ptr生存期之外存在weak_ptr
```cpp
#include <iostream>
#include <memory>
 
std::weak_ptr<int> gw;
 
void observe()
{
    std::cout << "gw.use_count() == " << gw.use_count() << "; ";
    // 使用之前必须制作一个 shared_ptr 副本
    if (std::shared_ptr<int> spt = gw.lock())
        std::cout << "*spt == " << *spt << '\n';
    else
        std::cout << "gw 已过期\n";
}
 
int main()
{
    {
        auto sp = std::make_shared<int>(42);
	gw = sp;
 
	observe();
    }
 
    observe();
}
```

#### allocator
1. allocator<T> a;
2. p=a.allocate(n);
3. a.deallocate(p,n);//在此之前需要依次destroy(p)
4. a.construct(p,args);
5. a.destroy(p);
```cpp
uninitialized_fill(b,e,val);
fill_n(dest,n,val);
copy(b,e,dest);
copy_n(b,n,dest);
```


### regex
1. [s|c]regex_[search|match]([s|cp],([s|c]match)m,r)
2. m.str(n) == m[n].str() m.format(fmt)
3. [s|c]regex_iterator
```cpp
for(sregex_iterator it(s.begin(),s.end(),r),end_it;it!=end_it;++it){
    cout<<it-str()<<endl;
}
```
4. regex_replace(s,r,fmt)


### chrono
1. 时间点sleep_until
```cpp
    time_t t0 = time(NULL);//const std::time_t t_c = std::chrono::system_clock::to_time_t(now);
    tm* nowtime0 = localtime(&t0);
    sprintf(name + 21, "%04d%02d%02d.log", 1900 + nowtime0->tm_year, 1 + nowtime0->tm_mon, nowtime0->tm_mday);

```
2. 时间段sleep_for
```cpp
#include <algorithm>
#include <chrono>
#include <ctime>
#include <iomanip>
#include <iostream>
 
void slow_motion()
{
    static int a[]{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    // 生成 Γ(13) == 12! 的排列:
    while (std::ranges::next_permutation(a).found) {}
}
 
int main()
{
    using namespace std::literals; // 允许用字面量后缀，如 24h、1ms、1s。
 
    const std::chrono::time_point<std::chrono::system_clock> now =
        std::chrono::system_clock::now();
 
    const std::time_t t_c = std::chrono::system_clock::to_time_t(now - 24h);
    std::cout << "24 小时前，时间是 "
              << std::put_time(std::localtime(&t_c), "%F %T。\n") << std::flush;
 
    const std::chrono::time_point<std::chrono::steady_clock> start =
        std::chrono::steady_clock::now();
 
    std::cout << "不同的时钟无法比较：\n"
                 "  系统时间：" << now.time_since_epoch() << "\n"
                 "  稳定时间：" << start.time_since_epoch() << '\n';
 
    slow_motion();
 
    const auto end = std::chrono::steady_clock::now();
    std::cout
        << "缓慢的计算花费了 "
        << std::chrono::duration_cast<std::chrono::microseconds>(end - start) << " ≈ "
        << (end - start) / 1ms << "ms ≈ " // 几乎等价于以上形式，
        << (end - start) / 1s << "s。\n";  // 但分别使用毫秒和秒
}
```


### filesystem
```cpp
  const std::filesystem::path sandbox { "sandbox" };
  std::filesystem::recursive_directory_iterator rit { sandbox };
  //std::for_each(begin(rit), end(rit), [](const auto& dir_entry) { std::cout << dir_entry << '\n'; });
  std::for_each(begin(rit), end(rit), [](const auto& dir_entry) { printf("%s\n", dir_entry.path().relative_path().c_str()); });
```


### class



### derive class


