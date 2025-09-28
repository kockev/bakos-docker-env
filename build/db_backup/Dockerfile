From mysql:latest

# Create backup folder
RUN mkdir -p /backups

# Copy backup script and cron schedule into the container
COPY backup.sh /usr/local/bin/backup.sh
COPY crontab.txt /etc/crontabs/root

# Make backup script executable
RUN chmod +x /usr/local/bin/backup.sh

# Run cron in foreground (Docker requirement)
CMD ["crond", "-f", "-l", "2"]