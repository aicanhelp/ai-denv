#### 1、CA问题:
我遇到了同样的问题，必须将.pem文件复制到/usr/local/share/ca-certificates，并将其重命名为.crt。例如，如果您没有.pem，则可以使用openssl轻松将.cer文件转换为.pem。

复制文件后，必须执行sudo update-ca-certificates。

openssl x509 -inform DER -in certificate.cer -out certificate.crt
openssl x509 -inform PEM -in certificate.cer -out certificate.crt


快捷键，没有printSrc键时，用fn+insert


#### 2、没有add to favorite
需要/usr/share/applictions中对应的*.desktop文件中增加 StartupWMClass。同时，
*.desktop文件的文件名改为${VM_Class}.desktop. 这时，应用程序启动后，就有add to favorite了
有关获取VMClass：
启动应用程序，然后小窗口启动一个termial，运行'xpop|grep WM_CLASS',然后鼠标点击一下应用程序的窗口，terminal中就会返回该应用程序的WM_Class.


【经验分享】Ubuntu上添加可信任根证书
1. 如果是pem格式的根证书，先重命名为 .crt格式，例如（ mitmproxy-ca-cert.crt）。
2. sudo cp  mitmproxy-ca-cert.crt  /usr/local/share/ca-certificates/
3. sudo update-ca-certificates

update-ca-certificates命令将PEM格式的根证书内容附加到/etc/ssl/certs/ca-certificates.crt ，而/etc/ssl/certs/ca-certificates.crt 包含了系统自带的各种可信根证书.