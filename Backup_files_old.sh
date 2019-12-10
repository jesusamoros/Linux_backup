#!/bin/bash
#ejecutar el script en el directorio donde esten los archivos a buscar para que sea mas efectivo o poner la ruta.
#execute this script on your directory, its more eficient
d=$(date +'%e_%b_%Y')
host='remoteIP'
echo "Creando directorio"
mkdir $d.backup

echo "Buscando archivos con antiguedad de mas de 10 dias y comprimiendo"
#La extensión que se busca es *.log aunque puedes cambiarlo.
#This find search *.log  you can change this 
find . -name '*.log' -type f -mtime +10 -exec gzip -9 {} \;find . -name '*.log' -type f -mtime +10 -exec gzip -9 {} \;

echo "Moviendo"
#move files
mv  *.gz  $d.backup/

echo "Comprimiendo el directorio de backups"
#compressing dir
tar -czvf $d.logs.tar.gz $d.backup/

echo "Enviando el backup a una maquina remota"
#sending backup to remote server
scp -P62500  $d.logs.tar.gz root@$host:/root


