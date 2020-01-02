select last_name,salary
from employees
where salary>(select min(salary) from employees where job_id='IT_PROG');

select last_name,employee_id
from employees
where employee_id not in(select manager_id from employees where manager_id is not null);

**Subqueries Assignment**

!--question1
 select last_name,hire_date
 from employees 
 where last_name!='Smith' and department_id in
 (select department_id from employees where last_name='Smith');
 
 !--question2
 select employee_id,last_name
 from employees 
 where salary>(select avg(salary) from employees)
 order by salary;
 
 !---question3
 select employee_id,last_name
 from employees 
 where department_id in(select department_id from employees where last_name like '%u%');
 
 !--question4
 select last_name,department_id,job_id
 from employees
 where department_id in(
 select d.department_id from departments d,locations l
 where d.location_id=l.location_id and l.location_id=1700);
 !--question5
 select last_name,salary
 from employees
 where manager_id in (select distinct employee_id from employees where last_name='King');
 
 !--question 6
 select last_name,department_id,job_id
 from employees
 where department_id=(select department_id from departments where department_name='Executive');
 
 !--question 7
 select employee_id,last_name,salary
 from employees
 where salary>
 (select avg(salary) from employees)
 and department_id in
 (select department_id from employees where last_name like '%u%');