WITH emp_stats AS
(
    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        e.department_id,
        e.job_id,
        e.salary,
        e.hire_date,
        AVG(e.salary)    OVER (PARTITION BY e.department_id) AS dept_avg_salary,
        MEDIAN(e.salary) OVER (PARTITION BY e.department_id) AS dept_median_salary,
        SUM(e.salary)    OVER (PARTITION BY e.department_id) AS dept_total_payroll,
        COUNT(*)         OVER (PARTITION BY e.department_id) AS dept_employee_count,
        DENSE_RANK()     OVER (PARTITION BY e.department_id
                               ORDER BY e.salary DESC NULLS LAST) AS salary_rank,
        AVG(e.salary)    OVER ()                             AS company_avg_salary
    FROM employees e                                          -- [OPT 1] single table, narrow rows
)
SELECT
    s.employee_id,
    s.first_name || ' ' || s.last_name               AS employee_name,          -- [OPT 5]
    d.department_name,
    j.job_title,
    s.salary,
    ROUND(s.dept_avg_salary, 2)                      AS dept_avg_salary,
    s.dept_median_salary,
    ROUND(s.company_avg_salary, 2)                   AS company_avg_salary,
    s.salary_rank,
    s.dept_employee_count,
    ROUND( (s.salary - s.dept_avg_salary) / NULLIF(s.dept_avg_salary, 0) * 100, 2 )
                                                     AS salary_vs_dept_avg_pct,
    ROUND( s.salary / NULLIF(s.dept_total_payroll, 0) * 100, 2 )
                                                     AS payroll_share_pct,
    TRUNC( MONTHS_BETWEEN(SYSDATE, s.hire_date) / 12 )
                                                     AS tenure_years,
    CASE
        WHEN s.salary IS NULL                   THEN NULL
        WHEN s.salary > s.dept_avg_salary * 1.20 THEN 'HIGH'
        WHEN s.salary < s.dept_avg_salary * 0.80 THEN 'LOW'
        ELSE 'NORMAL'
    END                                              AS salary_category,
    CASE
        WHEN s.salary_rank <= 3 AND s.salary IS NOT NULL THEN 'TOP_EARNER'
    END                                              AS top_earner_flag
FROM emp_stats s
JOIN departments d                                                              -- [OPT 3] / [OPT 4]
  ON d.department_id = s.department_id
JOIN jobs j                                                                     -- [OPT 3]
  ON j.job_id = s.job_id
WHERE s.dept_employee_count >= 3
ORDER BY
    d.department_name,
    s.salary_rank,
    employee_name,
    s.employee_id;