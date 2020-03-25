#!/usr/bin/env bash
set -e

ADMIN_PASSWORD="$(cat /dev/urandom | base64 | head -c 20)"
echo "Admin Password will be '$ADMIN_PASSWORD'"
echo -e "${ADMIN_PASSWORD}\n${ADMIN_PASSWORD}" | jupyter notebook password
mkdir -p /etc/ssl/jupyter-certs
openssl req -x509 -nodes -newkey rsa:4096 -keyout /etc/ssl/jupyter-certs/jupyter.key -out /etc/ssl/jupyter.pem -config - <<EOF
[ req ]
default_bits       = 4096
default_md         = sha512
default_keyfile    = key.pem
prompt             = no
encrypt_key        = no

# base request
distinguished_name = req_distinguished_name

# extensions
req_extensions     = v3_req

# distinguished_name
[ req_distinguished_name ]
countryName            = "DE"                     # C=
stateOrProvinceName    = "Hamburg"                 # ST=
localityName           = "Bei Knoepis"                 # L=
postalCode             = "20175"                 # L/postalcode=
streetAddress          = "Geht-dich-nix-an-Allee 12"            # L/street=
organizationName       = "KNOEPPLER"        # O=
organizationalUnitName = "Tobias"          # OU=
commonName             = "learn.knoeppler.org"            # CN=
emailAddress           = "tobias@knoeppler.net"  # CN/emailAddress=

# req_extensions
[ v3_req ]
# The subject alternative name extension allows various literal values to be
# included in the configuration file
# http://www.openssl.org/docs/apps/x509v3_config.html
subjectAltName  = DNS:knoeppler.org,DNS:pyschool.knoeppler.org # multidomain certificate
EOF
