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