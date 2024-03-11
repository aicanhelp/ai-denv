CA:
我遇到了同样的问题，必须将.pem文件复制到/usr/local/share/ca-certificates，并将其重命名为.crt。例如，如果您没有.pem，则可以使用openssl轻松将.cer文件转换为.pem。

复制文件后，必须执行sudo update-ca-certificates。

openssl x509 -inform DER -in certificate.cer -out certificate.crt
openssl x509 -inform PEM -in certificate.cer -out certificate.crt


快捷键，没有printSrc键时，用fn+insert