"""
Genera las 4 visualizaciones del proyecto AI Student Impact BI.

Si la variable de entorno DB_HOST está definida,
consulta datos reales del Data Warehouse.

Si no existe conexión, genera datos sintéticos para
visualizar el dashboard.

Salida:

dashboard/img/
├── 01_gpa_vs_ai.png
├── 02_dependency_vs_retention.png
├── 03_burnout_analysis.png
└── 04_major_comparison.png
"""

import os
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# =============================================================================
# Configuración
# =============================================================================

OUT = Path(__file__).parent / "img"
OUT.mkdir(exist_ok=True)

USE_DB = bool(os.environ.get("DB_HOST"))

# =============================================================================
# Datos sintéticos
# =============================================================================

def generar_sintetico():

    rng = np.random.default_rng(seed=42)

    n = 5000

    df = pd.DataFrame({

        "student_id":
            range(1, n + 1),

        "weekly_genai_hours":
            np.clip(
                rng.normal(12, 5, n),
                0,
                40
            ),

        "gpa_improvement":
            rng.normal(
                0.25,
                0.15,
                n
            ),

        "skill_retention_score":
            np.clip(
                rng.normal(75, 12, n),
                0,
                100
            ),

        "perceived_ai_dependency":
            rng.choice(
                ["Low", "Medium", "High"],
                n,
                p=[0.30, 0.45, 0.25]
            ),

        "prompt_engineering_skill":
            rng.choice(
                ["Beginner", "Intermediate", "Advanced"],
                n,
                p=[0.45, 0.40, 0.15]
            ),

        "burnout_risk_level":
            rng.choice(
                ["Low", "Medium", "High"],
                n,
                p=[0.35, 0.45, 0.20]
            ),

        "major_category":
            rng.choice(
                [
                    "STEM",
                    "Business",
                    "Humanities",
                    "Medical",
                    "Arts"
                ],
                n
            ),

        "post_semester_gpa":
            np.clip(
                rng.normal(3.2, 0.4, n),
                0,
                4
            )
    })

    return df

# =============================================================================
# Datos reales
# =============================================================================

def consultar_dwh():

    from sqlalchemy import create_engine

    engine = create_engine(
        f"postgresql+psycopg2://"
        f"{os.environ['DB_USER']}:"
        f"{os.environ['DB_PASSWORD']}@"
        f"{os.environ['DB_HOST']}:5432/"
        f"{os.environ['DB_NAME']}"
    )

    query = """
    SELECT

        f.student_id,
        f.weekly_genai_hours,
        f.gpa_improvement,
        f.skill_retention_score,
        f.post_semester_gpa,

        m.major_category,

        p.perceived_ai_dependency,
        p.burnout_risk_level,

        a.prompt_skill

    FROM fact_student_performance f

    JOIN dim_major m
        ON f.major_key = m.major_key

    JOIN dim_psychological p
        ON f.psychological_key = p.psychological_key

    JOIN dim_ai_usage a
        ON f.ai_usage_key = a.ai_usage_key
    """

    return pd.read_sql(query, engine)

# =============================================================================
# Carga de datos
# =============================================================================

print(
    f"Modo: {'Base de Datos' if USE_DB else 'Sintético'}"
)

df = (
    consultar_dwh()
    if USE_DB
    else generar_sintetico()
)

# =============================================================================
# Visualización 1
# IA vs GPA
# =============================================================================

fig, ax = plt.subplots(figsize=(10, 6))

ax.scatter(
    df["weekly_genai_hours"],
    df["gpa_improvement"],
    alpha=0.4
)

ax.set_title(
    "Uso de IA vs Mejora Académica"
)

ax.set_xlabel(
    "Horas Semanales de IA"
)

ax.set_ylabel(
    "GPA Improvement"
)

ax.grid(True, alpha=0.3)

plt.tight_layout()

plt.savefig(
    OUT / "01_gpa_vs_ai.png",
    dpi=120
)

plt.close()

# =============================================================================
# Visualización 2
# Dependencia vs Retención
# =============================================================================

dependency_order = [
    "Low",
    "Medium",
    "High"
]

skill_order = [
    "Beginner",
    "Intermediate",
    "Advanced"
]

heatmap_df = pd.pivot_table(

    df,

    values="skill_retention_score",

    index="perceived_ai_dependency",

    columns="prompt_engineering_skill",

    aggfunc="mean"

)

heatmap_df = heatmap_df.reindex(
    dependency_order
)

heatmap_df = heatmap_df[
    skill_order
]

fig, ax = plt.subplots(
    figsize=(8, 6)
)

im = ax.imshow(
    heatmap_df.values,
    aspect="auto"
)

ax.set_xticks(
    range(len(skill_order))
)

ax.set_xticklabels(
    skill_order
)

ax.set_yticks(
    range(len(dependency_order))
)

ax.set_yticklabels(
    dependency_order
)

ax.set_title(
    "Dependencia de IA vs Retención del Conocimiento"
)

ax.set_xlabel(
    "Prompt Engineering Skill"
)

ax.set_ylabel(
    "AI Dependency"
)

plt.colorbar(
    im,
    ax=ax,
    label="Skill Retention Score"
)

plt.tight_layout()

plt.savefig(
    OUT / "02_dependency_vs_retention.png",
    dpi=120
)

plt.close()

# =============================================================================
# Visualización 3
# Burnout Académico
# =============================================================================

burnout = (

    df.groupby(
        "burnout_risk_level"
    )

    .size()

    .reset_index(
        name="total"
    )

)

burnout = burnout.sort_values(
    "total",
    ascending=False
)

fig, ax = plt.subplots(
    figsize=(8, 5)
)

ax.bar(
    burnout["burnout_risk_level"],
    burnout["total"]
)

ax.set_title(
    "Distribución del Riesgo de Burnout"
)

ax.set_xlabel(
    "Nivel de Burnout"
)

ax.set_ylabel(
    "Número de Estudiantes"
)

ax.grid(
    axis="y",
    alpha=0.3
)

plt.tight_layout()

plt.savefig(
    OUT / "03_burnout_analysis.png",
    dpi=120
)

plt.close()

# =============================================================================
# Visualización 4
# Comparación por Carrera
# =============================================================================

major_df = (

    df.groupby(
        "major_category"
    )["post_semester_gpa"]

    .mean()

    .reset_index()

    .sort_values(
        "post_semester_gpa"
    )

)

fig, ax = plt.subplots(
    figsize=(10, 6)
)

ax.barh(
    major_df["major_category"],
    major_df["post_semester_gpa"]
)

ax.set_title(
    "GPA Promedio por Carrera"
)

ax.set_xlabel(
    "Post Semester GPA"
)

ax.set_ylabel(
    "Carrera"
)

ax.grid(
    axis="x",
    alpha=0.3
)

for i, value in enumerate(
    major_df["post_semester_gpa"]
):
    ax.text(
        value + 0.02,
        i,
        f"{value:.2f}",
        va="center"
    )

plt.tight_layout()

plt.savefig(
    OUT / "04_major_comparison.png",
    dpi=120
)

plt.close()

# =============================================================================
# Fin
# =============================================================================

print(
    f"✓ 4 visualizaciones generadas en {OUT}/"
)
