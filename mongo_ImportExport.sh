#!/bin/bash

echo "importando base de datos y sus colecciones"
mongoimport  --db Tudb  --collection clients --type json --file clients.json
mongoimport  --db Tudb  --collection files --type json --file  files.json
mongoimport  --db Tudb  --collection projects --type json --file  projects.json
mongoimport  --db Tudb  --collection users --type json --file  users.json

#!/bin/bash
#exportando todo en un fichero
mongodump --db Tudb --gzip --archive > dump_`date "+%Y-%m-%d"`.gz

#!/bin/bash
#Importando desde  un fichero
mongorestore --gzip --archive=/path/to/file.gz --db Tudb


