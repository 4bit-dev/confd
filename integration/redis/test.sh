#!/bin/bash

export HOSTNAME="localhost"
PORT=${REDIS_PORT:-6379}

redis-cli -p $PORT set /key foobar
redis-cli -p $PORT set /database/host 127.0.0.1
redis-cli -p $PORT set /database/password p@sSw0rd
redis-cli -p $PORT set /database/port 3306
redis-cli -p $PORT set /database/username confd
redis-cli -p $PORT set /upstream/app1 10.0.1.10:8080
redis-cli -p $PORT set /upstream/app2 10.0.1.11:8080
redis-cli -p $PORT hset /prefix/database host 127.0.0.1
redis-cli -p $PORT hset /prefix/database password p@sSw0rd
redis-cli -p $PORT hset /prefix/database port 3306
redis-cli -p $PORT hset /prefix/database username confd
redis-cli -p $PORT hset /prefix/upstream app1 10.0.1.10:8080
redis-cli -p $PORT hset /prefix/upstream app2 10.0.1.11:8080

confd --onetime --log-level debug --confdir ./integration/confdir --interval 5 --backend redis --node 127.0.0.1:$PORT
if [ $? -ne 0 ]
then
        exit 1
fi

confd --onetime --log-level debug --confdir ./integration/confdir --interval 5 --backend redis --node 127.0.0.1:$PORT/0
if [ $? -ne 0 ]
then
        exit 1
fi
