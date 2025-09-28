FROM debian:bookworm-slim

# Install MySQL client and cron
RUN apt-get update && \
    apt-get install -y default-mysql-client cron && \
    rm -rf /var/lib/apt/lists/*

# Create backup folder
RUN mkdir -p /backups

# Copy backup script and cron schedule into the container
COPY backup.sh /usr/local/bin/backup.sh
COPY crontab.txt /etc/crontabs/root

# Make backup script executable
RUN chmod +x /usr/local/bin/backup.sh

# Run cron in foreground (Docker requirement)
CMD ["crond", "-f", "-l", "2"]