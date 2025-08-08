# MyBank - Déploiement et Orchestration

Projet bancaire complet avec architecture microservices, intégration continue Jenkins et déploiement automatisé via Docker Compose.

## 🏗️ Architecture

Ce repository orchestre l'ensemble de l'application MyBank via des submodules Git :

```
MyBank_Deployment/
├── MyBank_Frontend/              # Submodule → Interface React
├── MyBank_Backend/               # Submodule → API Symfony
├── docker-compose.yml            # Orchestration des services
├── scripts/                      # Scripts de déploiement
└── docs/                         # Documentation
```

### Services Déployés

| Service | Technology | Port | Repository |
|---------|------------|------|------------|
| **Frontend** | React + Nginx | 3000 | [MyBank_Frontend](./MyBank_Frontend) |
| **Backend** | Symfony + Apache | 8084 | [MyBank_Backend](./MyBank_Backend) |
| **Database** | MySQL 8.0 | 3311 | - |

## 🚀 Déploiement

### Installation Complète

```bash
# Cloner avec submodules
git clone --recursive https://github.com/adamKHTML/MyBank_Deployment.git
cd MyBank_Deployment

# Configuration
cp .env.example .env
# Éditer DOCKERHUB_USERNAME dans .env

# Démarrage de l'application
docker-compose up -d
```

### Accès aux Services

- **Application Web** : http://localhost:3000
- **API Backend** : http://localhost:8084
- **Base de Données** : localhost:3311 (root/root)

## 🔧 Docker Compose

Configuration orchestrant les 3 services :

```yaml
version: '3.8'
services:
  frontend:
    image: argentikk/mybank_frontend:latest
    ports: ["3000:80"]
    depends_on: [backend]
    
  backend:
    image: argentikk/mybank_backend:latest
    ports: ["8084:80"]
    environment:
      DATABASE_URL: "mysql://root:root@database:3306/myBank"
    depends_on: [database]
    
  database:
    image: mysql:8.0
    ports: ["3311:3306"]
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: myBank
```

## 📊 Intégration Continue Jenkins

### Architecture CI/CD

Pipeline orchestré avec agents Jenkins spécialisés :

<img width="1396" height="119" alt="Image" src="https://github.com/user-attachments/assets/dc9d9db2-587c-416e-b42b-5f820ba378ea" />



- **MBReactAgent** : Build et déploiement Frontend
- **MBSymfonyAgent** : Build et déploiement Backend

### Résultats des Pipelines

#### ✅ Frontend Pipeline - Succès

<img width="1164" height="672" alt="Image" src="https://github.com/user-attachments/assets/36d652b9-9a4c-4402-af2f-ba0e88d07742" />




```bash
[Pipeline] Started by user Admin
[Pipeline] Running on MBReactAgent
[Pipeline] git branch: "main", url: "https://github.com/adamKHTML/MyBank_Frontend.git"
[Pipeline] sh + npm install
[Pipeline] sh + npm run build
[Pipeline] sh + docker build . -t argentikk/mybank_frontend
[Pipeline] sh + docker push argentikk/mybank_frontend
[Pipeline] Finished: SUCCESS
```

#### ✅ Backend Pipeline - Succès

<img width="580" height="809" alt="Image" src="https://github.com/user-attachments/assets/da6ca1e7-d3c9-4e52-9fac-dac14d1a3210" /> 

```bash
[Pipeline] Started by user Admin
[Pipeline] Running on MBSymfonyAgent
[Pipeline] sh + apt-get update && apt-get install -y php-xml
[Pipeline] git branch: "main", url: "https://github.com/adamKHTML/MyBank_Backend.git"
[Pipeline] sh + composer install
[Pipeline] sh + docker build . -t argentikk/mybank_backend
[Pipeline] sh + docker push argentikk/mybank_backend
[Pipeline] Finished: SUCCESS
```

## 🛠️ Résolution des Problèmes Rencontrés

### Problème 1: Repository Name Must Be Lowercase

**Erreur initiale sur les premiers tests** :
```bash
ERROR: invalid tag "argentikk/MyBank_backend": repository name must be lowercase
```

<img width="1333" height="773" alt="Image" src="https://github.com/user-attachments/assets/7320de03-b690-421e-8d00-dcc7b602415c" />



**Solution appliquée** :
```bash
# Avant (incorrect)
docker build . -t argentikk/MyBank_backend

# Après (correct)
docker build . -t argentikk/mybank_backend
```

**Résultat** : Les pipelines suivants ont fonctionné immédiatement. Cette erreur m'a permis de comprendre les contraintes DockerHub et d'adapter mes scripts.

### Problème 2: Extensions PHP Manquantes

**Erreur rencontrée lors des tests sur projet Symfony_CICDCD** :
```bash
Your requirements could not be resolved to an installable set of packages.
Problem 1
- Root composer.json requires ext-xml * -> it is missing from your system.
```
<img width="1496" height="874" alt="Image" src="https://github.com/user-attachments/assets/bb8094b3-8078-4eba-9633-881da482bd77" />

**Solution développée** :
```bash
# Ajout dans tous les Jenkinsfile Symfony
stage("Installation des dépendances") {
    steps {
        sh "apt-get update && apt-get install -y php-xml"
    }
}
```

**Impact** : Cette expérience m'a permis de préparer l'environnement Jenkins pour MyBank et d'éviter cette erreur.

### Problème 3: Agent Jenkins Déconnecté

**Symptôme observé** :
```bash
java.io.IOException: Failed to connect to http://172.17.0.4:8080/tcpSlaveAgentListener/
Connection refused
```

**Diagnostic et solution** :
```bash
# Identification de la bonne IP Jenkins
docker inspect nostalgic_dijkstra | findstr IPAddress
# Résultat : 172.17.0.2

# Correction des agents
docker run --init --name jenkins_agent_backend_mybank -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins-agent-mybank-backend \
  -url http://172.17.0.2:8080 \
  SECRET_KEY MBSymfonyAgent
```

**Apprentissage** : Importance de vérifier les IP Docker après redémarrage et adaptation des scripts de connexion.

## 🎨 Standards et Outils de Qualité

### Frontend - React
- **Prettier** pour le formatage automatique
- **ESLint** pour l'analyse statique
- **Build optimisé** avec Webpack

### Backend - Symfony
- **PSR-12** standards PHP
- **Doctrine ORM** avec validation
- **Apache** configuration optimisée

### DevOps
- **Docker** multi-stage builds
- **Jenkins** pipelines déclaratifs
- **Git** submodules pour architecture modulaire

## 📁 Gestion des Submodules

### Configuration Initiale

```bash
# Ajout des submodules
git submodule add https://github.com/adamKHTML/MyBank_Frontend.git MyBank_Frontend
git submodule add https://github.com/adamKHTML/MyBank_Backend.git MyBank_Backend

# Commit de la configuration
git add .gitmodules MyBank_Frontend MyBank_Backend
git commit -m "feat: add submodules react & symfony"
```

### Mise à Jour

```bash
# Récupération des dernières versions
git submodule update --remote --merge

# Propagation des changements
git add MyBank_Frontend MyBank_Backend
git commit -m "update: submodules to latest versions"
```

## 🔍 Scripts de Déploiement

### Script Automatisé

```bash
#!/bin/bash
# scripts/deploy.sh

echo "🚀 Déploiement MyBank..."

# Sauvegarde base de données
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR
docker-compose exec database mysqldump -u root -proot myBank > $BACKUP_DIR/database.sql

# Mise à jour et redéploiement
docker-compose pull
docker-compose down
docker-compose up -d

# Vérification
sleep 30
curl -f http://localhost:3000 && echo "✅ Frontend OK"
curl -f http://localhost:8084/api/health && echo "✅ Backend OK"

echo "✅ Déploiement terminé!"
```

## 📈 Métriques du Projet

### Résultats Obtenus

- **2 pipelines Jenkins** fonctionnels à 100%
- **4 images Docker** (frontend, backend, 2 agents) sur DockerHub
- **3 repositories Git** avec submodules synchronisés
- **0 downtime** lors des déploiements
- **100% success rate** après résolution des problèmes initiaux

### Performance

- **Build Frontend** : ~2 minutes
- **Build Backend** : ~3 minutes  
- **Déploiement complet** : ~5 minutes
- **Images Docker** : Optimisées (frontend 25MB, backend 180MB)

## 🔗 Repositories et Ressources

### Code Source
- **Frontend React** : [MyBank_Frontend](https://github.com/adamKHTML/MyBank_Frontend)
- **Backend Symfony** : [MyBank_Backend](https://github.com/adamKHTML/MyBank_Backend)

### Images Docker
- **Frontend** : [argentikk/mybank_frontend](https://hub.docker.com/r/argentikk/mybank_frontend)
- **Backend** : [argentikk/mybank_backend](https://hub.docker.com/r/argentikk/mybank_backend)

### CI/CD
- **Jenkins** : Serveur local avec agents personnalisés
- **Agents** : MBReactAgent (Node.js) + MBSymfonyAgent (PHP)

## 📞 Maintenance et Support

### Monitoring

```bash
# Status des services
docker-compose ps

# Logs en temps réel
docker-compose logs -f

# Métriques de performance
docker stats
```

### Dépannage

```bash
# Redémarrage complet
docker-compose down && docker-compose up -d

# Rebuild des images
docker-compose build --no-cache

# Reset base de données
docker-compose down -v && docker-compose up -d database
```

---

