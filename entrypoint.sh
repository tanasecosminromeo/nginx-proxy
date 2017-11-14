#!/bin/bash

echo "Start Cron"
cron

echo "Start Nginx"
service nginx start

echo "Try to Renew Nginx Certificates"
certbot renew

while true
do
        inotifywait --exclude .swp -e create -e modify -e delete -e move /etc/nginx/conf.d
        nginx -t
        if [ $? -eq 0 ]
        then
                echo "Reloading Nginx Configuration"
                service nginx reload
        fi
done