#!/bin/bash

# Generate config files from .tmpl templates using environment variables

echo "Generating Nginx config files from templates..."

# Collect all environment variable names for envsubst
VARS=$(printf '${%s} ' $(compgen -v))
echo "$VARS"

# Loop through all .tmpl files in /etc/nginx/sites-enabled
find /etc/nginx/sites-enabled/ -type f -name "*.tmpl" -print0 | while IFS= read -r -d '' template; do
    # Output file path by stripping .tmpl extension
    config="${template%.tmpl}"

    echo "Generating ${config} from ${template}"
    envsubst "$VARS" < "$template" > "$config"
done

echo "Nginx config generation completed."

# Self-signed certification generation
set -e

DOMAIN=${DOMAIN:-localhost}
CERT_PATH="/etc/nginx/certs/${DOMAIN}.pem"

if [ ! -f "$CERT_PATH" ]; then
  echo "🛠  Creating self-signed certificate for $DOMAIN"
  openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout "/etc/nginx/certs/${DOMAIN}.key" \
    -out "/etc/nginx/certs/${DOMAIN}.crt" \
    -subj "/CN=${DOMAIN}" \
    -days 365

  cat "/etc/nginx/certs/${DOMAIN}.crt" "/etc/nginx/certs/${DOMAIN}.key" > "$CERT_PATH"
  rm "/etc/nginx/certs/${DOMAIN}.crt" "/etc/nginx/certs/${DOMAIN}.key"

fi

nginx -g "daemon off;"