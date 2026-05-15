-- On se place dans la bonne base et le bon schémaUSE DATABASE LINKEDIN;
USE SCHEMA BRONZE;

-- Création du stage vers le bucket S3 public
-- Le stage permet à Snowflake d'accéder aux fichiers distants
CREATE OR REPLACE STAGE linkedin_stage
  URL = 's3://snowflake-lab-bucket/';

-- Vérification : liste les fichiers disponibles dans le bucket
-- On doit voir les 8 fichiers CSV et JSON du projet
LIST @linkedin_stage;
