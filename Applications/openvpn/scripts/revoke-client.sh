PATH="~/ca/easy-rsa:$PATH"
EASYRSA_HOME=~/ca/easy-rsa

WORKDIR=${PWD}

cd ${EASYRSA_HOME} || exit 1

easyrsa revoke ${1} || exit 1
easyrsa gen-crl || exit 1

cp ${EASYRSA_HOME}/easy-rsa/pki/crl.pem ${WORKDIR}/server/ || exit 1

cd ${WORKDIR}
