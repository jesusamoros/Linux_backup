!/bin/bash
#!/usr/bin/expect -f
cd /root/Despliegues
#fecha
fecha=$(date "+%Y-%m-%d")
d=$(date)
echo $d."start backup Diario" >> /root/Despliegues/backup.log
#hacemos backup de mongo
echo "backup mongo y back files"
/usr/bin/docker exec -it new_mongo  ./backupmongo.sh &&  /usr/bin/docker cp new_mongo:/backups  /root/Despliegues

#hacemos backup de backend
/usr/bin/docker cp back_test:/repo/uploads  /root/Despliegues/backups/ && /usr/bin/docker cp back_test:/repo/files  /root/Despliegues/backups/

echo "comprimiendo dir backups"
#comprimimos el directorio de backup
echo "Comprimiendo backups_"$fecha".tar.gz.backup Diario" >> /root/Despliegues/backup.log
tar -czvf backups_$fecha.tar.gz /root/Despliegues/backups

echo "Enviando backup al server ".$d >> /root/Despliegues/backup.log

#echo "llamando a otro script para que envie el backup a la oficina"
/usr/bin/expect /root/Despliegues/envioBackup.sh backups_$fecha.tar.gz
echo "Envio Finalizado".$d >> /root/Despliegues/backup.log
echo " "
