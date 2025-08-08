#!/bin/bash
set -e

echo "🏦 Installation MyBank..."

# Initialisation submodules
git submodule init
git submodule update --recursive

# Démarrage des services
docker-compose up -d

echo "⏳ Attente initialisation (30s)..."
sleep 30

# Vérification
docker-compose ps
echo ""
echo "✅ Installation terminée!"
echo "🌐 Frontend: http://localhost:3000"
echo "🔌 Backend: http://localhost:8084"
echo "🗄️ Database: localhost:3311"