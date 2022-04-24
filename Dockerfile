FROM ubuntu

EXPOSE 443/tcp

ADD entrypoint.sh /opt/entrypoint.sh

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get install -y wget && \
    apt-get install -y unzip && \
    wget https://github.com/v2fly/v2ray-core/releases/download/v4.44.0/v2ray-linux-64.zip && \
    unzip -o v2ray-linux-64.zip -d v2ray-linux-64 && \
    chmod +x ./v2ray-linux-64/v2ray && \
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared-linux-amd64.deb && \
    chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
