1、dapr其实也支持framwork webapi服务，只是需要采用自宿主，并且不能用owin的方式来启动（Microsoft.AspNet.WebApi.OwinSelfHost），需要用微软自带的库来启动（Microsoft.AspNet.WebApi.SelfHost）

2、dapr初始化速度慢的解决方法： dapr init --slim --network https://mirrors.aliyun.com/pypi/simple/

3、dapr发布的IP地址要用 * 号表示，指定ip地址无法使用dapr的消息服务，原因未知