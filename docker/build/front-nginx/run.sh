#!/bin/bash

cd certs

openssl genrsa -out default.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=HPUOJ/OU=HPUOJ/CN=*.hpuoj.com" \
    -key default.key \
    -out default.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=*.hpuoj.com
DNS.2=localhost
DNS.3=cn-hn-dx-1.natfrp.cloud
DNS.4=cn-hn-dx-2.natfrp.cloud
IP.1=10.14.19.3
IP.2=127.0.0.1
IP.3=219.150.218.20
IP.4=123.160.10.39
EOF

openssl x509 -req -sha512 -days 365 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in default.csr \
    -out default.crt

openssl x509 -inform PEM -in default.crt -out default.cert
