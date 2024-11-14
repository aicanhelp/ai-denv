# Run Docker Registry

This is created for deploying Docker Registry.

Registry V2 API

|Method|Path|Entity|Description|
|-----|--------|----------|-------------|  
|GET|/v2/|Base|Check that the endpoint implements Docker Registry API V2.|
|GET|/v2/<name>/tags/list|Tags|Fetch the tags under the repository identified by name.某仓库下的tag列表|
|GET|/v2/<name>/manifests/<reference>|Manifest|Fetch the manifest identified by name and reference where reference 可以是镜像 tag 或 digest（要用header里的digest）. A HEAD request can also be issued to this endpoint to obtain resource information without receiving all data.获取某仓库某tag信息清单，带上请求header，可以获得指定信息|
|PUT|/v2/<name>/manifests/<reference>|Manifest|Put the manifest identified by name and reference where reference can be a tag or digest.|
|DELETE|/v2/<name>/manifests/<reference>|Manifest|Delete the manifest identified by name and reference. Note that a manifest can only be deleted by digest.（要用header里的镜像digest）|
|GET|/v2/<name>/blobs/<digest>|Blob|Retrieve the blob from the registry identified by digest. A HEAD request can also be issued to this endpoint to obtain resource information without receiving all data.|
|DELETE|/v2/<name>/blobs/<digest>|Blob|Delete the blob identified by name and digest（要用config–>digest）|
|POST|/v2/<name>/blobs/uploads/|Initiate Blob Upload|Initiate a resumable blob upload. If successful, an upload location will be provided to complete the upload. Optionally, if the digest parameter is present, the request body will be used to complete the upload in a single request.|
|GET|/v2/<name>/blobs/uploads/<uuid>|BlobUpload|Retrieve status of upload identified by uuid. The primary purpose of this endpoint is to resolve the current status of a resumable upload.|
|PATCH|/v2/<name>/blobs/uploads/<uuid>|Blob Upload|	Upload a chunk of data for the specified upload.|
|PUT|/v2/<name>/blobs/uploads/<uuid>|Blob Upload|Complete the upload specified by uuid, optionally appending the body as the final chunk.|
|DELETE|/v2/<name>/blobs/uploads/<uuid>|Blob Upload|Cancel outstanding upload processes, releasing associated resources. If this is not called, the unfinished uploads will eventually timeout.|
|GET|/v2/_catalog|Catalog|Retrieve a sorted, json list of repositories available in the registry.仓库列表|


创建 kubernetes secrets for docker-registry：
kubectl create secret docker-registry  regsecret --docker-server=registry-vpc.cn-hangzhou.aliyuncs.com --docker-username=admin --docker-password=123456 --docker-email=xxxx@qq.com

拉取私有仓库的两种方法：

（1） 在Pod指定imagePullSecrets

（2）将认证信息添加到serviceAccount中

将认证信息添加到serviceAccount中，要比直接在Pod指定imagePullSecrets要安全很多

1、创建admin的sa： kubectl create serviceaccount admin

查看admin的sa的信息，Image pull secrets为空，此时k8s为用户自动生成认证信息，但没有授权
kubectl get sa admin
kubectl describe sa admin

2、添加secrets到serviceaccount中
（1）查看secrets的信息：kubectl get secrets ，其中的myregistrykey是私有仓库的认证信息
（2）将myregistrykey添加到serviceaccount的admin的imagePullSecrets
   kubectl patch serviceaccount admin -p '{"imagePullSecrets": [{"name": "myregistrykey"}]}'
2.3 绑定serviceaccount和pod
（1） 应用文件：kubectl apply -f pod3.yml

apiVersion: v1
kind: Pod
metadata:
  name: pod
spec:
  containers:
    - name: redis-photo
      image: reg.westos.org/linux/redis-photon
  serviceAccountName: admin
（2）查看pod的信息：kubectl get pod，私有仓库的镜像拉取成功，pod正常运行


1、创建 CA 私钥  
```
  openssl genrsa -out "root-ca.key" 2048
```

2、利用私钥创建 CA 根证书请求文件
```
openssl req  -new -key "root-ca.key"  -out "root-ca.csr" -sha256  -subj '/C=CN/ST=beijing/L=beijing/O=cmri/CN=cmri.cn'
```

3、配置 CA 根证书，新建 root-ca.cnf
```
[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
```

4、签发根证书
```
openssl x509 -req  -days 3650  -in "root-ca.csr"  -signkey "root-ca.key" -sha256 -out "root-ca.crt" -extfile "root-ca.cnf" -extensions root_ca
```

5、生成站点 SSL 私钥
```
openssl genrsa -out "cmri.cn.key" 2048
```

6、使用私钥生成证书请求文件
```
openssl req -new -key "cmri.cn.key" -out "site.csr" -sha256  -subj '/C=CN/ST=beijing/L=beijing/O=cmri/CN=cmri.cn'
```

7、配置证书，新建 site.cnf 文件
subjectAltName = DNS:docker.domain.com, IP:192.168.2.140 可以只使用IP
```
[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = IP:192.168.122.1,IP:0.0.0.0,IP:127.0.0.1
subjectKeyIdentifier=hash
```

8、签署站点 SSL 证书
```
openssl x509 -req -days 750 -in "site.csr" -sha256  -CA "root-ca.crt" -CAkey "root-ca.key"  -CAcreateserial  -out "cmri.cn.crt" -extfile "site.cnf" -extensions server
```

9、配置私有仓库
私有仓库默认的配置文件位于 /etc/docker/registry/config.yml，我们先在本地编辑 config.yml，之后挂载到容器中使用。
```
version: 0.1
log:
  accesslog:
    disabled: true
  level: debug
  formatter: text
  fields:
    service: registry
    environment: staging
storage:
  delete:
    enabled: true
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
auth:
  htpasswd:
    realm: basic-realm
    path: /etc/docker/registry/auth/registry
http:
  addr: :443
  host: https://mds-repo.cmri.cn
  headers:
    X-Content-Type-Options: [nosniff]
  http2:
    disabled: false
  tls:
    certificate: /etc/docker/registry/ssl/cmri.cn.crt
    key: /etc/docker/registry/ssl/cmri.cn.key
health:
  storagedriver:
    enabled: true
    interval: 10s
threshold: 3
```

10、生成 http 认证文件
```
docker run --rm  --entrypoint htpasswd   httpd:alpine -Bbn modongsong beijing > auth/registry
```

11、添加编辑 docker-compose.yml
```
version: '3'
services:
  registry:
    image: registry
    ports:
      - "443:443"
    volumes:
      - /root/registry:/etc/docker/registry
      - registry-data:/var/lib/registry
volumes:
  registry-data:
```

12、修改 hosts
往/etc/hosts中添加：
192.168.2.140 mds-repo.cmri.cn

13、测试私有仓库功能  
由于自行签发的 CA 根证书不被系统信任，所以我们需要将 CA 根证书 ssl/root-ca.crt 移入 /etc/docker/certs.d/cmri.cn 文件夹中。同时需要修改：
修改/etc/docker/daemon.json
{
   "insecure-registries" : ["https://127.0.0.1:8443","https://0.0.0.0:8443"]
}



13、kubernetes拉取私库镜像（创建secret, 用docker配置创建）

```
kubectl create secret generic registry.cmri.cn.key -n aimedical --from-file=.dockerconfigjson=/root/.docker/config.json --type=kubernetes.io/dockerconfigjson
```

14、添加CA证书 到kubernetes信任列表
```
kubectl create secret generic my-registry-ca --from-file=my-registry.crt
```