
#!/usr/bin/expect -f

set file [lindex $argv 0];
spawn scp -P6666  $file  User@url_Destino:/home/Ruta_destino
expect "password:"
send elPassDelDestino\n;
expect eof
