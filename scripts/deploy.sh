#!/bin/bash
set -e

echo "🚀 Déploiement MyBank..."

# Sauvegarde base de données
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR
docker-compose exec database mysqldump -u root -proot myBank > $BACKUP_DIR/database.sql 2>/dev/null || echo "Pas de base à sauvegarder"

# Mise à jour images
echo "📥 Récupération des dernières images..."
docker-compose pull

# Redéploiement
echo "🔄 Redéploiement des services..."
docker-compose down
docker-compose up -d

# Tests de santé
echo "🔍 Vérification des services..."
sleep 30
curl -f http://localhost:3000 >/dev/null 2>&1 && echo "✅ Frontend OK" || echo "❌ Frontend KO"
curl -f http://localhost:8084/api/health >/dev/null 2>&1 && echo "✅ Backend OK" || echo "❌ Backend KO"

echo "✅ Déploiement terminé!"