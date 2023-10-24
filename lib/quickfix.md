### 实例典型
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

### 线程
1. 新建线程
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

2. 数据来回(fromApp,toAdmin)与线程切换
```cpp
//toAdmin//after sendtoTarget//main thread
Session::sendToTarget
sendRaw
isAdminMsgType//0A12345//m_application.toAdmin( message, m_sessionID );//只有A,5,0等才是admin消息,否则toApp
Session::send
m_pResponder->send( string );

//fromApp//back msg//which thread?

```
