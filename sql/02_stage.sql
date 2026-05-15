USE DATABASE LINKEDIN;
USE SCHEMA BRONZE;

CREATE OR REPLACE STAGE linkedin_stage
  URL = 's3://snowflake-lab-bucket/';

LIST @linkedin_stage;
