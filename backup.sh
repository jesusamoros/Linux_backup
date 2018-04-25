#!/bin/bash
#backup linux system and upload ftp to windows servers
cd /backup/

#delete file 
rm -rf /backup/*-wifibackup.tgz.iso

#Date
fecha=$(date +"%m-%d-%Y.%T")
#log date
echo $fecha >> /backup/log.txt

#stop services
/bin/systemctl stop mysqld.service >> /backup/log.txt
/bin/systemctl stop httpd.service >> /backup/log.txt
/bin/systemctl stop nginx.service >> /backup/log.txt
printf "Stop Servicios\n" >> /backup/log.txt

#sms sistem
dt=$(date +%d.%m.%y)
printf "Start backup\n" >> /backup/log.txt
#backup file
tar cvpzf /backup/$dt-wifibackup.tgz --exclude=/proc --exclude=/lost+found --exclude=/backup  --exclude=/home/backup --exclude=/mnt --exclude=/sys /
printf "Finish backup\n" >> /backup/log.txt

#start services 
/bin/systemctl restart mysqld.service >> /backup/log.txt
/bin/systemctl restart httpd.service >> /backup/log.txt
/bin/systemctl restart nginx.service >> /backup/log.txt
printf "Servicios Start\n"  >> /backup/log.txt

printf "Send backup to Ftp\n"  >> /backup/log.txt
#rename backup for upload ()
mv /backup/$dt-wifibackup.tgz /backup/$dt-wifibackup.tgz.iso
ftp -inv  acount.ftp.windows.server <<FINFTP >> /backup/log.txt

        user User pass
        binary
        prompt
        lcd /backup
        put  $dt-backup.tgz.iso
        bye

 FINFTP

printf "Finish file is uploaded\n" >> /backup/log.txt
