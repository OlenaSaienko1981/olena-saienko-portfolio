with employee_base as
(
select
e.employee_id,
e.first_name || " " || e.last_name as employee_name,
e.department_id,
d.department_name,
j.job_title,
e.salary,
e.hire_date
from employees e
join departments d
on e.department_id = d.department_id
join jobs j
on e.job_id = j.job_id
),
salary_analysis as
(
select
eb.employee_id,
eb.employee_name,
eb.department_id,
eb.department_name,
eb.job_title,
eb.salary,
eb.hire_date,
round(
avg(eb.salary) over(
partition by department_id
), 2
) as dept_avg_salary,
median(eb.salary) over(
partition by department_id
) as dept_median_salary,
round(
avg(eb.salary) over(), 2
) as company_avg_salalry,
sum(eb.salary) over(
partition by department_id
) as dept_total_payroll,
count(*) over(
partition by department_id
) as dept_employee_count,
dense_rank over(
partition by eb.department_id
order by eb.salary desc
) as salary_rank
from employee_base eb
)
select 
employee_id,
employee_name,
department_name,
job_title,
salary,
dept_avg_salary,
dept_median_salary,
company_avg_salary,
salary_rank,
dept_employee_count,
round(
(salary - dept_avg_salary)
/ nullif(dept_avg_salary,0)*100,
2
) as salary_vs_dept_avg_pct,
round(
salary
/ nullif(dept_total_payroll,0)*100,
2
) as payroll_share_pct,
trunc(
months_between(sysdate, hire_date)/12
) as tenure_years,
case
when salary > dept_avg_salary * 1.2
then 'HIGH'
when salary < dept_avg_salary * 0.8
then 'LOW'
else 'NORMAL'
end as salary_category,
case
when salary_rank <= 3
then 'Top_Earner'
else null
end as top_earner_flag
from salary_analysis
where dept_employee_count >= 3
order by
department_name,
salary_rank,
employee_name;

