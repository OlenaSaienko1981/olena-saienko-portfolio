create view dept_manager_status_v as
select
    d.department_id,
    d.department_name,
    nvl(e.first_name || ' ' || e.last_name, 'vacant') as manager_name
from departments d
left join employees e
    on d.manager_id = e.employee_id;