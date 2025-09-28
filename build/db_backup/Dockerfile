FROM debian:bookworm-slim

# Install MySQL client and cron
RUN apt-get update && \
    apt-get install -y default-mysql-client cron && \
    rm -rf /var/lib/apt/lists/*

# Create backup folder
RUN mkdir -p /backups

# Copy backup script and cron schedule into the container
COPY backup.sh /usr/local/bin/backup.sh
COPY crontab.txt /etc/cron.d/db_backup

# Make script executable and cron file readable
RUN chmod +x /usr/local/bin/backup.sh
RUN chmod 0644 /etc/cron.d/db_backup

# Apply the cron job
RUN crontab /etc/cron.d/db_backup

# Run cron in foreground (Docker requirement)
CMD ["cron", "-f"]