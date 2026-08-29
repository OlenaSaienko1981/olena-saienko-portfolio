create view high_earners_v as
select 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
from employees e
join departments d
    on e.department_id = d.department_id
where e.salary >
    (select avg(salary)
    from employees
    );