#!/bin/bash
set -e

DOMAIN=${BACKEND_SERVER_NAME}
EMAIL="admin@${DOMAIN}"
CERT_DIR="/etc/letsencrypt/live/${DOMAIN}"
NGINX_CERT_DIR="/etc/nginx/certs"

# Ensure cert directories exist
mkdir -p /var/www/certbot "$NGINX_CERT_DIR"

echo "=== Starting Certbot container for $DOMAIN ==="

# Loop forever, renewing every 12h
while :; do
  echo ">>> Requesting/Renewing certificates for $DOMAIN ..."

  certbot certonly --webroot \
    -w /var/www/certbot \
    -d "$DOMAIN" -d "www.$DOMAIN" \
    --email "$EMAIL" \
    --agree-tos \
    --non-interactive || true

  # If certs exist, create/update symlinks for Nginx
  if [ -d "$CERT_DIR" ]; then
    echo ">>> Creating symlinks in $NGINX_CERT_DIR"
    ln -sf "$CERT_DIR/fullchain.pem" "$NGINX_CERT_DIR/${DOMAIN}.pem"
    ln -sf "$CERT_DIR/privkey.pem"   "$NGINX_CERT_DIR/${DOMAIN}.key"
  else
    echo "!!! Certificate directory $CERT_DIR not found (certbot may have failed)"
  fi

  echo ">>> Sleeping 24h before next renewal check..."
  sleep 24h
done
