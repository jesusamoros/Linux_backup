#!bin/bash
cd mongo
docker rm new_mongo -f

echo "creando contenerdor y arrancando"
docker build --no-cache -f  Dockerfile_ . -t  mongo
docker run  -it --network=dgn --ip 172.19.0.3 -d --name new_mongo -v $PWD/volumes/mongo:/etc/mongo  mongo
docker exec -it new_mongo  /importdb.sh

#importdb.sh this is a script on container docker you can see con script import/export MONGO docker

