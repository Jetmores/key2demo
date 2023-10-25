### 典型应用
```cpp
    Application application;
    FIX::FileStoreFactory storeFactory( settings );
    FIX::ScreenLogFactory logFactory( settings );
    initiator = new FIX::SocketInitiator( application, storeFactory, settings, logFactory );
    initiator->start();
    application.run();
    initiator->stop();
    delete initiator;
```

### 源码分析
1. 组成
```cpp
//SessionSettings:读取配置文件,以不同SessionID为key组成map红黑树
class SessionSettings
typedef std::map < SessionID, Dictionary > Dictionaries;
Dictionaries m_settings;

class SocketInitiator : public Initiator, SocketConnector::Strategy
SocketInitiator( Application&, MessageStoreFactory&,const SessionSettings&, LogFactory& ) EXCEPT ( ConfigError );

//其它
DataDictionary.cpp//解析诸如FIX42.xml的数据字典
Field.cpp//数据字典中解析预定义的field
FieldMap.cpp//message的头-体-尾的基类
Message.cpp//数据字典中解析处理message节点
Http.cpp//实现http引擎的部分
Socket.cpp//会话层的通信
Session.cpp//会话层的东西
```

2. 新建线程
```cpp
initiator->start();//Initiator::start()//->
HttpServer::startGlobal( m_settings );//HttpServer::start()//thread_spawn( &startThread, this, m_threadid )//新线程
HttpServer::onStart()
m_pServer->block( *this )//SocketServer::block//m_monitor.block( wrapper, poll, timeout );
select( FD_SETSIZE, &readSet, &writeSet, &exceptSet, getTimeval(poll, timeout) );
processWriteSet( strategy, writeSet );
processReadSet( strategy, readSet );

thread_spawn( &startThread, this, m_threadid )//Initiator::start()下的新线程,用于连接和断连重试
SocketInitiator::onStart()
Initiator::connect()
```

3. 数据来回(fromApp,toAdmin/toApp)与线程切换
```cpp
//toAdmin//after sendtoTarget//main thread
Session::sendToTarget
sendRaw
isAdminMsgType//0A12345//m_application.toAdmin( message, m_sessionID );//只有A,5,0等才是admin消息,否则toApp
Session::send
m_pResponder->send( string );

//fromApp//back msg//which thread?

```

