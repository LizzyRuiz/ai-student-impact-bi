-- =============================================================================
-- Queries analíticas con SQL avanzado
-- =============================================================================
-- Técnicas cubiertas:
--
-- 1. CTE + Ranking
-- 2. Window Function
-- 3. COUNT FILTER
-- 4. PERCENTILE_CONT
-- 5. CTE + LAG
-- =============================================================================

SET search_path TO ai_student_dwh;

-- -----------------------------------------------------------------------------
-- 1. Top 5 carreras con mayor mejora promedio de GPA
--    (CTE + Ranking)
-- -----------------------------------------------------------------------------

WITH major_performance AS (

    SELECT
        dm.major_category,
        ROUND(AVG(f.gpa_improvement),3) AS avg_gpa_improvement,
        COUNT(*) AS total_students

    FROM fact_student_performance f
    JOIN dim_major dm
        ON f.major_key = dm.major_key

    GROUP BY dm.major_category
)

SELECT *
FROM major_performance
ORDER BY avg_gpa_improvement DESC
LIMIT 5;


-- -----------------------------------------------------------------------------
-- 2. Promedio acumulado de mejora GPA por horas de uso de IA
--    (Window Function)
-- -----------------------------------------------------------------------------

SELECT

    student_id,
    weekly_genai_hours,
    gpa_improvement,

    ROUND(
        AVG(gpa_improvement) OVER(
            ORDER BY weekly_genai_hours
            ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
        )
    ,3) AS moving_avg_gpa

FROM fact_student_performance
ORDER BY weekly_genai_hours;


-- -----------------------------------------------------------------------------
-- 3. Porcentaje de estudiantes con alto burnout por carrera
--    (COUNT FILTER)
-- -----------------------------------------------------------------------------

SELECT

    dm.major_category,

    COUNT(*) AS total_students,

    COUNT(*) FILTER (
        WHERE dp.burnout_risk = 'High'
    ) AS high_burnout_students,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE dp.burnout_risk = 'High'
        )
        / COUNT(*)
    ,2) AS pct_high_burnout

FROM fact_student_performance f

JOIN dim_major dm
    ON f.major_key = dm.major_key

JOIN dim_psychological dp
    ON f.psychological_key = dp.psychological_key

GROUP BY dm.major_category

ORDER BY pct_high_burnout DESC;


-- -----------------------------------------------------------------------------
-- 4. Distribución de GPA Improvement
--    (Percentiles)
-- -----------------------------------------------------------------------------

SELECT

    PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY gpa_improvement) AS p25,

    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY gpa_improvement) AS median,

    PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY gpa_improvement) AS p75,

    PERCENTILE_CONT(0.95)
        WITHIN GROUP (ORDER BY gpa_improvement) AS p95,

    ROUND(AVG(gpa_improvement),3) AS avg_improvement

FROM fact_student_performance;


-- -----------------------------------------------------------------------------
-- 5. Comparación de GPA entre años académicos
--    (CTE + LAG)
-- -----------------------------------------------------------------------------

WITH yearly_gpa AS (

    SELECT

        dy.year_of_study,

        CASE
            WHEN dy.year_of_study = 'Freshman' THEN 1
            WHEN dy.year_of_study = 'Sophomore' THEN 2
            WHEN dy.year_of_study = 'Junior' THEN 3
            WHEN dy.year_of_study = 'Senior' THEN 4
            WHEN dy.year_of_study = 'Graduate' THEN 5
        END AS academic_order,

        ROUND(
            AVG(f.post_semester_gpa)
        ,3) AS avg_gpa

    FROM fact_student_performance f

    JOIN dim_year dy
        ON f.year_key = dy.year_key

    GROUP BY
        dy.year_of_study
)

SELECT

    year_of_study,

    avg_gpa,

    LAG(avg_gpa)
        OVER(
            ORDER BY academic_order
        ) AS previous_year_gpa,

    avg_gpa -
    LAG(avg_gpa)
        OVER(
            ORDER BY academic_order
        ) AS delta_gpa

FROM yearly_gpa

ORDER BY academic_order;

--| Query                  | Técnica         | Insight de negocio                                                        |
--| ---------------------- | --------------- | ------------------------------------------------------------------------- |
--| Top carreras por GPA   | CTE + Ranking   | Identifica qué áreas académicas obtienen mayores beneficios del uso de IA |
--| Promedio móvil GPA     | Window Function | Detecta tendencia entre horas de IA y mejora académica                    |
--| % Burnout por carrera  | COUNT FILTER    | Mide impacto emocional por disciplina                                     |
--| Percentiles GPA        | PERCENTILE_CONT | Analiza distribución y dispersión del desempeño                           |
--| Comparación entre años | LAG             | Evalúa diferencias académicas entre niveles universitarios                |
