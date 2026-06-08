-- =============================================================================
-- Poblar dim_psychological
-- =============================================================================
-- Factores psicológicos e institucionales
-- Fuente: AI Student Impact Dataset
-- =============================================================================

SET search_path TO ai_student_dwh;

-- -----------------------------------------------------------------------------
-- dim_psychological
-- -----------------------------------------------------------------------------

INSERT INTO dim_psychological (

    perceived_ai_dependency,
    anxiety_level,
    burnout_risk,
    institutional_policy

)

SELECT DISTINCT

    perceived_ai_dependency,
    anxiety_level_during_exams,
    burnout_risk_level,
    institutional_policy

FROM stg_students

ORDER BY

    perceived_ai_dependency,
    anxiety_level_during_exams,
    burnout_risk_level,
    institutional_policy;

-- =============================================================================
-- VERIFICACIÓN
-- =============================================================================

-- Total de combinaciones psicológicas cargadas
-- SELECT COUNT(*) FROM dim_psychological;

-- Visualizar contenido
-- SELECT *
-- FROM dim_psychological
-- ORDER BY psychological_key;
