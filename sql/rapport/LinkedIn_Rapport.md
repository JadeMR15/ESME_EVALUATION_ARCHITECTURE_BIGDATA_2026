# Rapport — Analyse des Offres d'Emploi LinkedIn avec Snowflake

## 1. Introduction
Ce projet analyse plusieurs milliers d'offres d'emploi LinkedIn en utilisant Snowflake comme entrepôt de données et Streamlit 
pour les visualisations.

## 2. Architecture des données

### Couche Bronze
Chargement brut des fichiers depuis le bucket S3 public `s3://snowflake-lab-bucket/` sans transformation.

### Couche Silver
Nettoyage, dédoublonnage et typage des données :
- Cast des colonnes STRING vers INTEGER, FLOAT, BOOLEAN
- Suppression des lignes sans job_id
- Extraction des champs JSON depuis les colonnes VARIANT

### Couche Gold
Création de vues agrégées pour les 5 analyses demandées.

## 3. Étapes réalisées

### Étape 1 — Base de données
Création de la base LINKEDIN et des schémas BRONZE, SILVER, GOLD.

### Étape 2 — Stage externe
Création d'un stage pointant vers le bucket S3 public.
Vérification avec LIST @linkedin_stage : 8 fichiers trouvés.

### Étape 3 — File Formats
Création de deux formats : csv_format et json_format.

### Étape 4 — Tables Bronze
Création de 8 tables : 4 CSV et 4 JSON (colonne VARIANT).

### Étape 5 — Chargement (COPY INTO)
Chargement des 8 fichiers avec FORCE = TRUE.
Résultats : 15 886 lignes dans job_postings, 6 063 dans companies_raw.

### Étape 6 — Transformations Silver
Typage des colonnes, gestion des booléens (1.0 → TRUE),
extraction des champs JSON avec la notation raw:field::TYPE.

### Étape 7 — Vues Gold
Création de 5 vues analytiques avec QUALIFY et ROW_NUMBER().

## 4. Analyses et visualisations Streamlit

### Analyse 1 — Top 10 titres par industrie
Utilisation de ROW_NUMBER() avec QUALIFY pour filtrer le top 10.

![Analyse 1](https://raw.githubusercontent.com/JadeMR15/ESME_EVALUATION_ARCHITECTURE_BIGDATA_2026/main/analyse1.png)

### Analyse 2 — Top 10 postes les mieux rémunérés
AVG(max_salary) groupé par industrie et titre.

![Analyse 2]![Analyse 2](https://raw.githubusercontent.com/JadeMR15/ESME_EVALUATION_ARCHITECTURE_BIGDATA_2026/main/analyse2.png)

### Analyse 3 — Répartition par taille d'entreprise
JOIN entre job_postings et companies sur le nom d'entreprise.

![Analyse 3](https://raw.githubusercontent.com/JadeMR15/ESME_EVALUATION_ARCHITECTURE_BIGDATA_2026/main/analyse3.png)

### Analyse 4 — Répartition par secteur d'activité
COUNT des offres groupé par industry_id.

![Analyse 4](https://raw.githubusercontent.com/JadeMR15/ESME_EVALUATION_ARCHITECTURE_BIGDATA_2026/main/analyse4.png)

### Analyse 5 — Répartition par type d'emploi
COUNT groupé par work_type : Full-time 12844, Contract 1739, etc.

![Analyse 5](https://raw.githubusercontent.com/JadeMR15/ESME_EVALUATION_ARCHITECTURE_BIGDATA_2026/main/analyse5.png)

## 5. Problèmes rencontrés et solutions

### Problème 1 — Colonnes manquantes
Le fichier job_postings.csv a 27 colonnes mais la table initiale 
n'en avait que 15. Solution : recréer la table avec les 27 colonnes.

### Problème 2 — Données vides après COPY INTO
Snowflake ne recharge pas un fichier déjà chargé. 
Solution : utiliser FORCE = TRUE.

### Problème 3 — Erreur Boolean
Le champ remote_allowed contient '1.0' et '0.0' au lieu de TRUE/FALSE.
Solution : utiliser CASE WHEN remote_allowed = '1.0' THEN TRUE ELSE FALSE END.

### Problème 4 — Schéma PUBLIC par défaut
Snowflake revenait sur le schéma PUBLIC automatiquement.
Solution : toujours préciser USE DATABASE et USE SCHEMA en début de script.

### Problème 5 — JOIN incorrect sur company_name
La colonne company_name dans job_postings contenait des IDs numériques 
et non des noms d'entreprises. Solution : faire le JOIN sur 
jp.company_name::INTEGER = c.company_id au lieu du nom.

## 6. Répartition des tâches

Projet réalisé en binôme : Jade et Olivia.

**Jade :**
- Création de la base de données et des schémas (Bronze, Silver, Gold)
- Création du stage externe et des file formats
- Chargement des données CSV avec COPY INTO
- Création des vues Gold (analyses 1, 2 et 3)
- Développement des visualisations Streamlit (analyses 1, 2 et 3)

**Olivia :**
- Création des tables Bronze (CSV et JSON)
- Chargement des données JSON avec COPY INTO
- Transformation des données en couche Silver
- Création des vues Gold (analyses 4 et 5)
- Développement des visualisations Streamlit (analyses 4 et 5)
