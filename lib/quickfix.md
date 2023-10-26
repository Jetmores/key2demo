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

thread_spawn( &startThread, this, m_threadid )//Initiator::start()下的新线程,用于连接和处理连接上的读写事件,可以打onEvent的log
SocketInitiator::onStart()
Initiator::connect()
SocketInitiator::doConnect( const SessionID& s, const Dictionary& d )
m_connector.connect( address, port, m_noDelay, m_sendBufSize, m_rcvBufSize, sourceAddress, sourcePort );
while ( !isStopped() ) {//读写异常等的事件循环
  m_connector.block( *this, false, 1.0 );
  onTimeout( m_connector );
}
```

3. 线程任务分布
```cpp
//主线程1
35=D或F
FIX::Session::sendToTarget
FIX::Session::sendRaw
FIX::Session::send
FIX::SocketConnection::send
FIX::SocketConnection::processQueue


//httpServer线程2


//收发线程3
35=A
FIX::Initiator::startThread
FIX::SocketInitiator::onStart
FIX::SocketConnector::block
FIX::SocketMonitor::block
FIX::SocketMonitor::processWriteSet
FIX::SocketInitiator::onConnect
FIX::SocketConnection::onTimeout
FIX::Session::next
FIX::Session::generateLogon
FIX::Session::sendRaw
FIX::Session::send
FIX::SocketConnection::send
FIX::SocketConnection::processQueue

35=0
FIX::Session::generateHeartbeat

35=5
FIX::Session::generateLogout


35=8或9
FIX::Initiator::startThread
FIX::SocketInitiator::onStart
FIX::SocketConnector::block
FIX::SocketMonitor::block
FIX::SocketMonitor::processReadSet
FIX::ConnectorWrapper::onEvent
FIX::SocketConnection::read
FIX::SocketConnection::readMessages
FIX::Session::next
FIX::Session::verify
Application::fromApp
FIX::MessageCracker::crack
FIX42::MessageCracker::crack
Application::onMessage

```

