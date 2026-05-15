-- On crée la base de données principale du projet
CREATE DATABASE IF NOT EXISTS LINKEDIN; 

-- On crée les 3 couches de l'architecture Medallion
-- Bronze = données brutes, Silver = données nettoyées, Gold = données analytiques
CREATE SCHEMA IF NOT EXISTS LINKEDIN.BRONZE; 
CREATE SCHEMA IF NOT EXISTS LINKEDIN.SILVER; 
CREATE SCHEMA IF NOT EXISTS LINKEDIN.GOLD;
