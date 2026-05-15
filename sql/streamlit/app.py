import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()

st.title("Analyse des Offres d'Emploi LinkedIn")

# Analyse 5 : Par type de contrat
st.header("1. Répartition par type d'emploi")
df5 = session.sql("""
    SELECT work_type AS Type, nb_offres AS Offres
    FROM LINKEDIN.GOLD.v_jobs_by_work_type
""").to_pandas()
st.bar_chart(df5.set_index('TYPE'))

# Analyse 4 : Par secteur
st.header("2. Répartition par secteur d'activité")
df4 = session.sql("""
    SELECT industry_id AS Secteur, nb_offres AS Offres
    FROM LINKEDIN.GOLD.v_jobs_by_industry
""").to_pandas()
st.bar_chart(df4.set_index('SECTEUR'))

# Analyse 3 : Par taille d'entreprise
st.header("3. Répartition par taille d'entreprise")
df3 = session.sql("""
    SELECT taille AS Taille, nb_offres AS Offres
    FROM LINKEDIN.GOLD.v_jobs_by_company_size
    WHERE taille IS NOT NULL
""").to_pandas()
st.bar_chart(df3.set_index('TAILLE'))

# Analyse 1 : Top 10 titres par industrie
st.header("4. Top 10 titres par industrie")
df1 = session.sql("""
    SELECT industry_id AS Industrie, title AS Titre, nb_offres AS Offres
    FROM LINKEDIN.GOLD.v_top_titles_by_industry
    WHERE industry_id = '1'
""").to_pandas()
st.bar_chart(df1.set_index('TITRE')['OFFRES'])

# Analyse 2 : Top 10 salaires par industrie
st.header("5. Top 10 postes les mieux rémunérés")
df2 = session.sql("""
    SELECT title AS Titre, avg_max_salary AS Salaire_Moyen
    FROM LINKEDIN.GOLD.v_top_salaries_by_industry
    WHERE industry_id = '1'
""").to_pandas()
st.bar_chart(df2.set_index('TITRE')['SALAIRE_MOYEN'])
