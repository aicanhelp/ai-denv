国内可以使用的proxy

https://goproxy.io
https://athens.azurefd.net
https://goproxy.cn
https://gocenter.io
https://mirrors.aliyun.com/goproxy/
linux下使用
export GOPROXY=https://goproxy.io
windows下直接设置环境变量GOPROXY

最重要的一步来了,因为众所周知的原因,很多包不能直接下载,可以用proxy,如果找不到proxy,那么只能用replace.用文本编辑器打开go.mod,加入如下内容:

module go-wikitten   

go 1.12

replace (
 golang.org/x/text => github.com/golang/text latest

 golang.org/x/net => github.com/golang/net latest

 golang.org/x/crypto => github.com/golang/crypto latest

 golang.org/x/tools => github.com/golang/tools latest

 golang.org/x/sync => github.com/golang/sync latest

 golang.org/x/sys => github.com/golang/sys latest
)

常用的replace列表:
golang.org/x/text => github.com/golang/text latest

 golang.org/x/net => github.com/golang/net latest

 golang.org/x/crypto => github.com/golang/crypto latest

 golang.org/x/tools => github.com/golang/tools latest

 golang.org/x/sync => github.com/golang/sync latest

 golang.org/x/sys => github.com/golang/sys latest

 cloud.google.com/go => github.com/googleapis/google-cloud-go latest

 google.golang.org/genproto => github.com/google/go-genproto latest

 golang.org/x/exp => github.com/golang/exp latest

 golang.org/x/time => github.com/golang/time latest

 golang.org/x/oauth2 => github.com/golang/oauth2 latest

 golang.org/x/lint => github.com/golang/lint latest

 google.golang.org/grpc => github.com/grpc/grpc-go latest

 google.golang.org/api => github.com/googleapis/google-api-go-client latest

 google.golang.org/appengine => github.com/golang/appengine latest

 golang.org/x/mobile => github.com/golang/mobile latest

 golang.org/x/image => github.com/golang/image latest
 
 cloud.google.com/go => github.com/googleapis/google-cloud-go v0.34.0

 github.com/go-tomb/tomb => gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7

 go.opencensus.io => github.com/census-instrumentation/opencensus-go v0.19.0

 go.uber.org/atomic => github.com/uber-go/atomic v1.3.2

 go.uber.org/multierr => github.com/uber-go/multierr v1.1.0

 go.uber.org/zap => github.com/uber-go/zap v1.9.1
 
 google.golang.org/api => github.com/googleapis/google-api-go-client v0.0.0-20181220000619-583d854617af

 google.golang.org/appengine => github.com/golang/appengine v1.3.0

 google.golang.org/genproto => github.com/google/go-genproto v0.0.0-20181219182458-5a97ab628bfb

 google.golang.org/grpc => github.com/grpc/grpc-go v1.17.0

 gopkg.in/alecthomas/kingpin.v2 => github.com/alecthomas/kingpin v2.2.6+incompatible

 gopkg.in/mgo.v2 => github.com/go-mgo/mgo v0.0.0-20180705113604-9856a29383ce

 gopkg.in/vmihailenco/msgpack.v2 => github.com/vmihailenco/msgpack v2.9.1+incompatible

 gopkg.in/yaml.v2 => github.com/go-yaml/yaml v0.0.0-20181115110504-51d6538a90f8

 labix.org/v2/mgo => github.com/go-mgo/mgo v0.0.0-20160801194620-b6121c6199b7

 launchpad.net/gocheck => github.com/go-check/check v0.0.0-20180628173108-788fd7840127