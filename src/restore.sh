#!/bin/bash

MONGO_HOST=${MONGO_HOST:-mongo}
MONGO_PORT=${MONGO_PORT:-27017}

read -p 'Nom de la save sur ftp/backup : ' FILE
echo "FTP get"
ncftpget  -u ${FTP_USER} -p ${FTP_PASSWORD} ftp://${FTP_HOST}/${FTP_FOLDER}/$FILE
echo "Tar file"
tar zxvf $FILE
echo "Mongorestore"
mongorestore -h $MONGO_HOST -p $MONGO_PORT -u ${MONGO_USER} -p ${MONGO_PASSWORD} -d ${MONGO_DATABASE}  dump/${MONGO_DATABASE}
echo "Mongorestore OK"
rm -rf dump/
rm $FILE
echo "File delete"
