"""
ETL Pipeline
Proyecto: AI Student Impact BI

Proceso:

1. Leer dataset CSV
2. Limpiar datos
3. Calcular KPIs derivados
4. Poblar dimensiones
5. Poblar tabla de hechos
6. Ejecutar validaciones post-carga
"""
pip install pandas
pip install sqlalchemy
pip install psycopg2-binary

import pandas as pd
from sqlalchemy import create_engine, text

# =============================================================================
# CONFIGURACIÓN
# =============================================================================

CSV_PATH = "../data/ai_student_impact_dataset.csv"

DB_USER = "postgres"
DB_PASSWORD = "password"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "ai_student_dwh"

SCHEMA = "ai_student_dwh"

# =============================================================================
# CONEXIÓN
# =============================================================================

engine = create_engine(
    f"postgresql+psycopg2://"
    f"{DB_USER}:{DB_PASSWORD}@"
    f"{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# =============================================================================
# EXTRACT
# =============================================================================

print("Leyendo dataset...")

df = pd.read_csv(CSV_PATH)

print(f"Registros leídos: {len(df):,}")

# =============================================================================
# TRANSFORM
# =============================================================================

print("Aplicando transformaciones...")

# eliminar duplicados
df = df.drop_duplicates()

# eliminar nulos críticos
df = df.dropna(
    subset=[
        "Student_ID",
        "Major_Category",
        "Year_of_Study"
    ]
)

# GPA Improvement
df["gpa_improvement"] = (
    df["Post_Semester_GPA"]
    - df["Pre_Semester_GPA"]
)

# normalización básica
df["Paid_Subscription"] = (
    df["Paid_Subscription"]
    .astype(str)
    .str.strip()
)

# =============================================================================
# DIM_MAJOR
# =============================================================================

print("Cargando dim_major...")

dim_major = (

    df[["Major_Category"]]

    .drop_duplicates()

    .rename(
        columns={
            "Major_Category":
            "major_category"
        }
    )

)

dim_major.to_sql(
    "dim_major",
    engine,
    schema=SCHEMA,
    if_exists="append",
    index=False
)

# =============================================================================
# DIM_YEAR
# =============================================================================

print("Cargando dim_year...")

dim_year = (

    df[["Year_of_Study"]]

    .drop_duplicates()

    .rename(
        columns={
            "Year_of_Study":
            "year_of_study"
        }
    )

)

dim_year.to_sql(
    "dim_year",
    engine,
    schema=SCHEMA,
    if_exists="append",
    index=False
)

# =============================================================================
# DIM_AI_USAGE
# =============================================================================

print("Cargando dim_ai_usage...")

dim_ai = (

    df[
        [
            "Primary_Use_Case",
            "Prompt_Engineering_Skill",
            "Paid_Subscription"
        ]
    ]

    .drop_duplicates()

    .rename(
        columns={
            "Primary_Use_Case":
                "primary_use_case",

            "Prompt_Engineering_Skill":
                "prompt_skill",

            "Paid_Subscription":
                "paid_subscription"
        }
    )

)

dim_ai.to_sql(
    "dim_ai_usage",
    engine,
    schema=SCHEMA,
    if_exists="append",
    index=False
)

# =============================================================================
# DIM_PSYCHOLOGICAL
# =============================================================================

print("Cargando dim_psychological...")

dim_psy = (

    df[
        [
            "Perceived_AI_Dependency",
            "Anxiety_Level_During_Exams",
            "Burnout_Risk_Level",
            "Institutional_Policy"
        ]
    ]

    .drop_duplicates()

    .rename(
        columns={
            "Perceived_AI_Dependency":
                "perceived_ai_dependency",

            "Anxiety_Level_During_Exams":
                "anxiety_level",

            "Burnout_Risk_Level":
                "burnout_risk",

            "Institutional_Policy":
                "institutional_policy"
        }
    )

)

dim_psy.to_sql(
    "dim_psychological",
    engine,
    schema=SCHEMA,
    if_exists="append",
    index=False
)

# =============================================================================
# RECUPERAR KEYS
# =============================================================================

print("Construyendo fact table...")

major_lookup = pd.read_sql(
    """
    SELECT
        major_key,
        major_category
    FROM ai_student_dwh.dim_major
    """,
    engine
)

year_lookup = pd.read_sql(
    """
    SELECT
        year_key,
        year_of_study
    FROM ai_student_dwh.dim_year
    """,
    engine
)

ai_lookup = pd.read_sql(
    """
    SELECT *
    FROM ai_student_dwh.dim_ai_usage
    """,
    engine
)

psy_lookup = pd.read_sql(
    """
    SELECT *
    FROM ai_student_dwh.dim_psychological
    """,
    engine
)

# =============================================================================
# JOINS PARA FACT
# =============================================================================

fact = df.copy()

fact = fact.merge(
    major_lookup,
    left_on="Major_Category",
    right_on="major_category"
)

fact = fact.merge(
    year_lookup,
    left_on="Year_of_Study",
    right_on="year_of_study"
)

fact = fact.merge(

    ai_lookup,

    left_on=[
        "Primary_Use_Case",
        "Prompt_Engineering_Skill",
        "Paid_Subscription"
    ],

    right_on=[
        "primary_use_case",
        "prompt_skill",
        "paid_subscription"
    ]
)

fact = fact.merge(

    psy_lookup,

    left_on=[
        "Perceived_AI_Dependency",
        "Anxiety_Level_During_Exams",
        "Burnout_Risk_Level",
        "Institutional_Policy"
    ],

    right_on=[
        "perceived_ai_dependency",
        "anxiety_level",
        "burnout_risk",
        "institutional_policy"
    ]
)

# =============================================================================
# FACT TABLE
# =============================================================================

fact_final = pd.DataFrame({

    "student_id":
        fact["Student_ID"],

    "major_key":
        fact["major_key"],

    "year_key":
        fact["year_key"],

    "ai_usage_key":
        fact["ai_usage_key"],

    "psychological_key":
        fact["psychological_key"],

    "pre_semester_gpa":
        fact["Pre_Semester_GPA"],

    "post_semester_gpa":
        fact["Post_Semester_GPA"],

    "gpa_improvement":
        fact["gpa_improvement"],

    "weekly_genai_hours":
        fact["Weekly_GenAI_Hours"],

    "traditional_study_hours":
        fact["Traditional_Study_Hours"],

    "skill_retention_score":
        fact["Skill_Retention_Score"],

    "tool_diversity":
        fact["Tool_Diversity"]

})

print("Cargando fact_student_performance...")

fact_final.to_sql(
    "fact_student_performance",
    engine,
    schema=SCHEMA,
    if_exists="append",
    index=False
)

# =============================================================================
# VALIDACIONES POST-CARGA
# =============================================================================

print("Ejecutando validaciones...")

with engine.connect() as conn:

    total_fact = conn.execute(text("""

        SELECT COUNT(*)
        FROM ai_student_dwh.fact_student_performance

    """)).scalar()

    total_major = conn.execute(text("""

        SELECT COUNT(*)
        FROM ai_student_dwh.dim_major

    """)).scalar()

    total_year = conn.execute(text("""

        SELECT COUNT(*)
        FROM ai_student_dwh.dim_year

    """)).scalar()

print("\n============================")
print("VALIDACIÓN ETL")
print("============================")

print(f"Fact Rows: {total_fact:,}")
print(f"Majors: {total_major}")
print(f"Academic Years: {total_year}")

print("\nETL FINALIZADO CORRECTAMENTE")
