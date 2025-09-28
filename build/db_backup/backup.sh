#!/bin/sh
set -e

DATE=$(date +%Y-%m-%d)
BACKUP_FILE="/backups/db_backup_$DATE.sql"

echo "[$(date)] Starting backup..."

# Use mariadb-dump instead of mysqldump and add proper authentication
mariadb-dump --host=$MYSQL_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD --single-transaction --routines --triggers $MYSQL_DATABASE > $BACKUP_FILE

echo "[$(date)] Backup saved to $BACKUP_FILE"

# Delete backups older than 5 days
find /backups -type f -name "*.sql" -mtime +5 -exec rm {} \;

echo "[$(date)] Old backups deleted."