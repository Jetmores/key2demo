### 重新编译argo代码库
```bash
# Ubuntu22.04 0815版本(0915编译不过)
cp -r ~/ninja/Argo_modified_libs/quickfix-1.14.0 .
cp -r ~/ninja/Servers/ATP_third_party_libs_source/quickfix-1.14.0/ .
./build.sh
```

### 调试ME
将启动脚本start_matching_engine.sh中的#gdb行取消注释即可调试;或者gdb attach pid
```bash
b NotificationApiManager.cpp:on_admin_notification
set scheduler-locking on
b NotificationApiManager.cpp:578
# QuickFast代码也有变更,但没报错,暂用旧版本
```

### 源码分析
#### matchingEngine撮合基本原理
1. 以股票代码为key的unordered_map关联数组
2. 以价格为key的map红黑树,节点是买卖的各一个双向链表
```cpp
//OrdersManager.h
class OrdersManager : public TEvent <price_change_info>::Handler{
QueueInterface                  * queue_;
SymbolBookPriceTimePriority     * symbol_book_ ;

//TSymbolBook.h
template<typename TKey, typename TVal>
class SymbolHashMap: public std::unordered_map<TKey, TVal, hash_comparer<TKey>, eq_sec_id<TKey>>{};

template <class TKey,class TPriceHashMap,class TOrderRepStrategy>
class TSymbolBook: public SymbolHashMap<TKey, OrderStorage<TPriceHashMap, TOrderRepStrategy>>, public ISerializable
typedef TSymbolBook < corelib::security_identifier_t,THashMapPriceTimePriority,TOrderRepositoryPriceTimePriority > SymbolBookPriceTimePriority;



```

#### fix逻辑
/home/shared/src/simex/exchange_simulator/ExchSimApplication44.cpp



