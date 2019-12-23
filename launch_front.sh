#!/bin/bash

echo "Eliminando directorio FRONT, parando docker back y eliminando contenerdor"
echo " "
rm -rf /root/Despliegues/front

docker stop /front_test
docker rm -v /front_test
echo "!!!!finalizado!!!"
echo " "
sleep 1s
echo "clonando repo"
git clone -b production  https://user:pass@gitlab.com/urlfiles.git
cd front/
echo "creando contenerdor y arrancando"
docker build -f /root/Despliegues/front/Dockerfile . -t front_test:last
docker run -d -p 8090:8080 --name front_test  front_test:last
echo " "
echo "Contenedor creado y arrancado."
