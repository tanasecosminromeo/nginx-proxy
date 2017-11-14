FROM nginx:latest
MAINTAINER Cosmin-Romeo TANASE <tanasecosminromeo@gmail.com>

### Install Certbot, inotify-tools and cron
RUN DEBIAN_FRONTEND=noninteractive echo deb http://ftp.debian.org/debian jessie-backports main >> /etc/apt/sources.list.d/jessie-backports.list && apt-get -y update && apt-get -y install certbot -t jessie-backports && apt-get -y install inotify-tools cron

### Add the crontab
ADD crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab && touch /var/log/cron.log

### Refresh Nginx when configuration changes
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD /entrypoint.sh
