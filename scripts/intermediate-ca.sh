GREEN='\033[0;32m'
WHITE='\033[0m'

mkdir DIRECTORY/INT_NAME/

mkdir DIRECTORY/INT_NAME/certs DIRECTORY/INT_NAME/crl DIRECTORY/INT_NAME/csr DIRECTORY/INT_NAME/newcerts DIRECTORY/INT_NAME/private
chmod 700 DIRECTORY/INT_NAME/private
touch DIRECTORY/INT_NAME/index.txt
echo 1000 > DIRECTORY/INT_NAME/serial
echo 1000 > DIRECTORY/INT_NAME/crlnumber

echo > /dev/tty
echo -e "${GREEN}CREATING INTERMEDIATE CA PRIVATE KEY:" > /dev/tty
echo -e "${WHITE}" > /dev/tty

openssl genrsa -aes256 \
      -out DIRECTORY/INT_NAME/private/INT_NAME.key.pem 4096
chmod 400 DIRECTORY/INT_NAME/private/INT_NAME.key.pem

echo > /dev/tty
echo -e "${GREEN}CREATING INTERMEDIATE CSR" > /dev/tty
echo "  (NOTE, USE THE INTERMEDIATE PRIVATE KEY)" > /dev/tty
echo -e "${WHITE}" > /dev/tty

openssl req -config DIRECTORY/INT_NAME/INT_NAME.openssl.cnf -new -sha256 \
      -key DIRECTORY/INT_NAME/private/INT_NAME.key.pem \
      -out DIRECTORY/INT_NAME/csr/INT_NAME.csr.pem

echo > /dev/tty
echo -e "${GREEN}SIGNING INTERMEDIATE CA CERTIFICATE" > /dev/tty
echo "  (NOTE, USE THE ROOT CA PRIVATE KEY PASSWORD):" > /dev/tty
echo -e "${WHITE}" > /dev/tty

openssl ca -config DIRECTORY/openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in DIRECTORY/INT_NAME/csr/INT_NAME.csr.pem \
      -out DIRECTORY/INT_NAME/certs/INT_NAME.cert.pem

chmod 444 DIRECTORY/INT_NAME/certs/INT_NAME.cert.pem

openssl x509 -noout -text \
      -in DIRECTORY/INT_NAME/certs/INT_NAME.cert.pem

openssl verify -CAfile DIRECTORY/certs/CA_NAME.cert.pem \
      DIRECTORY/INT_NAME/certs/INT_NAME.cert.pem

cat DIRECTORY/INT_NAME/certs/INT_NAME.cert.pem \
      DIRECTORY/certs/CA_NAME.cert.pem > DIRECTORY/INT_NAME/certs/ca-bundle.cert.pem

chmod 444 DIRECTORY/INT_NAME/certs/ca-bundle.cert.pem
