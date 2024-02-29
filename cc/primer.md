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

#### unique_ptr

#### weak_ptr


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


### class


### derive class


