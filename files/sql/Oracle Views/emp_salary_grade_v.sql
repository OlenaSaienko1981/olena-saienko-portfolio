create view emp_salary_grade_v as
select
    employee_id,
    first_name,
    last_name,
    salary,
case
    -- Boundaries: 4,000 and 9,000 are included in the medium grade
    when salary < 4000 then 'LOW'
    when salary <= 9000 then 'MEDIUM'
    else 'HIGH'
end as salary_grade
from employees;
    