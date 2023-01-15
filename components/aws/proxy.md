（1） install and configure squid, 
     acl all src 0.0.0.0/24
     http_access allow all
     cache_log /dev/null
     access_log daemon:/dev/null squid
 (2) build tunnel in localhost with ssh as following:
     ssh -i Tokyo-VPN.pem -N -L2046:localhost:2046 ubuntu@199.199.199.199