-- =============================================================================
-- BUSINESS QUESTIONS
-- Proyecto Final BI
-- AI Student Impact Dataset
-- =============================================================================
-- Objetivo:
-- Responder las preguntas de negocio planteadas en el proyecto.
--
-- Preguntas:
--
-- 1. ¿El uso de IA mejora el rendimiento académico?
-- 2. ¿Existe un nivel óptimo de uso de IA?
-- 3. ¿La dependencia de IA afecta la retención del conocimiento?
-- 4. ¿El uso intensivo de IA está relacionado con el burnout académico?
-- 5. ¿Qué carreras presentan mayor adopción de IA?
-- =============================================================================

SET search_path TO ai_student_dwh;

-- =============================================================================
-- BUSINESS QUESTION 1
-- ¿El uso de IA mejora el rendimiento académico?
--
-- Relación entre horas semanales de IA y GPA Improvement
-- =============================================================================

SELECT

    CASE

        WHEN weekly_genai_hours < 5 THEN '0-5 horas'
        WHEN weekly_genai_hours < 10 THEN '5-10 horas'
        WHEN weekly_genai_hours < 15 THEN '10-15 horas'
        WHEN weekly_genai_hours < 20 THEN '15-20 horas'
        WHEN weekly_genai_hours < 25 THEN '20-25 horas'
        WHEN weekly_genai_hours < 30 THEN '25-30 horas'
        ELSE '30+ horas'

    END AS ai_usage_group,

    COUNT(*) AS total_students,

    ROUND(
        AVG(gpa_improvement),
        3
    ) AS avg_gpa_improvement,

    ROUND(
        AVG(post_semester_gpa),
        3
    ) AS avg_post_gpa

FROM fact_student_performance

GROUP BY 1

ORDER BY 1;

-- Insight esperado:
-- Identificar si los estudiantes que utilizan más IA
-- obtienen una mejora académica superior.


-- =============================================================================
-- BUSINESS QUESTION 2
-- ¿Existe un nivel óptimo de uso de IA?
--
-- Detectar el rango de horas con mejor GPA Improvement
-- =============================================================================

WITH ai_usage_analysis AS (

    SELECT

        CASE

            WHEN weekly_genai_hours < 5 THEN '0-5'
            WHEN weekly_genai_hours < 10 THEN '5-10'
            WHEN weekly_genai_hours < 15 THEN '10-15'
            WHEN weekly_genai_hours < 20 THEN '15-20'
            WHEN weekly_genai_hours < 25 THEN '20-25'
            WHEN weekly_genai_hours < 30 THEN '25-30'
            ELSE '30+'

        END AS ai_usage_group,

        AVG(gpa_improvement) AS avg_gpa_improvement

    FROM fact_student_performance

    GROUP BY 1

)

SELECT *

FROM ai_usage_analysis

ORDER BY avg_gpa_improvement DESC;

-- Insight esperado:
-- Encontrar el rango óptimo de uso de IA que maximiza
-- la mejora del GPA.


-- =============================================================================
-- BUSINESS QUESTION 3
-- ¿La dependencia de IA afecta la retención del conocimiento?
-- =============================================================================

SELECT

    dp.perceived_ai_dependency,

    COUNT(*) AS total_students,

    ROUND(
        AVG(f.skill_retention_score),
        2
    ) AS avg_retention_score,

    ROUND(
        AVG(f.gpa_improvement),
        3
    ) AS avg_gpa_improvement

FROM fact_student_performance f

JOIN dim_psychological dp

    ON f.psychological_key =
       dp.psychological_key

GROUP BY

    dp.perceived_ai_dependency

ORDER BY

    dp.perceived_ai_dependency;

-- Insight esperado:
-- A mayor dependencia de IA,
-- menor retención del conocimiento.


-- =============================================================================
-- BUSINESS QUESTION 4
-- ¿El uso intensivo de IA está relacionado con burnout?
-- =============================================================================

SELECT

    dp.burnout_risk,

    COUNT(*) AS total_students,

    ROUND(
        AVG(f.weekly_genai_hours),
        2
    ) AS avg_ai_hours,

    ROUND(
        AVG(f.gpa_improvement),
        3
    ) AS avg_gpa_improvement

FROM fact_student_performance f

JOIN dim_psychological dp

    ON f.psychological_key =
       dp.psychological_key

GROUP BY

    dp.burnout_risk

ORDER BY

    avg_ai_hours DESC;

-- Insight esperado:
-- Evaluar si estudiantes con mayor burnout
-- utilizan más herramientas de IA.


-- =============================================================================
-- BUSINESS QUESTION 4B
-- Ansiedad durante exámenes vs uso de IA
-- =============================================================================

SELECT

    dp.anxiety_level,

    COUNT(*) AS total_students,

    ROUND(
        AVG(f.weekly_genai_hours),
        2
    ) AS avg_ai_hours

FROM fact_student_performance f

JOIN dim_psychological dp

    ON f.psychological_key =
       dp.psychological_key

GROUP BY

    dp.anxiety_level

ORDER BY

    dp.anxiety_level;

-- Insight esperado:
-- Analizar si la ansiedad aumenta junto
-- con el uso intensivo de IA.


-- =============================================================================
-- BUSINESS QUESTION 5
-- ¿Qué carreras presentan mayor adopción de IA?
-- =============================================================================

SELECT

    dm.major_category,

    COUNT(*) AS total_students,

    ROUND(
        AVG(f.weekly_genai_hours),
        2
    ) AS avg_ai_hours,

    ROUND(
        AVG(f.gpa_improvement),
        3
    ) AS avg_gpa_improvement,

    ROUND(
        AVG(f.post_semester_gpa),
        3
    ) AS avg_post_gpa

FROM fact_student_performance f

JOIN dim_major dm

    ON f.major_key =
       dm.major_key

GROUP BY

    dm.major_category

ORDER BY

    avg_ai_hours DESC;

-- Insight esperado:
-- Identificar las carreras con mayor adopción de IA
-- y comparar su desempeño académico.


-- =============================================================================
-- BUSINESS QUESTION 5B
-- Ranking de carreras por GPA Improvement
-- =============================================================================

WITH major_ranking AS (

    SELECT

        dm.major_category,

        ROUND(
            AVG(f.gpa_improvement),
            3
        ) AS avg_gpa_improvement

    FROM fact_student_performance f

    JOIN dim_major dm

        ON f.major_key =
           dm.major_key

    GROUP BY

        dm.major_category

)

SELECT

    major_category,

    avg_gpa_improvement,

    RANK() OVER(

        ORDER BY
            avg_gpa_improvement DESC

    ) AS ranking

FROM major_ranking

ORDER BY ranking;

-- Insight esperado:
-- Mostrar qué carreras obtienen
-- los mayores beneficios académicos.


-- =============================================================================
-- RESUMEN EJECUTIVO DE KPIs
-- =============================================================================

SELECT

    COUNT(*) AS total_students,

    ROUND(
        AVG(gpa_improvement),
        3
    ) AS avg_gpa_improvement,

    ROUND(
        AVG(weekly_genai_hours),
        2
    ) AS avg_weekly_ai_hours,

    ROUND(
        AVG(skill_retention_score),
        2
    ) AS avg_retention_score,

    ROUND(
        AVG(post_semester_gpa),
        2
    ) AS avg_post_gpa

FROM fact_student_performance;

-- =============================================================================
-- FIN BUSINESS QUESTIONS
-- =============================================================================
