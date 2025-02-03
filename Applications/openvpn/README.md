OpenVPN
=========

Setup openvpn server

Requirements
------------

Works only on debian-like systems. Network interface should have a name eth0. It should be renamed 
or patches/ufw-before-rules.patch should be changed

1. Build CA:

- Create directory ~/ca/easyrsa
- Create symbolic links to easyrsa, openssl-easyrsa.cnf, x509-types inside ~/ca/easyrsa
- Copy scripts/build-server.sh to ~/ca
- Change directory to ~/ca and run build-server.sh

2. Generate keys for the clients:

- Copy scripts/build-client.sh to ~/ca
- Copy configs/client.conf to ~/ca
- Edit ~/ca/client.conf and change my-server-1 to fqdn/ip address in the line `remote my-server-1 1194`
- Change directory to ~/ca
- Run build-client.sh client.conf client-name

3. Revoke keys (untested)

- Copy scripts/revoke-client.sh to ~/ca
- Change directory to ~/ca
- Run revoke-client.sh client-name
- Manually copy ~/ca/server/crl.pem to /etc/openvpn/server on the server
- Uncomment line in client.conf to use crl

4. Install openvpn:

- install patch, easyrsa, openvpn, ufw
- copy files from ~/ca/server (step 2) to /etc/openvpn/server
- copy configs/server.conf to /etc/openvpn/server
- set net.ipv4.ip_forward=1 via sysctl
- allow 1194/udp
- patch /etc/ufw/before.rules using patches/ufw-before-rules.patch
- patch /etc/default/ufw using patches/ufw-forward-accept.patch
- start openvpn-server@server
