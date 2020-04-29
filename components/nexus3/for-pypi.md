## 使用 Nexus 搭建 PyPi 私服及上传

### Nexus Repository Manager OSS 3.x
安装
https://www.sonatype.com/nexus-repository-oss 下载，解压，运行即可

执行启动命令
cd /home/soft/nexus-3.10.0-04-unix/nexus-3.10.0-04/bin
./nexus start
然后访问 http://localhost:8081/#browse/welcome

### PyPi 支持
默认登录用户名/密码： admin/admin123 官方文档地址： https://books.sonatype.com/nexus-book/reference3/pypi.html

### 配置pypi的仓库
简单讲：

建立官方代理仓库 mypypi

填写远程索引地址时用 https://pypi.python.org/ ， 不要用 https://pypi.python.org/pypi .

建立 hosted 仓库，用于内部使用 mypypi-hosted

建立 group 仓库把官方代理和 hosted 仓库包含进来 mypypi-group

其中：代理库的代理配置，也可以换成阿里云的地址：http://mirrors.aliyun.com/pypi，更适合中国国情。

总共三个仓库：



代理仓库的配置：



使用
到 http://localhost:8081/#admin/repository/repositories 找到自己的仓库，点进去copy仓库的url

在客户端使pip安装

注意：要在仓库地址后面加/simple

pip install flask -i http://localhost:8081/repository/mypypi/simple
访问 http://localhost:8081/#browse/search/pypi 就能查到从官方仓库下载下的模块

上传模块
上传配置
在用户根目录下添加.pypirc文件，添加如下配置：

[distutils]
index-servers =
    pypi
    pypitest
    nexus
    nexustest
 
[pypi]
repository:https://pypi.python.org/pypi
username:your_username
password:your_password
 
[pypitest]
repository:https://testpypi.python.org/pypi
username:your_username
password:your_password
 
# 要选择所建三个仓库中的hosted仓库
[nexus]
repository=http://192.168.12.196:8081/repository/mypypi-hosted/
username=your_username
password=your_password
 
[nexustest]
repository=http://192.168.12.196:8081/repository/mypypi-hosted/
username=your_username
password=your_password
 
安装python的twine包

pip install twine
先打包本地项目 主要是两步，打包、发布

参照官方文档：

setup规范 https://packaging.python.org/tutorials/distributing-packages/#setup-py
twine使方法 https://pypi.org/project/twine/
我的setup.py配置

# coding=utf-8
from setuptools import setup
 
setup(
    name='BaseSpiders',  # 应用名
    version='1.0',  # 版本号
    author="codePande",
    author_email="619490291@qq.com",
    description="封装的基础爬虫",
    long_description=open("README.md").read(),
    license="MIT",
    url="https://github.com/xuyuli",
    packages=[
        'baseCrawler',
        'exception',
        'hotupdate',
        'mylogs',
        'queues',
        'utils',
    ],
    install_requires=[
        "pika>=0.11.0",
        "requests>=2.13.0",
        "upyun==2.5.0",
        "pycrypto==2.6.1",
    ],
    classifiers=[
        "Topic :: Utilities",
        "Topic :: Internet",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Programming Language :: Python",
        "Programming Language :: Python :: 2",
        "Programming Language :: Python :: 2.6",
        "Programming Language :: Python :: 2.7",
    ],
)
 
打包命令

python setup.py sdist bdist_wheel
 
上传命令

twine upload -r nexus dist/*  # -r 可以选择仓库地址
在其他python环境使用上次的模块

pip install basespiders -i http://192.168.12.196:8081/repository/mypypi-group/simple --trusted-host 192.168.12.196
注意：下载地址要使用group仓库，后面也要加/simple
