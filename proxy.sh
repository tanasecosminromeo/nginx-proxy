#/bin/bash

OWNER_EMAIL=tanasecosminromeo@gmail.com

function create-config(){
  echo "Creating configuration for $1"
  file="/proxy/$1"
  ip=$(head -1 $file)
  additional=$(tail -n +2 $file)

  configuration=$(cat /etc/nginx/snippets/default.conf)

  if [ -f "/etc/letsencrypt/live/$1/fullchain.pem" ]
  then
    https=$(cat /etc/nginx/snippets/default-https.conf)
  	configuration="$configuration\n\n$https"
  else
    mkdir -p /etc/letsencrypt/acme-temp
    certbot certonly --agree-tos --email OWNER_EMAIL --webroot -w /etc/letsencrypt/acme-temp -d $1
  fi
  #create certificate if it doesn't exist


  #replace default values with real ones
  configuration="${configuration//__SERVERHOST__/$1}"
  configuration="${configuration//__SERVERPROXY__/$ip}"
  configuration="${configuration//__SERVERADDITIONAL__/$additional}"

  echo -e "$configuration" > /etc/nginx/conf.d/$1.conf

  if [ -f "/etc/letsencrypt/live/$1/fullchain.pem" ]
  then
    echo "$1 loaded with https"
  else
    echo "Generating https certificate for $1 ... "
    mkdir -p /etc/letsencrypt/acme-temp
    certbot certonly --agree-tos --email OWNER_EMAIL --webroot -w /etc/letsencrypt/acme-temp -d $1

    #re-create configuration, hopefully this time succesfully
    create-config $1
  fi
}

create-config "test-nginx.umnyy.tk"
