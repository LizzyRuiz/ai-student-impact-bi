-- =============================================================================
-- Poblar dim_major
-- =============================================================================
-- Catálogo de categorías académicas (Major_Category)
-- Fuente: AI Student Impact Dataset
-- =============================================================================

SET search_path TO ai_student_dwh;

-- -----------------------------------------------------------------------------
-- dim_major
-- -----------------------------------------------------------------------------

INSERT INTO dim_major (
    major_category
)
VALUES
    ('STEM'),
    ('Business'),
    ('Humanities'),
    ('Medical'),
    ('Arts'),
    ('Education'),
    ('Law'),
    ('Social Sciences');

-- =============================================================================
-- VERIFICACIÓN
-- =============================================================================

-- Total de carreras cargadas
-- SELECT COUNT(*) FROM ai_student_dwh.dim_major;

-- Visualizar contenido
-- SELECT * FROM ai_student_dwh.dim_major
-- ORDER BY major_category;
