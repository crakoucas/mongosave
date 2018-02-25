#!/bin/bash

# array with domains
NAMES=("Luke" "C-3PO" "R2-D2" "Darth Vader" "Obi-Wan Kenobi")
# seed random generator
RANDOM=$$$(date +%s)

# pick a random entry from the domain list to check against
NAMES=${NAMES[$RANDOM % ${#NAMES[@]}]}


echo "Début de la Sauvegarde"
DATE=$(date +%Y%m%d_%H%M%S)

MONGO_HOST=${MONGO_HOST:-localhost}
MONGO_PORT=${MONGO_PORT:-27017}

mongodump -h $MONGO_HOST -p $MONGO_PORT -u ${MONGO_USER} -p ${MONGO_PASSWORD} -d ${MONGO_DATABASE}

tar zcvf save$DATE.tar.gz dump/
rm -rf dump/
echo "FTP send"
ncftpput  -u ${FTP_USER} -p ${FTP_PASSWORD} ${FTP_HOST} /${FTP_FOLDER} save$DATE.tar.gz
echo "Fin de la sauvegarde"
rm save$DATE.tar.gz
echo "Message to slack"
/app/slack.sh ${SLACK_WEBHOOK} "#save" "$NAMES Backup" "La sauvegarde save$DATE.tar.gz mongoDB a été faite le $DATE"