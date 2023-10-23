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
1. xxx
```cpp
initiator->start();//Initiator::start()//->
HttpServer::startGlobal( m_settings );//新线程
thread_spawn( &startThread, this, m_threadid )//新线程
SocketInitiator::onStart()
Initiator::connect()
```