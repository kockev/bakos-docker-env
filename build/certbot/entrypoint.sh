#!/bin/bash
set -e

trap exit TERM

DOMAIN="bakosdietas.hu"
EMAIL="admin@bakosdietas.hu"
WEBROOT="/var/www/certbot"

echo "Starting Certbot for domain: $DOMAIN"

while true; do
  certbot certonly --webroot -w $WEBROOT \
    -d $DOMAIN -d www.$DOMAIN \
    --email $EMAIL \
    --agree-tos --non-interactive || true

  echo "Certbot run completed. Sleeping for 12h..."
  sleep 12h
done