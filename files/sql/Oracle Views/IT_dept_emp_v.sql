create view IT_dept_emp_v as
select 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name
from employees e
join departments d
    on e.department_id = d.department_id
where d.department_name = 'IT'
with check option;
