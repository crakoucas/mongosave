FROM mongo:3.5
MAINTAINER Rousset Renaud <renaud@crakoucas.ovh>

RUN apt-get update && apt-get install -y ncftp curl cron

COPY /src/* /app/

RUN chmod +x /app/app.sh
RUN chmod +x /app/slack.sh
RUN chmod +x /app/start.sh
RUN chmod +x /app/restore.sh

WORKDIR /app
CMD [ "/app/start.sh" ]