1、路径路径转义问题

下面是一个配置例子：
```
    location /path/ {
    proxy_pass http://example.com:80/;
    }

    location ~* /path/api/ {
        rewrite ^ $request_uri;
        rewrite ^/path/api/(.*) /api/$1 break;
        return 400;
        proxy_pass http://example.com:80$uri;
        proxy_buffering	off;
        proxy_set_header Host $http_addr;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

```

下面再介绍一下这中原理吧，首先来说一下Nginx的路径匹配规则：

- location
大家都知道 ~* 是不区分大小写正则匹配，location的匹配优先顺序是：
```
    ( location = ) > ( location <完整路径> ) > ( location ^~ ) > ( location ~ 或 ~* ) > ( location <部分路径> ) > ( location / )
```

- rewrite
rewrite是Nginx重定向http请求的一种方式，具体语法如下：
```
    Syntax:	rewrite regex replacement [flag];
    Default:	—
    Context:	server, location, if
```

上例中第一个rewrite 这里又涉及到一个知识点，$request_uri 这个变量等于从客户端发送来的原始请求URI（最原始的），包括参数，它不可以进行修改。 匹配完第一个rewrite，继续匹配第二个rewrite，把/path 前缀去掉，然后break。

具体规则详见 ngx_http_rewrite_module

到最后 proxy_pass 这行使用到了另一个变量 $uri，这个变量指当前的请求URI，不包括任何参数。 
重点是这个变量反映任何内部重定向或index模块所做的修改。 所以这里使用rewrite功能绕过了Nginx的转义功能，使url显示正确。
