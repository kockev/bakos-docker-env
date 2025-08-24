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
CERT_PATH="/etc/nginx/certs/${DOMAIN}.pem"

# Self-signed certification generation
if [ "$ENVIRONMENT" != "production" ]; then
    echo "Generating self-signed certificate for $DOMAIN (non-production)"
    if [ ! -f "$CERT_PATH" ]; then
      echo "Creating self-signed certificate for $DOMAIN"
      openssl req -x509 -nodes -newkey rsa:2048 \
        -keyout "/etc/nginx/certs/${DOMAIN}.key" \
        -out "/etc/nginx/certs/${DOMAIN}.crt" \
        -subj "/CN=${DOMAIN}" \
        -days 365

      cat "/etc/nginx/certs/${DOMAIN}.crt" "/etc/nginx/certs/${DOMAIN}.key" > "$CERT_PATH"
      rm "/etc/nginx/certs/${DOMAIN}.crt" "/etc/nginx/certs/${DOMAIN}.key"

    fi
# Certification generation 
else
    echo "Production environment: obtain real certificate with certbot"

    # Start temporary Nginx to serve ACME challenge
    nginx -g "daemon off;" &
    NGINX_PID=$!

    # Wait a few seconds for Nginx to start
    sleep 3

    # Run certbot with webroot
    certbot certonly --webroot \
      -w /var/www/certbot \
      -d "$DOMAIN" \
      -d "www.$DOMAIN" \
      --email admin@$DOMAIN \
      --agree-tos \
      --non-interactive \

    # Stop temporary Nginx
    kill $NGINX_PID
    wait $NGINX_PID 2>/dev/null || true

    # Symlink certs into /etc/nginx/certs just like local self-signed ones
    ln -sf "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "/etc/nginx/certs/${DOMAIN}.pem"
    ln -sf "/etc/letsencrypt/live/$DOMAIN/privkey.pem"   "/etc/nginx/certs/${DOMAIN}.key"

    echo "Starting background certbot renewal loop..."
    (
      while true; do
        certbot renew --quiet --post-hook "nginx -s reload"
        sleep 12h
      done
    ) &

fi

nginx -g "daemon off;"

echo "Certification generation has finished"