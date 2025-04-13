1、java PKIX 问题：
可以通过系统设置来信任所有的证书
```shell
System.setProperty("javax.net.ssl.trustStore", "/path/to/customTrustStore.jks");
System.setProperty("javax.net.ssl.trustStorePassword", "trustStorePassword");
System.setProperty("javax.net.ssl.trustAllHosts", "true");
```