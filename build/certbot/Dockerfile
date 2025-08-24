FROM certbot/certbot:latest

# Install any extra tools you might want for debugging/automation
RUN apk add --no-cache bash curl

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/certbot

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]