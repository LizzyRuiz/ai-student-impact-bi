-- =============================================================================
-- Data Quality Checks
-- Proyecto: AI Student Impact BI
-- =============================================================================
-- Objetivo:
-- Validar la calidad de los datos cargados en el Data Warehouse
-- =============================================================================

SET search_path TO ai_student_dwh;

-- =============================================================================
-- 1. Validar número total de registros cargados
-- =============================================================================

SELECT
    COUNT(*) AS total_students
FROM fact_student_performance;

-- Esperado:
-- Igual al número de registros del dataset original


-- =============================================================================
-- 2. Buscar Student_ID duplicados
-- =============================================================================

SELECT
    student_id,
    COUNT(*) AS occurrences
FROM fact_student_performance
GROUP BY student_id
HAVING COUNT(*) > 1;

-- Esperado:
-- 0 filas


-- =============================================================================
-- 3. Validar llaves foráneas nulas
-- =============================================================================

SELECT
    COUNT(*) AS invalid_records
FROM fact_student_performance
WHERE major_key IS NULL
   OR year_key IS NULL
   OR ai_usage_key IS NULL
   OR psychological_key IS NULL;

-- Esperado:
-- 0


-- =============================================================================
-- 4. Validar GPA fuera de rango
-- =============================================================================

SELECT
    COUNT(*) AS invalid_gpa
FROM fact_student_performance
WHERE pre_semester_gpa < 0
   OR pre_semester_gpa > 4
   OR post_semester_gpa < 0
   OR post_semester_gpa > 4;

-- Esperado:
-- 0


-- =============================================================================
-- 5. Validar horas de IA negativas
-- =============================================================================

SELECT
    COUNT(*) AS invalid_ai_hours
FROM fact_student_performance
WHERE weekly_genai_hours < 0;

-- Esperado:
-- 0


-- =============================================================================
-- 6. Validar horas tradicionales negativas
-- =============================================================================

SELECT
    COUNT(*) AS invalid_study_hours
FROM fact_student_performance
WHERE traditional_study_hours < 0;

-- Esperado:
-- 0


-- =============================================================================
-- 7. Validar Tool Diversity
-- =============================================================================

SELECT
    COUNT(*) AS invalid_tool_diversity
FROM fact_student_performance
WHERE tool_diversity < 0;

-- Esperado:
-- 0


-- =============================================================================
-- 8. Validar Skill Retention Score
-- =============================================================================

SELECT
    COUNT(*) AS invalid_retention_score
FROM fact_student_performance
WHERE skill_retention_score < 0
   OR skill_retention_score > 100;

-- Esperado:
-- 0


-- =============================================================================
-- 9. Validar cálculo de GPA Improvement
-- =============================================================================

SELECT
    COUNT(*) AS incorrect_gpa_improvement
FROM fact_student_performance
WHERE ROUND(
        post_semester_gpa - pre_semester_gpa,
        2
      ) <> ROUND(
        gpa_improvement,
        2
      );

-- Esperado:
-- 0


-- =============================================================================
-- 10. Distribución por carrera
-- =============================================================================

SELECT
    dm.major_category,
    COUNT(*) AS students
FROM fact_student_performance f
JOIN dim_major dm
    ON f.major_key = dm.major_key
GROUP BY dm.major_category
ORDER BY students DESC;

-- Validación visual:
-- Todas las categorías académicas deben tener registros


-- =============================================================================
-- 11. Distribución por año académico
-- =============================================================================

SELECT
    dy.year_of_study,
    COUNT(*) AS students
FROM fact_student_performance f
JOIN dim_year dy
    ON f.year_key = dy.year_key
GROUP BY dy.year_of_study
ORDER BY students DESC;

-- Validación visual:
-- Todos los años académicos deben tener registros


-- =============================================================================
-- 12. Distribución de Burnout
-- =============================================================================

SELECT
    dp.burnout_risk,
    COUNT(*) AS students
FROM fact_student_performance f
JOIN dim_psychological dp
    ON f.psychological_key = dp.psychological_key
GROUP BY dp.burnout_risk
ORDER BY students DESC;

-- Validación visual:
-- Low, Medium y High deben existir


-- =============================================================================
-- 13. Resumen General del DWH
-- =============================================================================

SELECT
    (SELECT COUNT(*) FROM dim_major)            AS total_majors,
    (SELECT COUNT(*) FROM dim_year)             AS total_years,
    (SELECT COUNT(*) FROM dim_ai_usage)         AS total_ai_profiles,
    (SELECT COUNT(*) FROM dim_psychological)    AS total_psychological_profiles,
    (SELECT COUNT(*) FROM fact_student_performance)
                                                 AS total_students;

-- Resultado esperado:
-- Resumen completo del modelo estrella


-- =============================================================================
-- FIN QUALITY CHECKS
-- =============================================================================
