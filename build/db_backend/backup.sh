BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Create the backup
mysqldump -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "$(date): Backup created successfully: $BACKUP_FILE"
else
    echo "$(date): Backup failed!"
    exit 1
fi

# Clean up backups older than 5 days
find $BACKUP_DIR -name "backup_*.sql" -type f -mtime +5 -delete

echo "$(date): Cleanup completed - removed backups older than 5 days"