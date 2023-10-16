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

class THashMapPriceTimePriority :public matching_api::IOrderBook,public std::map <ATPDecimal, THashMapEntry>,public ISerializable, 
public TEvent <price_change_info>,public exchange_instr_subscr_registry_t, public ACE_Event_Handler
class TOrderRepositoryPriceTimePriority : public std::map <ATPDecimal, THashMapEntry>, public ISerializable

//THashMapEntry.h
class Side : public TList{};
class THashMapEntry{
Side  buy_side_ ;Side  sell_side_ ;}
```

#### fix逻辑
/home/shared/src/simex/exchange_simulator/ExchSimApplication44.cpp
```cpp
class ExchSimApplication44 : public IExchSimApplication, virtual public corelib::BaseFixApplication
void onMessage(const FIX44::NewOrderSingle &, const FIX::SessionID &);
void onMessage(const FIX44::OrderCancelRequest &, const FIX::SessionID &);

void sendFilledReport(const corelib::security_identifier_t& sec_id, OrderPtr order);
void sendPartialFillReport(const corelib::security_identifier_t& sec_id, OrderPtr order);
void sendNewOrderReport(const corelib::security_identifier_t& sec_id, OrderPtr order);
void sendRejectedReport(const corelib::security_identifier_t& sec_id, OrderPtr order,order_reject_reason_enum reason_code, const char* reason_text);

void sendCancelAccept(const corelib::security_identifier_t& sec_id, OrderPtr order,const cancel_reason_t& cancel_reason = enNoReason, const std::string& cancel_id = "");
void sendCancelReject(const corelib::security_identifier_t& sec_id, OrderPtr order, const reject_params_t& reject_params);
```



