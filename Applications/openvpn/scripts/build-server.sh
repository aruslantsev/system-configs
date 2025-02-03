PATH="~/ca/easy-rsa:$PATH"
EASYRSA_HOME=~/ca/easy-rsa

WORKDIR=${PWD}
cd ${EASYRSA_HOME} || exit 1

echo Setting variables
cat > ${EASYRSA_HOME}/vars << EOF
set_var EASYRSA_ALGO "ec"
set_var EASYRSA_DIGEST "sha512"
EOF

echo Removing old CA
if [ -d ${WORKDIR}/server ] || [ -d ${EASYRSA_HOME}/pki ]; then
	while true; do
		read -p "Do you want to remove old CA? (y/n) " yn
		case $yn in
			[yY] ) echo ok, we will proceed;
				break;;
			[nN] ) echo exiting...;
				exit;;
			* ) echo invalid response;;
		esac
	done
fi
rm -rf ${WORKDIR}/server
rm -rf ${EASYRSA_HOME}/pki
rm -f ${EASYRSA_HOME}/ta.key
mkdir ${WORKDIR}/server


echo Initializing PKI and creating CA
easyrsa init-pki || exit 1
easyrsa build-ca || exit 1

echo Generating server keys
easyrsa gen-req server nopass || exit 1
easyrsa sign-req server server || exit 1

echo Generating TA key
openvpn --genkey secret ${EASYRSA_HOME}/ta.key || exit 1

echo Copying files
cp ${EASYRSA_HOME}/pki/ca.crt ${WORKDIR}/server/ || exit 1
cp ${EASYRSA_HOME}/pki/issued/server.crt ${WORKDIR}/server/ || exit 1
cp ${EASYRSA_HOME}/pki/private/server.key ${WORKDIR}/server/ || exit 1
cp ${EASYRSA_HOME}/ta.key ${WORKDIR}/server/ || exit 1

echo Done

cd ${WORKDIR}
