# Projet React + TypeScript + Vite avec Backend Symfony

Ce projet est une application web utilisant React pour le frontend et Symfony pour le backend. Le frontend est situé dans le dossier `/client` et le backend dans le dossier `/backend`.

## Prérequis

- Node.js (version 14 ou supérieure)
- Docker et Docker Compose
- Composer

## Installation

### Frontend

1. Accédez au dossier `/client` :
    ```sh
    cd client
    ```

2. Installez les dépendances :
    ```sh
    npm install
    ```

3. Démarrez le serveur de développement :
    ```sh
    docker run -p 3000:80 client
    ```

Le frontend sera accessible à l'adresse `http://localhost:3000`.

### Backend

1. Accédez au dossier [backend](http://_vscodecontentref_/1) :
    ```sh
    cd backend
    ```

2. Installez les dépendances PHP avec Composer :
    ```sh
    composer install
    ```

3. Démarrez les services Docker :
    ```sh
    docker-compose up --build
    ```

Le backend sera accessible à l'adresse `http://localhost:8000`.

## Utilisation

### Frontend

Le frontend est une application React utilisant Vite pour le bundling et le développement rapide. Vous pouvez modifier les fichiers dans le dossier [client](http://_vscodecontentref_/2) et voir les changements en temps réel grâce à HMR (Hot Module Replacement).

### Backend

Le backend est une application Symfony. Vous pouvez accéder à l'interface de l'application à l'adresse `http://localhost:8000`. Les configurations de la base de données et d'autres services sont gérées via Docker Compose.

## Structure du Projet

- [client](http://_vscodecontentref_/3) : Contient le code source du frontend React.
- [backend](http://_vscodecontentref_/4) : Contient le code source du backend Symfony.

## Commandes Utiles

### Frontend

- `docker run -p 3000:80 client` : Démarre le serveur de développement.

### Backend

- `composer install` : Installe les dépendances PHP.
- `docker-compose up --build` : Démarre les services Docker et construit les images.
- `docker-compose down` : Arrête les services Docker.


## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.
