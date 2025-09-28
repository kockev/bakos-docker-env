#!/bin/sh
set -e

DATE=$(date +%Y-%m-%d)
BACKUP_FILE="/backups/db_backup_$DATE.sql"

echo "[$(date)] Starting backup..."

mysqldump --host=$MYSQL_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD --skip-ssl --single-transaction --routines --triggers $MYSQL_DATABASE > $BACKUP_FILE

echo "[$(date)] Backup saved to $BACKUP_FILE"

# Delete backups older than 5 days
find /backups -type f -name "*.sql" -mtime +5 -exec rm {} \;

echo "[$(date)] Old backups deleted."