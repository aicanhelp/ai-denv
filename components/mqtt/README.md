docker pull eclipse-mosquitto:2.0.15

创建用户
# 使用exec 连接容器进行创建，会提示创建自定义密码
docker exec -it mqtt sh -c "mosquitto_passwd -c /mosquitto/config/passwd   自定义用户名"

# 重新加载配置文件
docker exec -it mqtt sh -c "kill -s HUP 1"

# 删除某个用户
docker exec -it mqtt sh -c "mosquitto_passwd -D mosquitto/config/passwd   某个用户名"


# 发布消息：mosquitto_pub -h 0.0.0.0 -p 1883  -t test -m "1,2,3,4" 
# 订阅消息：mosquitto_sub -h 0.0.0.0 -p 1883  -t test 
