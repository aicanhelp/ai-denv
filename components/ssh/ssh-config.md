SSH（Secure Shell）是什么？是一项创建在应用层和传输层基础上的安全协议，为计算机上的 Shell（壳层）提供安全的传输和使用环境。也是专为远程登录会话和其他网络服务提供安全性的协议。它能够有效防止远程管理过程中的信息泄露问题。通过 SSH 可以对所有传输的数据进行加密，也能够防止 DNS 欺骗和 IP 欺骗。

具体生成 SSH Key 方式请参考：Github ssh key生成，免密登录服务器方法。这里以 id_ecdsa（私钥） 和 id_ecdsa.pub（公钥） 为例。

本篇文章主要介绍 SSH 相关的使用技巧。通过对 ~/.ssh/config 文件的配置你可以大大简化 SSH 相关的操作，如：
```
Host example                       # 关键词
    HostName example.com           # 主机地址
    User root                      # 用户名
    # IdentityFile ~/.ssh/id_ecdsa # 认证文件
    # Port 22                      # 指定端口
```
通过执行 $ ssh example 我就可以登录我的服务器。而不需要敲更多的命令 $ ssh root@example.com。又如我们想要向服务器传文件 $ scp a.txt example:/home/user_name。比以前方便多了。

更过相关帮助文档请参考 $ man ssh_config 5。

### 配置项说明
SSH 的配置文件有两个：
```
$ ~/.ssh/config            # 用户配置文件  
$ /etc/ssh/ssh_config      # 系统配置文件  
```
下面来看看常用的配置参数。

- Host
用于我们执行 SSH 命令的时候如何匹配到该配置。

*，匹配所有主机名。
*.example.com，匹配以 .example.com 结尾。
!*.dialup.example.com,*.example.com，以 ! 开头是排除的意思。
192.168.0.?，匹配 192.168.0.[0-9] 的 IP。
AddKeysToAgent
是否自动将 key 加入到 ssh-agent，值可以为 no(default)/confirm/ask/yes。

如果是 yes，key 和密码都将读取文件并以加入到 agent ，就像 ssh-add。其他分别是询问、确认、不加入的意思。添加到 ssh-agent 意味着将私钥和密码交给它管理，让它来进行身份认证。

- AddressFamily
指定连接的时候使用的地址族，值可以为 any(default)/inet(IPv4)/inet6(IPv6)。

- BindAddress
指定连接的时候使用的本地主机地址，只在系统有多个地址的时候有用。在 UsePrivilegedPort 值为 yes 的时候无效。

- ChallengeResponseAuthentication
是否响应支持的身份验证 chanllenge，yes(default)/no。

- Compression
是否压缩，值可以为 no(default)/yes。

- CompressionLevel
压缩等级，值可以为 1(fast)-9(slow)。6(default)，相当于 gzip。

- ConnectionAttempts
退出前尝试连接的次数，值必须为整数，1(default)。

- ConnectTimeout
连接 SSH 服务器超时时间，单位 s，默认系统 TCP 超时时间。

- ControlMaster
是否开启单一网络共享多个 session，值可以为 no(default)/yes/ask/auto。需要和 ControlPath 配合使用，当值为 yes 时，ssh 会监听该路径下的 control socket，多个 session 会去连接该 socket，它们会尽可能的复用该网络连接而不是重新建立新的。

- ControlPath
指定 control socket 的路径，值可以直接指定也可以用一下参数代替：

%L 本地主机名的第一个组件
%l 本地主机名（包括域名）
%h 远程主机名（命令行输入）
%n 远程原始主机名
%p 远程主机端口
%r 远程登录用户名
%u 本地 ssh 正在使用的用户名
%i 本地 ssh 正在使用 uid
%C 值为 %l%h%p%r 的 hash
请最大限度的保持 ControlPath 的唯一。至少包含 %h，%p，%r（或者 %C）。

- ControlPersist
结合 ControlMaster 使用，指定连接打开后后台保持的时间。值可以为 no/yes/整数，单位 s。如果为 no，最初的客户端关闭就关闭。如果 yes/0，无限期的，直到杀死或通过其它机制，如：ssh -O exit。

- GatewayPorts
指定是否允许远程主机连接到本地转发端口，值可以为 no(default)/yes。默认情况，ssh 为本地回环地址绑定了端口转发器。

- HostName
真实的主机名，默认值为命令行输入的值（允许 IP）。你也可以使用 %h，它将自动替换，只要替换后的地址是完整的就 ok。

- IdentitiesOnly
指定 ssh 只能使用配置文件指定的 identity 和 certificate 文件或通过 ssh 命令行通过身份验证，即使 ssh-agent 或 PKCS11Provider 提供了多个 identities。值可以为 no(default)/yes。

- IdentityFile
指定读取的认证文件路径，允许 DSA，ECDSA，Ed25519 或 RSA。值可以直接指定也可以用一下参数代替：

%d，本地用户目录 ~
%u，本地用户
%l，本地主机名
%h，远程主机名
%r，远程用户名

- LocalCommand
指定在连接成功后，本地主机执行的命令（单纯的本地命令）。可使用 %d，%h，%l，%n，%p，%r，%u，%C 替换部分参数。只在 PermitLocalCommand 开启的情况下有效。

- LocalForward
指定本地主机的端口通过 ssh 转发到指定远程主机。格式：LocalForward [bind_address:]post host:hostport，支持 IPv6。

- PasswordAuthentication
是否使用密码进行身份验证，yes(default)/no。

- PermitLocalCommand
是否允许指定 LocalCommand，值可以为 no(default)/yes。

- Port
指定连接远程主机的哪个端口，22(default)。

- ProxyCommand
指定连接的服务器需要执行的命令。%h，%p，%r

如：ProxyCommand /usr/bin/nc -X connect -x 192.0.2.0:8080 %h %p

- User
登录用户名

### 相关技巧
#### 管理多组密钥对

有时候你会针对多个服务器有不同的密钥对，每次通过指定 -i 参数也是非常的不方便。比如你使用 github 和 coding。那么你需要添加如下配置到 ~/.ssh/config：
```
Host github
    HostName %h.com
    IdentityFile ~/.ssh/id_ecdsa_github
    User git
Host coding
    HostName git.coding.net
    IdentityFile ~/.ssh/id_rsa_coding
    User git
```  
当你克隆 coding 上的某个仓库时：
```
# 原来
$ git clone git@git.coding.net:deepzz/test.git
 
# 现在
$ git clone coding:deepzz/test.git
```
#### vim 访问远程文件

vim 可以直接编辑远程服务器上的文件：
```
$ vim scp://root@example.com//home/centos/docker-compose.yml
$ vim scp://example//home/centos/docker-compose.yml
```
#### 远程服务当本地用

通过 LocalForward 将本地端口上的数据流量通过 ssh 转发到远程主机的指定端口。感觉你是使用的本地服务，其实你使用的远程服务。如远程服务器上运行着 Postgres，端口 5432（未暴露端口给外部）。那么，你可以：
```
Host db
    HostName db.example.com
    LocalForward 5433 localhost:5432
```
当你连接远程主机时，它会在本地打开一个 5433 端口，并将该端口的流量通过 ssh 转发到远程服务器上的 5432 端口。

首先，建立连接：
```
$ ssh db
```
之后，就可以通过 Postgres 客户端连接本地 5433 端口：
```
$ psql -h localhost -p 5433 orders
```
#### 多连接共享

什么是多连接共享？在你打开多个 shell 窗口时需要连接同一台服务器，如果你不想每次都输入用户名，密码，或是等待连接建立，那么你需要添加如下配置到 ~/.ssh/config：
```
ControlMaster auto
ControlPath /tmp/%r@%h:%p
```
#### 禁用密码登录

如果你对服务器安全要求很高，那么禁用密码登录是必须的。因为使用密码登录服务器容易受到暴力破解的攻击，有一定的安全隐患。那么你需要编辑服务器的系统配置文件 /etc/ssh/sshd_config：
```
PasswordAuthentication no
ChallengeResponseAuthentication no
```
#### 关键词登录

为了更方便的登录服务器，我们也可以省略用户名和主机名，采用关键词登录。那么你需要添加如下配置到 ~/.ssh/config：
```
Host deepzz                        # 别名
    HostName deepzz.com            # 主机地址
    User root                      # 用户名
    # IdentityFile ~/.ssh/id_ecdsa # 认证文件
    # Port 22                      # 指定端口
```
那么使用 $ ssh deepzz 就可以直接登录服务器了。

#### 代理登录

有的时候你可能没法直接登录到某台服务器，而需要使用一台中间服务器进行中转，如公司内网服务器。首先确保你已经为服务器配置了公钥访问，并开启了agent forwarding，那么你需要添加如下配置到 ~/.ssh/config：
```
Host gateway
    HostName proxy.example.com
    User root
Host db
    HostName db.internal.example.com                  # 目标服务器地址
    User root                                         # 用户名
    # IdentityFile ~/.ssh/id_ecdsa                    # 认证文件
    ProxyCommand ssh gateway netcat -q 600 %h %p      # 代理命令
```
那么你现在可以使用 $ ssh db 连接了。

#### 远程执行命令

日常情况我们需要到服务器上去执行一些命令或拷贝文件，本来是很简单的一件事情，但做得多了就比较繁琐了。通过 SSH 帮我们远程执行相关命令或脚本，非常棒。

如有不了解的知识点，请阅读前面。利用 SSH 来帮我们在本地执行命令：

1、执行远程命令：
```
$ ssh example "cd /; ls"
bin
boot
data
...
```
2、执行多行命令：  
```
$ ssh example "
dquote> cd / 
dquote> ls
dquote> "
bin
boot
data
...
```
3、执行本地脚本 有时候，我们会将经常用到命令，如将一个复杂命令写入到一个 shell 脚本中，但又不想拷贝到服务器上，那么：
```
# 示例脚本
$ echo "cd /; ls" > test.sh
# 为脚本添加可执行权限
$ chmod +x test.sh
 
# 远程执行本地脚本
$ ssh example < test.sh
Pseudo-terminal will not be allocated because stdin is not a terminal.
bin
boot
data
...
```
4、执行需要交互的命令
```
ssh -t example "top"
```