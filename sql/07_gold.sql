USE DATABASE LINKEDIN;
USE SCHEMA GOLD;

-- Analyse 1 : Top 10 titres par industrie
CREATE OR REPLACE VIEW v_top_titles_by_industry AS
SELECT industry_id, title, COUNT(*) AS nb_offres
FROM LINKEDIN.SILVER.job_postings jp
JOIN LINKEDIN.SILVER.job_industries ji ON jp.job_id = ji.job_id
GROUP BY 1, 2
QUALIFY ROW_NUMBER() OVER (PARTITION BY industry_id ORDER BY COUNT(*) DESC) <= 10;

-- Analyse 2 : Top 10 salaires par industrie
CREATE OR REPLACE VIEW v_top_salaries_by_industry AS
SELECT industry_id, title, ROUND(AVG(max_salary), 0) AS avg_max_salary
FROM LINKEDIN.SILVER.job_postings jp
JOIN LINKEDIN.SILVER.job_industries ji ON jp.job_id = ji.job_id
WHERE max_salary IS NOT NULL
GROUP BY 1, 2
QUALIFY ROW_NUMBER() OVER (PARTITION BY industry_id ORDER BY AVG(max_salary) DESC) <= 10;

CREATE OR REPLACE VIEW v_jobs_by_company_size AS
SELECT
  CASE c.company_size
    WHEN 0 THEN '0-1 employé'
    WHEN 1 THEN '2-10'
    WHEN 2 THEN '11-50'
    WHEN 3 THEN '51-200'
    WHEN 4 THEN '201-500'
    WHEN 5 THEN '501-1000'
    WHEN 6 THEN '1001-5000'
    WHEN 7 THEN '+5000'
  END AS taille,
  COUNT(*) AS nb_offres
FROM LINKEDIN.SILVER.job_postings jp
JOIN LINKEDIN.SILVER.companies c ON jp.company_name = TRIM(c.name)
WHERE c.company_size IS NOT NULL
GROUP BY 1;

-- Analyse 4 : Par secteur d'activité
CREATE OR REPLACE VIEW v_jobs_by_industry AS
SELECT industry_id, COUNT(*) AS nb_offres
FROM LINKEDIN.SILVER.job_industries
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;

-- Analyse 5 : Par type d'emploi
CREATE OR REPLACE VIEW v_jobs_by_work_type AS
SELECT work_type, COUNT(*) AS nb_offres
FROM LINKEDIN.SILVER.job_postings
WHERE work_type IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM v_jobs_by_work_type;
