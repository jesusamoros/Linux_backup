#!/bin/bash
cd /root/Despliegues
#paramos el front
docker stop  front_test
#observamos que archivos queremos restaurar, normalmente nos mostrará el último.
echo "LOS BACKUPS  DISPONIBLES SON LOS SIGUIENTES:"
echo " "
#Va a la host de almacenamiento y nos muestra los backups disponibles
/usr/bin/expect Listar_backups.sh

#Esperamos al usuario que elija el backup a descargar
echo 'INTRODUZCA O COPIE Y PEGUE EL NOMBRE COMPLETO DEL BACKUP QUE DESEA RESTAURAR:'
read var1

echo "DESCARGANDO EL BACKUP SELECCIONADO WAIT . . . "
/usr/bin/expect Downloads_backups.sh $var1
echo " "

cd /
echo "DESCOMPRIMIENDO EN /root/Despliegues/backups"
tar -xzvf /root/Despliegues/backups/$var1
echo "  DESCOMPRIMIDO!!"


echo "COPIANDO EL BACKUP DE MONGO A  /root/Despliegues/mongo/ PARA CREAR EL CONTENEDOR"


cp /root/Despliegues/backups/dump_*.gz   /root/Despliegues/mongo/
cd /root/Despliegues/mongo/ && mv dump_*.gz  dump_restore.gz

docker rm new_mongo -f
docker stop  mongo
echo "creando contenerdor y arrancando"
cd mongo
docker build --no-cache -f  Dockerfile_ . -t  mongo
docker run  -it --network=dgn --ip 172.19.0.3 -d --name new_mongo -v $PWD/volumes/mongo:/etc/mongo  mongo
echo "IMPORTANDO BASE DE DATOS DEL BACKUP"
sleep 1s
docker exec -it new_mongo  /mongorestore.sh

echo " FINALIZADO  CONTENEDOR NEW_MONGO CREADO"
echo " "
sleep 1s
echo " "
echo "ELIMINANDO DIRECTORIO  BACK"
echo " "
cd /root/Despliegues/
rm -rf /root/Despliegues/back
echo "CLONANDO REPOSITORIO"
echo " "
mkdir back
git clone -b develop  https://user@pass@gitlab.com/jesus/back.git
echo "CREANDO NUEVO BACK RESTAURANDO BACKUP"
cd /root/Despliegues/back/
docker stop   /back_test
docker stop /new_back_test
docker rm -v /new_back_test
docker build -f /root/Despliegues/back/Dockerfile . -t new_back_test:last
docker run  -it --network=dgn --ip 172.19.0.2 -d -p 3010:3000 --name new_back_test   new_back_test:last
echo "CONTENERDOR CREADO Y ARRANCADO"
sleep 1s
#moviendo los ficheros descomprimidos del backup y metiendolos en el contendor.
docker cp /root/Despliegues/backups/files new_back_test:/repo/
docker cp /root/Despliegues/backups/uploads new_back_test:/repo/
docker start  front_test
docker ps  |grep "new_"



