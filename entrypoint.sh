#!/bin/bash

cd /

mkdir secrets

echo -e "$1" > /secrets/server.pem

echo -e "$2" > /secrets/server.key

echo "server {
  listen 443 ssl;
  ssl_certificate /secrets/server.pem;
  ssl_certificate_key /secrets/server.key;
  location $3 {
    proxy_redirect off;
    proxy_pass http://127.0.0.1:$4;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_connect_timeout 60s;
    proxy_read_timeout 86400s;
    proxy_send_timeout 60s;
  }
}" > /etc/nginx/conf.d/v2ray.conf

echo "{
  \"inbounds\": [
    {
      \"port\": $4,
      \"protocol\": \"vmess\",
      \"settings\": {
        \"clients\": [
          {
            \"id\": \"$5\",
            \"alterId\": 0
          }
        ]
      },
      \"streamSettings\":{
        \"network\": \"ws\",
        \"wsSettings\": {
          \"path\": \"$3\"
        }
      }
    }
  ],
  \"outbounds\": [
    {
      \"protocol\": \"freedom\",
      \"settings\": {}
    }
  ]
}" > /v2ray-linux-64/config.json

nginx

cloudflared service install $6

/v2ray-linux-64/v2ray
