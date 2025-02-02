FROM zabbix/zabbix-server-pgsql:ubuntu-6.0-latest

USER root
RUN apt update && \
    apt install -y avahi-utils && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
