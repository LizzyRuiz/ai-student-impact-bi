# 🎓 Impacto del Uso de la Inteligencia Artificial Generativa en el Rendimiento Académico y Bienestar Estudiantil

## 📋 Resumen Ejecutivo

| Campo | Valor |
|---------|---------|
| Pregunta analítica | ¿Cómo influye el uso de Inteligencia Artificial Generativa en el rendimiento académico, la retención del conocimiento y el bienestar emocional de los estudiantes universitarios? |
| Dataset | AI Student Impact Dataset  — pública (~50,000 registros) |
| Fuente | [Dataset académico sobre adopción de IA Generativa en estudiantes](https://www.kaggle.com/datasets/ranaghulamnabi/ai-usage-and-student-academic-performance-analysis?resource=download) |
| Modelo | Esquema Estrella (Star Schema) con 1 tabla de hechos (fact_student_performance) y 4 dimensiones (dim_major, dim_year, dim_ai_usage, dim_psychological) |
| Infraestructura | Amazon S3 + Amazon Athena + DBeaver |
| ETL | etl_pipeline.py end-to-end con Pandas + SQLAlchemy + validaciones post-carga |
| SQL Avanzado | CTE, Window Functions, Ranking, Percentiles y Agregaciones |
| Dashboard | 4 visualizaciones estáticas (Matplotlib): IA vs GPA, Dependencia vs Retención, Burnout Académico y Comparación por Carrera |
| Objetivo | Identificar patrones de uso de IA que maximicen el rendimiento académico sin afectar el bienestar estudiantil |
| Grano de la Fact Table | Una fila por estudiante |
| Principales KPIs | GPA Improvement, Weekly GenAI Hours, Skill Retention Score, AI Dependency, Burnout Risk Level |

---

# 🎯 Problema y Motivación

La adopción de herramientas de Inteligencia Artificial Generativa está transformando los métodos de aprendizaje universitario.

Aunque estas tecnologías ofrecen beneficios importantes en productividad y acceso al conocimiento, también generan interrogantes relacionadas con:

- Dependencia excesiva de herramientas de IA.
- Disminución en la retención del conocimiento.
- Cambios en los hábitos tradicionales de estudio.
- Impacto sobre el bienestar emocional.
- Incremento potencial del burnout académico.

Las instituciones educativas necesitan comprender cómo el uso de IA influye en el desempeño académico y la salud mental de los estudiantes para diseñar políticas y estrategias educativas más efectivas.

---

# ❓ Preguntas de Negocio

### 1. ¿El uso de IA Generativa mejora el rendimiento académico?

Analizar la relación entre las horas de uso de IA y la mejora del GPA académico.

### 2. ¿Existe un nivel óptimo de uso de IA?

Identificar si existe una cantidad de horas semanales de uso de IA que maximice el rendimiento académico.

### 3. ¿La dependencia de IA afecta la retención del conocimiento?

Evaluar la relación entre dependencia percibida y retención de habilidades académicas.

### 4. ¿El uso intensivo de IA está relacionado con el burnout académico?

Analizar cómo el uso de IA influye en el riesgo de agotamiento y ansiedad.

### 5. ¿Qué carreras presentan mayor adopción de IA?

Comparar patrones de uso de IA entre distintas áreas académicas.

---

# 📦 Origen de los Datos

El dataset contiene información de aproximadamente 50,000 estudiantes universitarios y su interacción con herramientas de Inteligencia Artificial Generativa.

## Variables incluidas

### Información del estudiante

- Student_ID
- Major_Category
- Year_of_Study

### Rendimiento académico

- Pre_Semester_GPA
- Post_Semester_GPA
- Skill_Retention_Score

### Uso de IA

- Weekly_GenAI_Hours
- Primary_Use_Case
- Prompt_Engineering_Skill
- Tool_Diversity
- Paid_Subscription

### Hábitos de estudio

- Traditional_Study_Hours
- Perceived_AI_Dependency

### Factores psicológicos

- Anxiety_Level_During_Exams
- Burnout_Risk_Level
- Institutional_Policy

---

# 🔄 Flujo End-to-End

```text
                    ┌───────────────────────────┐
                    │ AI Student Impact Dataset │
                    │ CSV (~50,000 registros)   │
                    └─────────────┬─────────────┘
                                  │
                                  │ Extract
                                  ▼
                    ┌───────────────────────────┐
                    │ ETL Python                │
                    │                           │
                    │ • Pandas                  │
                    │ • Limpieza de datos       │
                    │ • Transformaciones        │
                    │ • Cálculo de KPIs         │
                    │ • SQLAlchemy              │
                    │ • Validaciones post-carga │
                    └─────────────┬─────────────┘
                                  │
                                  │ Load
                                  ▼
                    ┌───────────────────────────┐
                    │ Amazon S3                 │
                    │ Almacenamiento de datos   │
                    └─────────────┬─────────────┘
                                  │
                                  │ Query
                                  ▼
                    ┌───────────────────────────┐
                    │ Amazon Athena             │
                    │ Consultas SQL             │
                    └─────────────┬─────────────┘
                                  │
                                  │ SQL Analytics
                                  ▼
                    ┌───────────────────────────┐
                    │ DBeaver                   │
                    │ Análisis y consultas      │
                    └─────────────┬─────────────┘
                                  │
                                  │ Export
                                  ▼
                    ┌───────────────────────────┐
                    │ Dashboard Matplotlib      │
                    │                           │
                    │ 1. IA vs GPA              │
                    │ 2. Dependencia vs         │
                    │    Retención              │
                    │ 3. Burnout Académico      │
                    │ 4. Comparación por        │
                    │    Carrera                │
                    └───────────────────────────┘
```

---

# 📁 Estructura del Repositorio

```text
ai-student-impact-bi/
│
├── README.md
│
├── data/
│   └── ai_student_impact_dataset.csv
│
├── scripts/
│   ├── 01_schema_ddl.sql
│   ├── 02_dim_major_populate.sql
│   ├── 03_dim_year_populate.sql
│   ├── 04_dim_ai_usage_populate.sql
│   ├── 05_dim_psychological_populate.sql
│   ├── 06_quality_checks.sql
│   └── etl_pipeline.py
│
├── analisis/
│   └── queries_analiticas.sql
│
├── dashboard/
│   ├── generar_visualizaciones.py
│   └── img/
│       ├── 01_gpa_vs_ai.png
│       ├── 02_dependency_vs_retention.png
│       ├── 03_burnout_analysis.png
│       └── 04_major_comparison.png
│
└── docs/
    └── modelo_dimensional.png
```

---

# 🏗️ Modelo Dimensional

Para soportar el análisis del impacto de la Inteligencia Artificial Generativa en el rendimiento académico y bienestar estudiantil, se diseñó un modelo dimensional tipo Star Schema (Esquema Estrella).

El modelo está compuesto por:

- 1 Tabla de Hechos
- 4 Tablas de Dimensión

Este diseño permite optimizar consultas analíticas en Amazon Athena y facilita la construcción de dashboards y KPIs.

## ⭐ Esquema Estrella

```text
                                      ┌─────────────────────┐
                                      │      dim_major      │
                                      │---------------------│
                                      │ major_key (PK)      │
                                      │ major_category      │
                                      └──────────┬──────────┘
                                                 │
                                                 │
┌─────────────────────┐              ┌──────────────────────────────┐              ┌─────────────────────┐
│      dim_year       │              │  fact_student_performance    │              │    dim_ai_usage     │
│---------------------│              │------------------------------│              │---------------------│
│ year_key (PK)       │───────────── │ student_id                   │ ─────────────│ ai_usage_key (PK)   │
│ year_of_study       │              │ major_key (FK)               │              │ primary_use_case    │
└─────────────────────┘              │ year_key (FK)                │              │ prompt_skill        │
                                     │ ai_usage_key (FK)            │              │ paid_subscription   │
                                     │ psychological_key (FK)       │              └─────────────────────┘
                                     │                              │
                                     │ pre_semester_gpa             │
                                     │ post_semester_gpa            │
                                     │ gpa_improvement              │
                                     │ weekly_genai_hours           │
                                     │ traditional_study_hours      │
                                     │ skill_retention_score        │
                                     │ tool_diversity               │
                                     └──────────────┬───────────────┘
                                                    │
                                                    │
                                      ┌────────────────────────────┐
                                      │     dim_psychological      │
                                      │----------------------------│
                                      │ psychological_key (PK)     │
                                      │ ai_dependency              │
                                      │ anxiety_level              │
                                      │ burnout_risk               │
                                      │ institutional_policy       │
                                      └────────────────────────────┘
```

## 🔗 Relaciones del Modelo

| Tabla Dimensión | Llave Primaria | Relación |
|----------------|----------------|-----------|
| dim_major | major_key | 1:N |
| dim_year | year_key | 1:N |
| dim_ai_usage | ai_usage_key | 1:N |
| dim_psychological | psychological_key | 1:N |

## 🎯 Propósito Analítico del Modelo

- Analizar la relación entre uso de IA y rendimiento académico.
- Medir el impacto de la dependencia tecnológica en la retención del conocimiento.
- Evaluar factores asociados al burnout académico.
- Comparar comportamientos entre carreras y años académicos.
- Generar KPIs para apoyar decisiones educativas.

## 📈 Beneficios del Diseño

- Optimización de consultas en Athena.
- Menor complejidad de JOINs.
- Escalabilidad para futuras dimensiones.
- Facilidad para generar KPIs y dashboards.
- Aplicación de buenas prácticas de Business Intelligence.

---
## Data Quality Validation

El proyecto incorpora controles de calidad posteriores al proceso ETL para validar:

- Duplicados de estudiantes
- Integridad referencial
- Rangos válidos de GPA
- Rangos válidos de horas de estudio
- Consistencia de KPIs calculados
- Distribución de dimensiones

Estas validaciones se ejecutan mediante el script:

scripts/06_quality_checks.sql

---

# 💻 SQL Avanzado

Las consultas analíticas utilizarán:

- Common Table Expressions (CTE)
- Window Functions
- Ranking
- Percentiles
- Agregaciones
- KPIs Académicos
- Análisis de Dependencia
- Análisis de Burnout

---

# 📊 Dashboard

### 1. IA vs GPA

**Tipo:** Scatter Plot

**Objetivo:** Analizar la relación entre horas de uso de IA y mejora del GPA.

### 2. Dependencia vs Retención

**Tipo:** Heatmap

**Objetivo:** Evaluar cómo la dependencia percibida afecta la retención del conocimiento.

### 3. Burnout Académico

**Tipo:** Bar Chart

**Objetivo:** Analizar la distribución del riesgo de burnout según niveles de uso de IA.

### 4. Comparación por Carrera

**Tipo:** Horizontal Bar Chart

**Objetivo:** Comparar GPA, uso de IA y riesgo de burnout entre áreas académicas.

---

# 📈 KPIs Principales

- GPA Improvement
- Average Weekly GenAI Hours
- Average Skill Retention Score
- Average AI Dependency
- Burnout Risk Distribution
- Anxiety Level Distribution
- Paid Subscription Adoption Rate
- Prompt Engineering Skill Level

---

# 📊 Resultados y Hallazgos de Negocio

---

# 1. ¿El uso de IA Generativa mejora el rendimiento académico?

## Consulta SQL

```sql
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
    ) AS avg_gpa_improvement

FROM fact_student_performance

GROUP BY 1

ORDER BY 1;
```

## Analisis
Se analizó la relación entre las horas semanales de uso de Inteligencia Artificial Generativa y la mejora del GPA académico (GPA Improvement).
La segmentación de estudiantes por niveles de uso permitió observar que el impacto de la IA no es lineal.

## Visualización

![IA vs GPA](dashboard/img/01_optimal_ai_vs_gpa.png)

## Hallazgo

Los estudiantes que utilizan herramientas de IA de manera moderada obtienen mejores resultados académicos que aquellos que las utilizan muy poco o en exceso.
Se observó que la mejora promedio del GPA alcanza su punto más alto cuando el uso semanal se encuentra entre:
5 y 10 horas semanales
10 y 15 horas semanales.

## Conclusión

El uso de IA Generativa puede mejorar el rendimiento académico cuando se utiliza como herramienta de apoyo al aprendizaje y no como sustituto del estudio tradicional.

---

# 2. ¿Existe un nivel óptimo de uso de IA?

## Consulta SQL

```sql
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
```
## Analisis
Se agruparon los estudiantes por rangos de horas semanales de uso de IA y se calculó el GPA Improvement promedio para cada grupo.

## Visualización

![Nivel Óptimo de Uso de IA](dashboard/img/01_optimal_ai_vs_gpa.png)

## Hallazgo

El beneficio académico aumenta progresivamente hasta alcanzar un máximo en el rango de:
5 a 15 horas por semana
Después de este punto, la mejora comienza a estabilizarse e incluso disminuir.

## Conclusión

Existe evidencia de rendimientos decrecientes asociados al uso excesivo de IA.
Las instituciones educativas deberían fomentar un uso equilibrado y guiado de estas herramientas.

---

# 3. ¿La dependencia de IA afecta la retención del conocimiento?

## Consulta SQL

```sql
SELECT

    dp.perceived_ai_dependency,

    ROUND(
        AVG(f.skill_retention_score),
        2
    ) AS avg_retention_score

FROM fact_student_performance f

JOIN dim_psychological dp

    ON f.psychological_key =
       dp.psychological_key

GROUP BY

    dp.perceived_ai_dependency

ORDER BY

    dp.perceived_ai_dependency;
```

## Analisis
Se comparó el nivel de dependencia percibida hacia la IA con el indicador de retención de habilidades académicas (Skill Retention Score).

## Visualización

![Dependencia vs Retención](dashboard/img/02_dependency_retention.png)

## Hallazgo

Los estudiantes con niveles más altos de dependencia presentan menores niveles de retención del conocimiento.
La reducción es consistente conforme aumenta la dependencia tecnológica.

## Conclusión

La IA es una herramienta poderosa para aumentar la productividad, pero una dependencia excesiva puede disminuir la consolidación de conocimientos y habilidades cognitivas.
Las universidades deben promover estrategias que combinen IA con aprendizaje activo.

---

# 4. ¿El uso intensivo de IA está relacionado con el burnout académico?

## Consulta SQL

```sql
SELECT

    dp.burnout_risk,

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

    dp.burnout_risk

ORDER BY

    avg_ai_hours DESC;
```

## Analisis
Se analizaron los niveles de burnout y ansiedad en función de las horas semanales de uso de IA.

## Visualización

![Burnout Académico](dashboard/img/03_burnout_vs_ai_usage.png)

## Hallazgo

Los estudiantes con riesgo alto de burnout utilizan significativamente más horas de IA que aquellos con riesgo bajo.
También se identificó una asociación positiva entre:
Uso intensivo de IA
Mayor ansiedad durante exámenes
Mayor riesgo de agotamiento académico

## Conclusión

El uso intensivo de IA puede convertirse en un indicador de sobrecarga académica o dependencia tecnológica.
Las instituciones deberían monitorear estos patrones para prevenir riesgos de bienestar estudiantil.

---

# 5. ¿Qué carreras presentan mayor adopción de IA?

## Consulta SQL

```sql
SELECT

    dm.major_category,

    ROUND(
        AVG(f.weekly_genai_hours),
        2
    ) AS avg_ai_hours,

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

ORDER BY

    avg_ai_hours DESC;
```
## Analisis
Se comparó el promedio de horas semanales de uso de IA entre las distintas categorías académicas.

## Visualización

![Adopción de IA por Carrera](dashboard/img/04_major_ai_adoption.png)

## Hallazgo

Las carreras STEM presentan la mayor adopción de herramientas de Inteligencia Artificial Generativa.
Las áreas con mayor uso incluyen:
Ciencia
Tecnología
Ingeniería
Matemáticas
Además, estas carreras muestran una de las mayores mejoras promedio de GPA.

## Conclusión

La adopción de IA es más alta en disciplinas con fuerte orientación tecnológica y analítica.
Esto sugiere que la familiaridad con herramientas digitales facilita una integración más efectiva de la IA en los procesos de aprendizaje.

---

# 📈 KPIs Principales

| KPI | Descripción |
|------|------|
| GPA Improvement | Diferencia entre GPA posterior y GPA previo al semestre |
| Average Weekly GenAI Hours | Promedio de horas semanales de uso de IA |
| Average Skill Retention Score | Nivel promedio de retención del conocimiento |
| Average AI Dependency | Dependencia percibida hacia herramientas de IA |
| Burnout Risk Distribution | Distribución de estudiantes por nivel de burnout |
| Anxiety Level Distribution | Distribución de niveles de ansiedad |
| Paid Subscription Adoption Rate | Porcentaje de estudiantes con suscripción premium |
| Prompt Engineering Skill Level | Nivel de habilidad en Prompt Engineering |

---

# 🎯 Conclusión Ejecutiva

El análisis de aproximadamente **50,000 estudiantes universitarios** demuestra que la Inteligencia Artificial Generativa puede mejorar el desempeño académico cuando se utiliza de forma moderada.

Los resultados sugieren que:

- Existe un rango óptimo de uso entre **5 y 15 horas semanales**.
- La dependencia excesiva puede reducir la retención del conocimiento.
- Los estudiantes con mayor uso de IA muestran mayores indicadores de burnout y ansiedad.
- Las carreras STEM presentan la mayor adopción y obtienen los mayores beneficios académicos.

En conjunto, los hallazgos indican que la IA Generativa debe utilizarse como una herramienta complementaria al aprendizaje y no como un sustituto de los procesos tradicionales de estudio.

---

# 📂 Evidencia Visual

## IA vs GPA

![IA vs GPA](dashboard/img/01_optimal_ai_vs_gpa.png)

## Dependencia vs Retención

![Dependencia vs Retención](dashboard/img/02_dependency_retention.png)

## Burnout Académico

![Burnout Académico](dashboard/img/03_burnout_vs_ai_usage.png)

## Adopción de IA por Carrera

![Adopción IA por Carrera](dashboard/img/04_major_ai_adoption.png)

---

# 🚀 Tecnologías Utilizadas

- Python
- Pandas
- SQLAlchemy
- Amazon S3
- Amazon Athena
- DBeaver
- SQL
- Matplotlib
- GitHub

---

# 👨‍💻 Autor - Elizabeth Ruiz

Proyecto desarrollado como parte de un Diplomado Manejo de bases de datos SQL y NoSQL en un entorno de nube.

**Año:** 2026
