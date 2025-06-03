#!/bin/bash
set -e

mkdir -p config/authority
cd config/authority

# Create CA key and cert
openssl genrsa -aes256 -out auth-ca.key 4096
openssl req -x509 -new -nodes -key auth-ca.key -sha256 -days 1826 -out auth-ca.crt

# Create ZPR RSA keypair for signing policies
openssl genrsa -out zpr-rsa-key.pem 2048
openssl req -new -key zpr-rsa-key.pem -out zpr.csr

cat > sign.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = DNS:zpr.local
EOF

openssl x509 -req -in zpr.csr -CA auth-ca.crt -CAkey auth-ca.key -CAcreateserial \
  -out zpr-rsa.crt -days 1825 -sha256 -extfile sign.ext

cd ../..

echo "Generating NOISE keys and SAN certificates..."
override_file="docker-compose.override.yml"
echo "version: '3.9'" > $override_file
echo "services:" >> $override_file

for dir in $(find config -type f -name "*.toml" -exec dirname {} \; | sort -u); do
  name=$(basename "$dir")
  keyfile="$dir/${name}-noise.key"
  certfile="$dir/${name}-noise.crt"
  pubfile="$dir/${name}-noise-pub.pem"
  signext="$dir/sign.ext"

  echo "  $name:" >> $override_file
  echo "    extra_hosts:" >> $override_file

  for peer_dir in $(find config -type f -name "*.toml" -exec dirname {} \; | sort -u); do
    peer_name=$(basename "$peer_dir")
    if [[ "$peer_name" != "$name" ]]; then
      case $peer_name in
        nodeA) ip="172.28.0.2";;
        nodeB) ip="172.28.0.3";;
        nodeC) ip="172.28.0.4";;
        visa) ip="172.28.0.10";;
        adapter-visa) ip="172.28.0.11";;
        *) ip="172.28.0.99";;
      esac
      echo "      - \"$peer_name.zpr:$ip\"" >> $override_file
    fi
  done

  ./bin/zpr-pki genkey > "$keyfile"
  ./bin/zpr-pki pubkey < "$keyfile" > "$pubfile"

  cat > "$signext" <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = DNS:${name}.zpr
EOF

  ./bin/zpr-pki gensignedcert config/authority/auth-ca.crt config/authority/auth-ca.key \
    /CN=${name}.zpr 365 < "$pubfile" > "$certfile"
done

echo "docker-compose.override.yml has been generated with appropriate extra_hosts."

