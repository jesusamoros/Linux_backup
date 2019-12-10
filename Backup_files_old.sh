#!/bin/bash

d=$(date +'%e_%b_%Y')
host='remoteIP'
echo "Creando directorio"
mkdir $d.backup

echo "Buscando archivos con antiguedad de mas de 10 dias y comprimiendo"
find . -name '*.log' -type f -mtime +10 -exec gzip -9 {} \;find . -name '*.log' -type f -mtime +10 -exec gzip -9 {} \;

echo "Moviendo"
mv  *.gz  $d.backup/

echo "Comprimiendo el directorio de backups"
tar -czvf $d.logs.tar.gz $d.backup/

echo "Enviando el backup a una maquina remota"
scp -P62500  $d.logs.tar.gz root@$host:/root


