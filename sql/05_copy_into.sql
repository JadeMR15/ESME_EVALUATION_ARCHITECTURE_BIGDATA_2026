USE DATABASE LINKEDIN;
USE SCHEMA BRONZE;

COPY INTO job_postings
  FROM @linkedin_stage/job_postings.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  FORCE = TRUE;

COPY INTO benefits
  FROM @linkedin_stage/benefits.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  FORCE = TRUE;

COPY INTO employee_counts
  FROM @linkedin_stage/employee_counts.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  FORCE = TRUE;

COPY INTO job_skills
  FROM @linkedin_stage/job_skills.csv
  FILE_FORMAT = (FORMAT_NAME = csv_format)
  FORCE = TRUE;

COPY INTO companies_raw
  FROM @linkedin_stage/companies.json
  FILE_FORMAT = (FORMAT_NAME = json_format)
  FORCE = TRUE;

COPY INTO company_industries_raw
  FROM @linkedin_stage/company_industries.json
  FILE_FORMAT = (FORMAT_NAME = json_format)
  FORCE = TRUE;

COPY INTO company_specialities_raw
  FROM @linkedin_stage/company_specialities.json
  FILE_FORMAT = (FORMAT_NAME = json_format)
  FORCE = TRUE;

COPY INTO job_industries_raw
  FROM @linkedin_stage/job_industries.json
  FILE_FORMAT = (FORMAT_NAME = json_format)
  FORCE = TRUE;

SELECT COUNT(*) FROM job_postings;
SELECT COUNT(*) FROM benefits;
SELECT COUNT(*) FROM companies_raw;
