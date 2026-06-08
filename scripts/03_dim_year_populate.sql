-- =============================================================================
-- Poblar dim_year
-- =============================================================================
-- Catálogo de años académicos
-- Fuente: AI Student Impact Dataset
-- =============================================================================

SET search_path TO ai_student_dwh;

-- -----------------------------------------------------------------------------
-- dim_year
-- -----------------------------------------------------------------------------

INSERT INTO dim_year (
    year_of_study
)
VALUES
    ('Freshman'),
    ('Sophomore'),
    ('Junior'),
    ('Senior'),
    ('Graduate');

-- =============================================================================
-- VERIFICACIÓN
-- =============================================================================

-- Total de años académicos cargados
-- SELECT COUNT(*) FROM ai_student_dwh.dim_year;

-- Visualizar contenido
-- SELECT *
-- FROM ai_student_dwh.dim_year
-- ORDER BY year_key;
