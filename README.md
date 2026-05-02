# 🌾 Farmers Market Platform — Backend Laravel

API RESTful pour une plateforme de marché agricole en Côte d'Ivoire.  
Gestion des ventes, crédits agricoles et remboursements en commodités.

---

## 📋 Prérequis

- PHP >= 8.1
- Composer >= 2.x
- MySQL >= 8.0 ou PostgreSQL >= 13
- Laravel 10+
- Git

---

## ⚙️ Installation & Déploiement

### 1. Cloner le dépôt

```bash
git clone https://github.com/joceOG/farmers_market_app.git
cd farmers_market_app/backend
```

### 2. Installer les dépendances

```bash
composer install
```

### 3. Configurer l'environnement

```bash
cp .env.example .env
php artisan key:generate
```

Modifier le fichier `.env` :

```env
APP_NAME="Farmers Market API"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=farmers_market
DB_USERNAME=root
DB_PASSWORD=your_password

# Taux de commodité par défaut (FCFA par kg)
COMMODITY_RATE=1000

# Taux d'intérêt crédit par défaut (ex: 0.30 = 30%)
CREDIT_INTEREST_RATE=0.30
```

### 4. Créer la base de données

```bash
mysql -u root -p -e "CREATE DATABASE farmers_market CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### 5. Exécuter les migrations et seeders

```bash
php artisan migrate --seed
```

### 6. Lancer le serveur de développement

```bash
php artisan serve
```

L'API est accessible sur : `http://localhost:8000/api`

---

## 🐳 Docker (Optionnel)

```bash
# Construire et démarrer les conteneurs
docker-compose up -d

# Exécuter les migrations dans le conteneur
docker-compose exec app php artisan migrate --seed
```

---

## 🔐 Authentification

L'API utilise **Laravel Sanctum** (tokens Bearer).

### Connexion

```http
POST /api/login
Content-Type: application/json

{
  "email": "admin@farmersmarket.ci",
  "password": "password"
}
```

Réponse :

```json
{
  "token": "1|xxxxxxxxxxxxxxxxxxxxxxxx",
  "user": { "id": 1, "name": "Admin", "role": "admin" }
}
```

Utiliser le token dans les requêtes suivantes :

```http
Authorization: Bearer {token}
```

---

## 👥 Comptes de démonstration (après seeding)

| Rôle       | Email                      | Mot de passe |
|------------|----------------------------|--------------|
| Admin      | admin@farmersmarket.ci     | password     |
| Supervisor | supervisor@farmersmarket.ci| password     |
| Operator   | operator@farmersmarket.ci  | password     |

---

## 📡 Endpoints principaux

### Auth
| Méthode | Endpoint       | Description         | Accès   |
|---------|---------------|---------------------|---------|
| POST    | /api/login    | Connexion           | Public  |
| POST    | /api/logout   | Déconnexion         | Auth    |

### Utilisateurs
| Méthode | Endpoint              | Description                  | Accès       |
|---------|-----------------------|------------------------------|-------------|
| GET     | /api/users            | Lister les utilisateurs      | Admin       |
| POST    | /api/supervisors      | Créer un superviseur         | Admin       |
| POST    | /api/operators        | Créer un opérateur           | Supervisor  |

### Produits & Catégories
| Méthode | Endpoint              | Description                  | Accès             |
|---------|-----------------------|------------------------------|-------------------|
| GET     | /api/categories       | Arborescence des catégories  | Auth              |
| POST    | /api/categories       | Créer une catégorie          | Admin/Supervisor  |
| GET     | /api/products         | Lister les produits          | Auth              |
| POST    | /api/products         | Créer un produit             | Admin/Supervisor  |

### Agriculteurs
| Méthode | Endpoint                    | Description                  | Accès     |
|---------|-----------------------------|------------------------------|-----------|
| GET     | /api/farmers                | Lister / chercher            | Auth      |
| POST    | /api/farmers                | Créer un profil agriculteur  | Operator  |
| GET     | /api/farmers/{id}           | Profil + résumé des dettes   | Auth      |

### Transactions
| Méthode | Endpoint              | Description                  | Accès     |
|---------|-----------------------|------------------------------|-----------|
| POST    | /api/transactions     | Créer une commande           | Operator  |
| GET     | /api/transactions/{id}| Détails d'une transaction    | Auth      |

### Dettes & Remboursements
| Méthode | Endpoint                      | Description                    | Accès     |
|---------|-------------------------------|--------------------------------|-----------|
| GET     | /api/farmers/{id}/debts       | Dettes impayées                | Auth      |
| POST    | /api/repayments               | Enregistrer un remboursement   | Operator  |

---

## 🧮 Règles métier

| Règle | Description |
|-------|-------------|
| **Crédit** | `prix_crédit = prix_cash × (1 + taux_intérêt)` |
| **Limite crédit** | La transaction est bloquée si `dette_totale + nouveau_crédit > limite_agriculteur` |
| **FIFO** | Les remboursements soldent d'abord la dette la plus ancienne |
| **Remboursement partiel** | Le solde restant d'une dette reste ouvert |
| **Taux commodité** | Configurable (ex : 1 kg cacao = 1 000 FCFA) |

---

## 🗂️ Structure du projet

```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/     # Contrôleurs API
│   │   ├── Requests/        # Validation des formulaires
│   │   └── Resources/       # Transformateurs JSON
│   ├── Models/              # Modèles Eloquent
│   └── Services/            # Logique métier (crédit, FIFO...)
├── database/
│   ├── migrations/          # Schéma de la base de données
│   └── seeders/             # Données de démonstration
├── routes/
│   └── api.php              # Définition des routes
└── tests/
    └── Feature/             # Tests des endpoints API
```

---

## 🧪 Tests

```bash
# Lancer tous les tests
php artisan test

# Tests avec couverture de code
php artisan test --coverage
```

---

## 📖 Documentation API

La collection Postman est disponible à la racine du projet :  
📁 `farmers_market_api.postman_collection.json`

Pour l'importer : Postman → **Import** → sélectionner le fichier.

---

## 🔄 Commandes utiles

```bash
# Réinitialiser la base de données
php artisan migrate:fresh --seed

# Vider le cache
php artisan cache:clear
php artisan config:clear

# Lister toutes les routes API
php artisan route:list --path=api
```

---

## 🤝 Hiérarchie des rôles

```
Admin
 └── Supervisor (créé par Admin)
      └── Operator (créé par Supervisor)
```

---

## 📝 Licence

Projet réalisé dans le cadre d'un test technique — Full Stack Developer.
