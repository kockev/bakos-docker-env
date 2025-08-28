#!/bin/bash
set -e

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

DOMAIN=${BACKEND_SERVER_NAME}
echo "Using domain: $DOMAIN"

CERT_KEY="/etc/nginx/certs/${DOMAIN}.key"
CERT_PEM="/etc/nginx/certs/${DOMAIN}.pem"

# Self-signed certification generation
if [ ! -f "$CERT_KEY" ] || [ ! -f "$CERT_PEM" ]; then
  echo "No certificate found, generating self-signed cert for $DOMAIN"
  openssl req -x509 -nodes -newkey rsa:2048 \
     -keyout "$CERT_KEY" \
     -out "$CERT_PEM" \
     -subj "/CN=${DOMAIN}" \
     -days 365
else
  echo "Certificate already exists, skipping self-signed generation"
fi
  
nginx -g "daemon off;"

echo "Certification generation has finished"