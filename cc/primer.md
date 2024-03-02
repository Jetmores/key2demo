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


### class/struct
1. 非静态成员函数隐含参数T* const this;
2. 常量成员函数是修饰this指针的,不可修改特性可被mutable修饰的成员变量打破,与非const版本是重载关系;
3. 合成的默认构造函数:在未定义任何构造函数时自动生成,也可=default主动生成;构造函数的参数列表都有默认值时隐式定义了默认构造函数;
4. 构造函数初始值列表的赋值时机,在类内初始值={}之后,构造函数体之前;成员变量是const或引用或无默认构造函数时必不可少;
5. 合成操作:默认构造,拷贝构造,拷贝赋值,析构;
6. 友元声明仅仅指定访问的权限,一般在类的开始或结束处,友元函数的声明和定义分布在相关类的头文件和源文件中;友元类和友元成员函数类似;
7. 内联函数分为显式内联(类中加inline),隐式内联(类声明中定义),延迟内联(类外inline);又可分为加inline和不加inline;但都是放头文件中的
8. 名字查找与类的作用域:成员函数体-类内-include头文件之间-include头文件之前;变量同名覆盖,类型同名则重定义错误;
9. 当对象默认初始化或值初始化时自动执行默认构造函数;值初始化:提供少于数组大小的初始值,不使用初始值的局部静态变量,T()或T{}形式的包括vector<int> vi(5);
10. 转换构造函数是只有一个参数的构造函数,且只允许转换一次;explicit只允许出现在类内声明处,可用于抑制隐式类型转换,此时无法=形式的拷贝构造包括参数实例化;
```cpp
item.combine(null_book);//explicit ;error
item.combine(Sales_data(null_book));
item.combine(static_cast<Sales_data>(null_book));
```
11. constexpr构造函数无函数体,必须初始化所有成员变量(类内初始值,构造函数初始值列表)
12. static是类内修饰符,可以.和->访问成员,也可X::static_a访问,静态成员函数除了无this和const修饰this其它相同;static成员变量类似全局变量,在源文件中定义如int X::static_a=1;此时被const修饰类外定义需要常量表达式,而constexpr则类内初始值需要常量表达式且类外有时需要constexpr int Account::period;


### derive class
1. 面向对象三大特性:封装(实现接口和实现的分离),继承,多态;


