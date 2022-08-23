JupyterLab远程访问配置方法

下载 Anaconda3安装包，并执行安装命令：

bash Anaconda3-2019.07-Linux-x86_64.sh
确定安装并初始化：

Do you wish the installer to initialize Anaconda3
by running conda init? [yes|no]
[no] >>> yes
安装完Anaconda3后用conda命令安装jupyterlab：

conda install jupyterlab
需要用ipython命令生成秘钥，启动ipython：

ipython
执行命令生成秘钥：

In [1]: from notebook.auth import passwd
In [2]: passwd() 
Enter password: 
Verify password: 
Out[2]: ‘sha1:f704b702aea2:01e2bd991f9c7208ba177b46f4d10b6907810927‘
产生jupyterlab配置文件：

jupyter lab --generate-config
修改配置文件：

vi /root/.jupyter/jupyter_notebook_config.py
更改内容如下：

# 将ip设置为*，意味允许任何IP访问
c.NotebookApp.ip = ‘*‘
# 这里的密码就是上边我们生成的那一串
c.NotebookApp.password = ‘sha1:f704b702aea2:01e2bd991f9c7208ba177b46f4d10b6907810927‘ 
# 服务器上并没有浏览器可以供Jupyter打开 
c.NotebookApp.open_browser = False 
# 监听端口设置为8888或其他自己喜欢的端口 
c.NotebookApp.port = 8888
# 允许远程访问 
c.NotebookApp.allow_remote_access = True
接下来输入jupyter lab启动jupyter服务即可：

jupyter lab --allow-root


打开页面查看：

分享图片

直接点击“Log in”登录主界面：

分享图片

解释：Ipython把输入的密码转换成sha，并用于认证JupyterLab，本文在Ipython输入密码和确认密码时直接回车，相当于不设密码，因此登录JupyterLab时可以不输入密码直接点击登录。

