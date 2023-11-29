GREEN='\033[0;32m'
WHITE='\033[0m'

mkdir DIRECTORY/certs DIRECTORY/crl DIRECTORY/newcerts DIRECTORY/private
chmod 700 DIRECTORY/private
touch DIRECTORY/index.txt
echo 1000 > DIRECTORY/serial

echo > /dev/tty
echo -e "${GREEN}CREATING ROOT CA PRIVATE KEY:" > /dev/tty
echo -e "${WHITE}" > /dev/tty

openssl genrsa -aes256 -out DIRECTORY/private/CA_NAME.key.pem 4096
chmod 400 DIRECTORY/private/CA_NAME.key.pem

echo > /dev/tty
echo -e "${GREEN}SIGNING SELF-SIGNED ROOT CA CERTIFICATE:" > /dev/tty
echo -e "${WHITE}" > /dev/tty

openssl req -config DIRECTORY/openssl.cnf \
      -key DIRECTORY/private/CA_NAME.key.pem \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out DIRECTORY/certs/CA_NAME.cert.pem

openssl x509 -noout -text -in DIRECTORY/certs/CA_NAME.cert.pem
