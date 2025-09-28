FROM alpine:latest

# Install MySQL client, bash, coreutils, and cron
RUN apk add --no-cache mysql-client bash coreutils tzdata

# Set timezone if needed (default UTC)
ENV TZ=UTC

# Create backup folder
RUN mkdir -p /backups

# Copy backup script and cron schedule into the container
COPY backup.sh /usr/local/bin/backup.sh
COPY crontab.txt /etc/crontabs/root

# Make backup script executable
RUN chmod +x /usr/local/bin/backup.sh

# Run cron in foreground (Docker requirement)
CMD ["crond", "-f", "-l", "2"]