#!/bin/bash

FILE=${FILE}
MONGO_HOST=${MONGO_HOST:-mongo}
MONGO_PORT=${MONGO_PORT:-27017}

echo "FTP get"
ncftpget  -u ${FTP_USER} -p ${FTP_PASSWORD} ${FTP_HOST} /${FTP_FOLDER}/$FILE
echo "FTP get ok"
echo "Tar file"
tar zxvf $FILE
echo "Mongorestore"
mongorestore -h $MONGO_HOST -p $MONGO_PORT /dump
echo "Mongorestore OK"
rm -rf /dump
rm $FILE
echo "File delete"