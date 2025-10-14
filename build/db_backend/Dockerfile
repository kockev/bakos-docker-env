FROM mysql:latest

# Copy the backup script
COPY build/db_backend/backup.sh /usr/local/bin/backup.sh

# Make the script executable
RUN chmod +x /usr/local/bin/backup.sh

# Create backup directory
RUN mkdir -p /backups

# Set the default command to start MySQL and then run backup script
CMD ["sh", "-c", "docker-entrypoint.sh mysqld & sleep 30 && /usr/local/bin/backup.sh && wait"]