### NINJA Application
```cpp
Application app;
app.init();
app.run();
app.sendMsg("router_branch012", "exch_sim012", &order);
app.stop();
//Application.cpp
//NINJATradeClient.cpp 封装一层
NinjaBuzzManager::build
auto sessId = ninjaClient()->getSession(senderId, targetId, this);
class NinjaMsgListener : public NINJA::MsgHandlerImpl
class NinjaBuzzManager:   Noncopyable, public NinjaMsgListener //联系全局的类NinjaBuzzManager
NinjaMsgListener::OrderAck
MsgHelper::createOrderAccepted
```