
#!/bin/bash
set -e

CRON_SCHEDULE=${CRON_SCHEDULE:-0 2 * * *}
export MONGO_HOST=${MONGO_HOST:-mongo}
export MONGO_PORT=${MONGO_PORT:-27017}


if [[ "$1" == 'no-cron' ]]; then
    exec /app/app.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="MONGO_HOST='$MONGO_HOST'"
    CRON_ENV="$CRON_ENV\nMONGO_PORT='$MONGO_PORT'"
    CRON_ENV="$CRON_ENV\nMONGO_USER=${MONGO_USER}"
    CRON_ENV="$CRON_ENV\nMONGO_PASSWORD=${MONGO_PASSWORD}"
    CRON_ENV="$CRON_ENV\nMONGO_DATABASE=${MONGO_DATABASE}"
    CRON_ENV="$CRON_ENV\nFTP_FOLDER=${FTP_FOLDER}"
    CRON_ENV="$CRON_ENV\nFTP_USER=${FTP_USER}"
    CRON_ENV="$CRON_ENV\nFTP_HOST=${FTP_HOST}"
    CRON_ENV="$CRON_ENV\nFTP_PASSWORD=${FTP_PASSWORD}"
    CRON_ENV="$CRON_ENV\nSLACK_WEBHOOK=${SLACK_WEBHOOK}"

    echo -e "$CRON_ENV\n$CRON_SCHEDULE /app/app.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
fi