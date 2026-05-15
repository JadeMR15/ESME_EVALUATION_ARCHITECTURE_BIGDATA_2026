USE DATABASE LINKEDIN;
USE SCHEMA BRONZE;

-- COUCHE SILVER : nettoyage et typage des données brutes
-- SELECT DISTINCT : supprime les doublons
-- ::TYPE : convertir les types
-- WHERE job_id IS NOT NULL : supprime les lignes sans identifiant

CREATE OR REPLACE TABLE SILVER.job_postings AS
SELECT DISTINCT
  job_id::INTEGER AS job_id,
  title::STRING AS title,
  company_name::STRING AS company_name,
  location::STRING AS location,
  max_salary::FLOAT AS max_salary,
  med_salary::FLOAT AS med_salary,
  min_salary::FLOAT AS min_salary,
  pay_period::STRING AS pay_period,
  formatted_work_type AS work_type,
  formatted_experience_level AS experience_level,
  -- remote_allowed contient '1.0' et '0.0' au lieu de TRUE/FALSE
  -- on utilise CASE WHEN pour bien convertir
  CASE WHEN remote_allowed = '1.0' THEN TRUE ELSE FALSE END AS remote_allowed,
  views::INTEGER AS views,
  applies::INTEGER AS applies,
  currency::STRING AS currency
FROM BRONZE.job_postings
WHERE job_id IS NOT NULL;

CREATE OR REPLACE TABLE SILVER.benefits AS
SELECT DISTINCT
  job_id::INTEGER AS job_id,
  CASE WHEN inferred = '1' THEN TRUE ELSE FALSE END AS inferred,
  type::STRING AS type
FROM BRONZE.benefits
WHERE job_id IS NOT NULL;

CREATE OR REPLACE TABLE SILVER.employee_counts AS
SELECT DISTINCT
  company_id::INTEGER AS company_id,
  employee_count::INTEGER AS employee_count,
  follower_count::INTEGER AS follower_count
FROM BRONZE.employee_counts
WHERE company_id IS NOT NULL;

CREATE OR REPLACE TABLE SILVER.job_skills AS
SELECT DISTINCT
  job_id::INTEGER AS job_id,
  skill_abr::STRING AS skill_abr
FROM BRONZE.job_skills
WHERE job_id IS NOT NULL;

-- Pour les JSON : on extrait les champs avec la notation raw:field::TYPE
CREATE OR REPLACE TABLE SILVER.companies AS
SELECT
  raw:company_id::INTEGER AS company_id,
  raw:name::STRING AS name,
  raw:country::STRING AS country,
  raw:city::STRING AS city,
  raw:company_size::INTEGER AS company_size
FROM BRONZE.companies_raw;

CREATE OR REPLACE TABLE SILVER.job_industries AS
SELECT
  raw:job_id::INTEGER AS job_id,
  raw:industry_id::STRING AS industry_id
FROM BRONZE.job_industries_raw;

CREATE OR REPLACE TABLE SILVER.company_industries AS
SELECT
  raw:company_id::INTEGER AS company_id,
  raw:industry::STRING AS industry
FROM BRONZE.company_industries_raw;

CREATE OR REPLACE TABLE SILVER.company_specialities AS
SELECT
  raw:company_id::INTEGER AS company_id,
  raw:speciality::STRING AS speciality
FROM BRONZE.company_specialities_raw;

-- Vérification : doit retourner ~15 886
SELECT COUNT(*) FROM SILVER.job_postings;
