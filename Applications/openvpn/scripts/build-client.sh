PATH="~/ca/easy-rsa:$PATH"
EASYRSA_HOME=~/ca/easy-rsa

if [ ! -d clients ]; then
	mkdir clients
fi

if [ ! -d clients/${2} ]; then
	mkdir clients/${2}
fi

WORKDIR=${PWD}

if [ ! -f clients/${2}/${2}.crt ] && [ ! -f clients/${2}/${2}.key ]; then
	cd ${EASYRSA_HOME} || exit 1
	easyrsa build-client-full $2 nopass || exit 1
	# ./easyrsa gen-req client01 nopass
	# ./easyrsa sign-req client client01

	cd $WORKDIR || exit 1

	cp ${EASYRSA_HOME}/pki/private/${2}.key clients/${2}/ || exit 1
	cp ${EASYRSA_HOME}/pki/issued/${2}.crt clients/${2}/ || exit 1
fi

SRV_ID=$(cut -d '.' -f 1 <<<  $1)

cat ${1} \
    <(echo -e '<ca>') \
    server/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    clients/${2}/${2}.crt \
    <(echo -e '</cert>\n<key>') \
    clients/${2}/${2}.key \
    <(echo -e '</key>\n<tls-crypt>') \
    server/ta.key \
    <(echo -e '</tls-crypt>') \
    > clients/${2}/${2}-${SRV_ID}.ovpn
