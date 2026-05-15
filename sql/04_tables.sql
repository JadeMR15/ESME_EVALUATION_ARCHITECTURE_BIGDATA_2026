USE DATABASE LINKEDIN;
USE SCHEMA BRONZE;

-- Toutes les colonnes sont en STRING pour éviter les erreurs lors du chargement. Le typage est fait dans la couche Silver.

-- Table principale : offres d'emploi (27 colonnes)
CREATE OR REPLACE TABLE job_postings (
  job_id STRING, company_name STRING,
  title STRING, description STRING,
  max_salary STRING, med_salary STRING,
  min_salary STRING, pay_period STRING,
  formatted_work_type STRING, location STRING,
  applies STRING, original_listed_time STRING,
  remote_allowed STRING, views STRING,
  job_posting_url STRING, application_url STRING,
  application_type STRING, expiry STRING,
  closed_time STRING, formatted_experience_level STRING,
  skills_desc STRING, listed_time STRING,
  posting_domain STRING, sponsored STRING,
  work_type STRING, currency STRING,
  compensation_type STRING
);

-- Table des avantages associés aux offres
CREATE OR REPLACE TABLE benefits (
  job_id STRING, inferred STRING, type STRING
);

-- Table du nombre d'employés par entreprise
CREATE OR REPLACE TABLE employee_counts (
  company_id STRING, employee_count STRING,
  follower_count STRING, time_recorded STRING
);

-- Table des compétences associées aux offres
CREATE OR REPLACE TABLE job_skills (
  job_id STRING, skill_abr STRING
);

-- Tables JSON : on utilise le type VARIANT qui accepte n'importe quelle structure JSON
CREATE OR REPLACE TABLE companies_raw (raw VARIANT);
CREATE OR REPLACE TABLE company_industries_raw (raw VARIANT);
CREATE OR REPLACE TABLE company_specialities_raw (raw VARIANT);
CREATE OR REPLACE TABLE job_industries_raw (raw VARIANT);
