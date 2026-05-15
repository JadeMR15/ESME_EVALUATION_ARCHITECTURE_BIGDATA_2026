USE SCHEMA LINKEDIN.BRONZE;

-- Format pour les fichiers CSV
-- FIELD_OPTIONALLY_ENCLOSED_BY : gère les champs entre guillemets
-- SKIP_HEADER : ignore la première ligne (c'est les noms des colonnes)
-- NULL_IF : convertit les chaînes vides en valeurs nulles
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  NULL_IF = ('', 'NULL')
  EMPTY_FIELD_AS_NULL = TRUE;

-- Format pour les fichiers JSON
-- STRIP_OUTER_ARRAY : nécessaire car les fichiers JSON commencent par un tableau et pas un objet 
CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;
