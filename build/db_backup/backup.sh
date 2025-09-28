#!/bin/bash
set -e

# Use environment variables passed from docker-compose
: "${MYSQL_HOST:?Need to set MYSQL_HOST}"
: "${MYSQL_USER:?Need to set MYSQL_USER}"
: "${MYSQL_PASSWORD:?Need to set MYSQL_PASSWORD}"
: "${MYSQL_DATABASE:?Need to set MYSQL_DATABASE}"

# Backup folder (mounted from host)
BACKUP_DIR=/backups
mkdir -p "$BACKUP_DIR"

# Filename with date
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/db_backup_$DATE.sql"

echo "[$(date)] Starting backup of $MYSQL_DATABASE..."

# Run the backup
mysqldump --host="$MYSQL_HOST" \
          --user="$MYSQL_USER" \
          --password="$MYSQL_PASSWORD" \
          --single-transaction \
          --routines \
          --triggers \
          "$MYSQL_DATABASE" > "$BACKUP_FILE"

echo "[$(date)] Backup saved to $BACKUP_FILE"

# Delete backups older than 5 days
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +5 -exec rm {} \;

echo "[$(date)] Old backups deleted."
