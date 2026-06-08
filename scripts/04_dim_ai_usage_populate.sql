-- =============================================================================
-- Poblar dim_ai_usage
-- =============================================================================
-- Catálogo de perfiles de uso de Inteligencia Artificial
-- Fuente: AI Student Impact Dataset
-- =============================================================================

SET search_path TO ai_student_dwh;

-- -----------------------------------------------------------------------------
-- dim_ai_usage
-- -----------------------------------------------------------------------------

INSERT INTO dim_ai_usage (
    primary_use_case,
    prompt_skill,
    paid_subscription
)
VALUES
    ('Homework Assistance', 'Beginner', 'No'),
    ('Homework Assistance', 'Intermediate', 'No'),
    ('Homework Assistance', 'Advanced', 'Yes'),

    ('Research', 'Beginner', 'No'),
    ('Research', 'Intermediate', 'No'),
    ('Research', 'Advanced', 'Yes'),

    ('Exam Preparation', 'Beginner', 'No'),
    ('Exam Preparation', 'Intermediate', 'No'),
    ('Exam Preparation', 'Advanced', 'Yes'),

    ('Programming', 'Beginner', 'No'),
    ('Programming', 'Intermediate', 'No'),
    ('Programming', 'Advanced', 'Yes'),

    ('Writing Assistance', 'Beginner', 'No'),
    ('Writing Assistance', 'Intermediate', 'No'),
    ('Writing Assistance', 'Advanced', 'Yes');

-- =============================================================================
-- VERIFICACIÓN
-- =============================================================================

-- SELECT COUNT(*) FROM ai_student_dwh.dim_ai_usage;

-- SELECT *
-- FROM ai_student_dwh.dim_ai_usage
-- ORDER BY ai_usage_key;
