-- =============================================================================
-- Proyecto Final BI
-- Impacto de la Inteligencia Artificial Generativa en el Rendimiento Académico
-- =============================================================================
-- Schema: ai_student_dwh
-- Grano de la Fact:
-- Una fila por estudiante
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS ai_student_dwh;

SET search_path TO ai_student_dwh;

-- =============================================================================
-- DIMENSIONES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Dimensión: Carrera Académica
-- -----------------------------------------------------------------------------

CREATE TABLE dim_major (

    major_key INT
        GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY,

    major_category VARCHAR(50)
        NOT NULL UNIQUE

);

-- -----------------------------------------------------------------------------
-- Dimensión: Año Académico
-- -----------------------------------------------------------------------------

CREATE TABLE dim_year (

    year_key INT
        GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY,

    year_of_study VARCHAR(30)
        NOT NULL UNIQUE

);

-- -----------------------------------------------------------------------------
-- Dimensión: Uso de IA
-- -----------------------------------------------------------------------------

CREATE TABLE dim_ai_usage (

    ai_usage_key INT
        GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY,

    primary_use_case VARCHAR(100)
        NOT NULL,

    prompt_skill VARCHAR(30)
        NOT NULL,

    paid_subscription VARCHAR(10)
        NOT NULL

);

-- -----------------------------------------------------------------------------
-- Dimensión: Factores Psicológicos
-- -----------------------------------------------------------------------------

CREATE TABLE dim_psychological (

    psychological_key INT
        GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY,

    perceived_ai_dependency VARCHAR(20)
        NOT NULL,

    anxiety_level VARCHAR(20)
        NOT NULL,

    burnout_risk VARCHAR(20)
        NOT NULL,

    institutional_policy VARCHAR(50)
        NOT NULL

);

-- =============================================================================
-- TABLA DE HECHOS
-- =============================================================================

CREATE TABLE fact_student_performance (

    student_id BIGINT PRIMARY KEY,

    major_key INT NOT NULL
        REFERENCES dim_major(major_key),

    year_key INT NOT NULL
        REFERENCES dim_year(year_key),

    ai_usage_key INT NOT NULL
        REFERENCES dim_ai_usage(ai_usage_key),

    psychological_key INT NOT NULL
        REFERENCES dim_psychological(psychological_key),

    pre_semester_gpa NUMERIC(3,2),

    post_semester_gpa NUMERIC(3,2),

    gpa_improvement NUMERIC(4,2),

    weekly_genai_hours NUMERIC(5,2),

    traditional_study_hours NUMERIC(5,2),

    skill_retention_score NUMERIC(5,2),

    tool_diversity SMALLINT

);

-- =============================================================================
-- ÍNDICES PARA CONSULTAS ANALÍTICAS
-- =============================================================================

CREATE INDEX idx_fact_major
ON fact_student_performance(major_key);

CREATE INDEX idx_fact_year
ON fact_student_performance(year_key);

CREATE INDEX idx_fact_ai_usage
ON fact_student_performance(ai_usage_key);

CREATE INDEX idx_fact_psychological
ON fact_student_performance(psychological_key);

CREATE INDEX idx_fact_gpa
ON fact_student_performance(post_semester_gpa);

CREATE INDEX idx_fact_genai_hours
ON fact_student_performance(weekly_genai_hours);

-- =============================================================================
-- VERIFICACIÓN
-- =============================================================================

-- Listar tablas creadas:
--
-- SELECT table_name
-- FROM information_schema.tables
-- WHERE table_schema = 'ai_student_dwh';
--
-- Esperado:
--
-- dim_major
-- dim_year
-- dim_ai_usage
-- dim_psychological
-- fact_student_performance
