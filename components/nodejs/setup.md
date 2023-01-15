**npm设置国内源（淘宝镜像源）的几种方式，解决下载速度慢的问题**

## 1.说明

刚安装的npm使用默认的源会感觉特别特别慢，所以，非常有必要使用国内的源，比如说众所周知的淘宝镜像源

2.全局设置
查看当前源

npm config get registry
设置为淘宝源

npm config set registry https://registry.npm.taobao.org

还原默认源：npm config set registry https://registry.npmjs.org/

## 3.临时使用

上面那种设置是全局的，以后每次都会自动读取已经设置好的源，如果只是一次性使用，可以使用下面的命令

npm --registry https://registry.npm.taobao.org install XXX（模块名）

## 4.使用cnpm

cnpm是一个命令，用它来代替npm

npm install -g cnpm --regi stry=https://registry.npm.taobao.org
cnpm install XXX(模块名)

5.使用nrm

npm install -g nrm
nrm use taobao
nrm ls  # 查看当前可用源命


设置nvm国内镜像的方法

1.阿里云

设置npm_mirror:
nvm npm_mirror https://npmmirror.com/mirrors/npm/

设置node_mirror:
nvm node_mirror https://npmmirror.com/mirrors/node/
2.腾讯云

设置npm_mirror:
nvm npm_mirror http://mirrors.cloud.tencent.com/npm/

设置node_mirror:
nvm node_mirror http://mirrors.cloud.tencent.com/nodejs-release/
