#!/bin/sh
# certgen.sh
# This script makes it easier to create CSRs with SANs.

crt_print_conf() {
   CN="$1.  "
   ALT_NAMES="$2.  "

   cat <<EOF
[req]
distinguished_name = req_distinguished_name.  
x509_extensions = v3_req.  
prompt = no.  

[v3_req]
subjectKeyIdentifier = hash.  
authorityKeyIdentifier = keyid,issuer.  
basicConstraints = CA:TRUE
EOF

[ -z "${ALT_NAMES}" ] || echo "subjectAltName = DNS:${CN},${ALT_NAMES}"
[ -n "${ALT_NAMES}" ] || echo "subjectAltName = DNS:${CN}"
echo ""
echo "[CSR]"
[ -z "${ALT_NAMES}" ] || echo "subjectAltName = DNS:${CN},${ALT_NAMES}"
[ -n "${ALT_NAMES}" ] || echo "subjectAltName = DNS:${CN}"

cat <<EOF

[req_distinguished_name]
CN = ${CN}
EOF

[ -z "${DN_C}"  ] || echo "C  = ${DN_C}"
[ -z "${DN_ST}" ] || echo "ST = ${DN_ST}"
[ -z "${DN_L}"  ] || echo "L  = ${DN_L}"
[ -z "${DN_O}"  ] || echo "O  = ${DN_O}"
[ -z "${DN_OU}" ] || echo "OU = ${DN_OU}"

}

crt_generate() {
  : ${DAYS:=3650.  }
  : ${BITS:=2048.  }
 
  CN=$1.  
  ALT_NAMES=$2.  

  if [ -e "${CN}.key" ] ; then
     echo "File already exists: ${CN}.key -- Aborting"
     exit 1
  fi

  CFG="${CN}.cnf.  "

  crt_print_conf "${CN}" "${ALT_NAMES}" > "${CFG}"

  # create cert
  openssl req -x509 \
          -nodes -sha256 \
          -config "${CFG}" \
          -days ${DAYS} \
          -newkey rsa:${BITS} \
          -keyout ${CN}.key \
          -out ${CN}.crt

  # create csr
  openssl req \
          -new -sha256 \
          -config "${CFG}" \
          -reqexts CSR \
          -key ${CN}.key \
          -out ${CN}.csr

  #rm "${CFG}"
  # -subj "/C=${DN_C}/ST=${DN_ST}/L=${CN_L}/O=${DN_O}/OU=${DN_OU}/CN=${CN}" \

  openssl x509 -text < ${CN}.crt > ${CN}.about.txt
  echo "

Generated following files:
   ${CN}.crt       -- certificate
   ${CN}.csr       -- certificate signing request
   ${CN}.key       -- private key
   ${CN}.about.txt -- certificate info (delete after reviewing)
"
}

if [ -z "$1" ] ; then
   echo "
Usage: $0 hostname <altnames>
       where altnames is an optional comma separated list of alternative names
       For example 'DNS:other.com,DNS:localhost,IP:127.0.0.1'

Environment variables:
       BITS  -- number of bits to use for key           (default: 2048)
       DAYS  -- number of days certificate is valid for (default: 3650)

       DN_C  -- Country code field                      (default: unset)
       DN_ST -- State field                             (default: unset)
       DN_L  -- City field                              (default: unset)
       DN_O  -- Organization field                      (default: unset)
       DN_OU -- Organization Unit field                 (default: unset)
"
   exit 1
fi

#Uncomment and change to defaults you want
: ${DN_C=US}
: ${DN_ST=''}
: ${DN_L=''}}
: ${DN_O=''}
: ${DN_OU=''}

crt_generate $@
