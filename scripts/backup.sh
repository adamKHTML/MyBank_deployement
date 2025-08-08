#!/bin/bash

BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

echo "💾 Sauvegarde MyBank..."
docker-compose exec database mysqldump -u root -proot myBank > $BACKUP_DIR/database.sql
echo "✅ Sauvegarde dans $BACKUP_DIR/"