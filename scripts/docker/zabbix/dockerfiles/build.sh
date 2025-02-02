docker build -t zabbix-server-pgsql:ubuntu-6.0-latest -f ZabbixServer.dockerfile .
docker build -t zabbix-web-nginx-pgsql:ubuntu-6.0-latest -f ZabbixWeb.dockerfile .
