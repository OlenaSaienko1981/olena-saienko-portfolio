WITH
/* STEP 1: Position of each salary inside its job grade band */
job_band AS
(
    SELECT
        e.employee_id,
        j.min_salary,
        j.max_salary,
        ROUND(
            (e.salary - j.min_salary)
            / NULLIF(j.max_salary - j.min_salary, 0) * 100,
            2
        ) AS band_position_pct
    FROM employees e
    JOIN jobs j
        ON j.job_id = e.job_id
),

/* STEP 2: Identify managers */
manager_stats AS
(
    SELECT
        manager_id,
        COUNT(*) AS direct_reports
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
),

/* STEP 3: Calculate salary analytics */
salary_stats AS
(
    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        e.department_id,
        e.job_id,
        e.salary,
        e.hire_date,

        AVG(e.salary) OVER (
            PARTITION BY e.department_id
        ) AS dept_avg_salary,

        MEDIAN(e.salary) OVER (
            PARTITION BY e.department_id
        ) AS dept_median_salary,

        AVG(e.salary) OVER (
            PARTITION BY e.job_id
        ) AS job_avg_salary,

        COUNT(*) OVER (
            PARTITION BY e.department_id
        ) AS dept_employee_count,

        DENSE_RANK() OVER (
            PARTITION BY e.department_id
            ORDER BY e.salary DESC NULLS LAST
        ) AS dept_salary_rank,

        TRUNC(
            MONTHS_BETWEEN(SYSDATE, e.hire_date) / 12
        ) AS tenure_years

    FROM employees e
),

/* STEP 4: Enrich with band and management data, classify risk */
employee_analysis AS
(
    SELECT
        s.*,
        b.min_salary,
        b.max_salary,
        b.band_position_pct,
        NVL(m.direct_reports, 0) AS direct_reports,

        CASE
            WHEN s.tenure_years > 5
                 AND s.salary < s.job_avg_salary * 0.85
                 AND b.band_position_pct < 25
                THEN 'HIGH'
            WHEN s.salary < s.job_avg_salary
                 OR (
                     s.tenure_years > 7
                     AND b.band_position_pct < 50
                 )
                THEN 'MEDIUM'
            ELSE 'LOW'
        END AS retention_risk

    FROM salary_stats s

    LEFT JOIN job_band b
        ON b.employee_id = s.employee_id

    LEFT JOIN manager_stats m
        ON m.manager_id = s.employee_id
)

/* STEP 5: Final management report */
SELECT
    a.employee_id,

    a.first_name || ' ' || a.last_name
        AS employee_name,

    d.department_name,
    j.job_title,

    a.salary,
    a.min_salary  AS job_min_salary,
    a.max_salary  AS job_max_salary,
    a.band_position_pct,

    ROUND(a.dept_avg_salary, 2)
        AS dept_avg_salary,

    a.dept_median_salary,

    ROUND(a.job_avg_salary, 2)
        AS job_avg_salary,

    ROUND(
        (a.salary - a.dept_avg_salary)
        / NULLIF(a.dept_avg_salary, 0) * 100,
        2
    ) AS salary_vs_dept_pct,

    ROUND(
        (a.salary - a.job_avg_salary)
        / NULLIF(a.job_avg_salary, 0) * 100,
        2
    ) AS salary_vs_job_pct,

    a.dept_salary_rank,
    a.tenure_years,
    a.direct_reports,

    CASE
        WHEN a.direct_reports > 0
            THEN 'MANAGER'
        ELSE 'NON_MANAGER'
    END AS management_status,

    a.retention_risk

FROM employee_analysis a

JOIN departments d
    ON d.department_id = a.department_id

JOIN jobs j
    ON j.job_id = a.job_id

WHERE a.dept_employee_count >= 3

ORDER BY
    DECODE(a.retention_risk, 'HIGH', 1, 'MEDIUM', 2, 3),
    d.department_name,
    a.salary DESC NULLS LAST,
    a.employee_id;
