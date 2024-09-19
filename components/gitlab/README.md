GitLab Deployment
-----------------
- 1、Use deploy.sh to deploy gitlab
- 2、then run: sudo docker exec -it gitlab /bin/bash
- 3、edit: vi /etc/gitlab/gitlab.rb with
       external_url "http://0.0.0.0:9080"
       gitlab_rails['gitlab_shell_ssh_port'] = 2424
- 4、save and exit, then run: gitlab-ctl reconfigure
- 5、Got root password: sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
- 6、Access gitlab with localhost:9080

token: YvpLsFnsspv_bh1mFYRu


### 数据迁移：
```
# 停止服务
gitlab-ctl stop
 
# 备份目录
mv /var/opt/gitlab/git-data{,_bak}
 
# 新建新目录
mkdir -p /data/service/gitlab/git-data
 
# 设置目录权限
chown -R git:git /data/service/gitlab
chmod -R 775 /data/service/gitlab
 
# 同步文件，使用rsync保持权限不变
rsync -av /var/opt/gitlab/git-data_bak/repositories /data/service/gitlab/git-data/
 
# 创建软链接
ln -s /data/service/gitlab/git-data /var/opt/gitlab/git-data
 
# 更新权限
gitlab-ctl upgrade
 
# 重新配置
gitlab-ctl reconfigure
 
# 启动
gitlab-ctl start
```

### 权限不足时
```
docker exec -it gitlab update-permissions
```
