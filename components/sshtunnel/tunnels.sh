#!/usr/bin/env bash

IP_PORTS=(
"8089:10.167.168.61:8089"
"8443:10.167.168.61:8443"
)

function connect(){
    for ipport in ${IP_PORTS[*]}
    do
        echo "Build the channel to $ipport"
        pkill -f "$ipport"
        sshpass -p 10530022 ssh -C -f -N -g -L $ipport modongsong@10.123.3.105
    done
}

connect
