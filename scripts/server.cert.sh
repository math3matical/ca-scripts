GREEN='\033[0;32m'
WHITE='\033[0m'

echo > /dev/tty
echo -e "${GREEN}CREATING SERVER CERTIFICATE PRIVATE KEY" > /dev/tty
echo "  (NOTE, NO PASSWORD USED HERE):" > /dev/tty
echo -e "${WHITE}" > /dev/tty

openssl genrsa \
      -out DIRECTORY/INT_NAME/private/SRV_FQDN.key.pem 2048

chmod 400 DIRECTORY/INT_NAME/private/SRV_FQDN.key.pem

openssl req -config DIRECTORY/INT_NAME/SRV_FQDN.openssl.cnf \
      -key DIRECTORY/INT_NAME/private/SRV_FQDN.key.pem \
      -new -sha256 -out DIRECTORY/INT_NAME/csr/SRV_FQDN.csr.pem

echo > /dev/tty
echo -e "${GREEN}SIGNING SERVER CERTIFICATE" > /dev/tty
echo "  (NOTE, USE THE INTERMEDIATE CA PRIVATE KEY):" > /dev/tty
echo -e "${WHITE}" > /dev/tty

openssl ca -config DIRECTORY/INT_NAME/SRV_FQDN.openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in DIRECTORY/INT_NAME/csr/SRV_FQDN.csr.pem \
      -out DIRECTORY/INT_NAME/certs/SRV_FQDN.cert.pem


chmod 444 DIRECTORY/INT_NAME/certs/SRV_FQDN.cert.pem

openssl x509 -noout -text \
      -in DIRECTORY/INT_NAME/certs/SRV_FQDN.cert.pem

openssl verify -CAfile DIRECTORY/INT_NAME/certs/ca-bundle.cert.pem \
      DIRECTORY/INT_NAME/certs/SRV_FQDN.cert.pem

echo "" > /dev/tty
echo -e "${GREEN}SERVER CERTIFICATE:" > /dev/tty
echo "  DIRECTORY/INT_NAME/certs/SRV_FQDN.cert.pem" > /dev/tty
echo "" > /dev/tty
echo "SERVER PRIVATE KEY:" > /dev/tty
echo "  DIRECTORY/INT_NAME/private/SRV_FQDN.key.pem" > /dev/tty
echo "" > /dev/tty
echo "CA BUNDLE:" > /dev/tty
echo "  DIRECTORY/INT_NAME/certs/ca-bundle.cert.pem" > /dev/tty
echo "" > /dev/tty

echo "VERIFY SERVER CERTIFICATE WITH BUNDLE:" > /dev/tty
echo "  openssl verify -verbose -CAfile DIRECTORY/INT_NAME/certs/ca-bundle.cert.pem DIRECTORY/INT_NAME/certs/SRV_FQDN.cert.pem" > /dev/tty
