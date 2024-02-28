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


### filesystem


### class


### derive class


