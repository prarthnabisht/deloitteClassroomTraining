set SERVEROUT on
set verify off
declare
vname employees.last_name%type;
vsal employees.salary%type;
begin
select last_name,salary
into vname,vsal
from employees
where employee_id=&empid;
exception
when no_data_found THEN
dbms_output.put_line('No emps');
when too_many_rows then
dbms_output.put_line('More than one employee');
end;
/

!--too many rows

declare
vname employees.last_name%type;
vsal employees.salary%type;
begin
select last_name,salary
into vname,vsal
from employees
where employee_id in (&empid);
dbms_output.put_line(vname||'  '||vsal);
exception
when no_data_found THEN
dbms_output.put_line('No emps');
when too_many_rows then
dbms_output.put_line('More than one employee');
end;
/

!--unnamed exceptions

declare
emp_exist Exception;
pragma exception_init(emp_exist,-2292);
begin
delete from departments 
where department_id=&deptid;
exception
when emp_exist THEN
dbms_output.put_line('can not delete row');
end;
/


!-- named user defined exceptions

declare
v_age number :=&age;
invalid_age exception;
begin
if v_age not between 21 and 60 then
raise invalid_age;
else dbms_output.put_line('You are eligible');
end if;
exception
when invalid_age then
dbms_output.put_line('Age must be between 21 and 60');
end;
/

!--unnamed user defined exceptions

declare
v_age number :=&age;
begin
if v_age not between 21 and 60 then
raise_application_error(-20111,'Age must be between 21 to 60');
else dbms_output.put_line('You are eligible');
end if;
end;
/

!-- fetching multiple rows Using CURSORS

begin
delete from departments where department_id=240;
dbms_output.put_line(SQL%ROWCOUNT||' Rows deleted');
end;
/


!-- explicit cursors

declare 
cursor c1 is select last_name,job_id,salary
from employees
where salary between 5000 and 15000;
erec c1%rowtype;
BEGIN
open c1;
loop
fetch c1 into erec;
exit when c1%notfound;
dbms_output.put_line(erec.last_name||' '||erec.job_id||' '||erec.salary);
end loop;
close c1;
END

!--cusror using for loop

declare 
cursor c1
is select last_name,job_id,salary
from employees
where salary between 5000 and 15000;
begin
for erec in c1
loop
dbms_output.put_line(erec.last_name||' '||erec.job_id||' '||erec.salary);
end loop;
end;
/
!-- new emp table

create table emp as select * from employees;
!--explicit row locking

declare 
cursor c1
is select last_name,job_id,salary
from emp
where salary between 5000 and 15000
for update nowait;
begin
for erec in c1
loop
dbms_output.put_line(erec.last_name||' '||erec.job_id||' '||erec.salary);
delete from emp where last_name='Higgins';
end loop;
end;
/

rollback;

!-- wait for specified time

declare 
cursor c1
is select last_name,job_id,salary
from employees
where salary between 5000 and 15000
for update wait 4;
begin
for erec in c1
loop
dbms_output.put_line(erec.last_name||' '||erec.job_id||' '||erec.salary);
delete from emp where last_name='Higgins';
end loop;
end;
/

rollback;

!--procedures
create or replace procedure INC_SALARY
(p_id in employees.employee_id%type)
is 
begin
update employees
set salary=salary*1.10
where employees.employee_id=p_id;
end INC_SALARY;

select last_name,salary from employees where employee_id in(101,102);
exec INC_SALARY(101);
select last_name,salary from employees where employee_id in(101,102);

!-- out parameters

create or replace procedure QUERY1
(p_id in employees.employee_id%type,
p_name out employees.last_name%type,
p_sal out employees.salary%type,
p_comm out employees.commission_pct%type)
is
begin
select last_name,salary,commission_pct
into p_name,p_sal,p_comm
from employees
where employee_id=p_id;
end QUERY1;


var x varchar2(40);
var y number;
var z number;

exec QUERY1(101,:x,:y,:z);
PRINT x;
 
 
!--Functions

create or replace function add1(x number,y number)
return number
is 
begin
return(x+y);
end;

/
 
var x1 number;
exec :x1:= add1(2,3);
print x1;

!-- other way of calling

select add1(22,33) from dual;

!--SQL TRIGGERS

create table log_tab
(username varchar2(30), dml_time timestamp, action varchar2(40));
desc log_tab;

create or replace trigger emp_trig1
before delete on emp_tab
begin
insert into log_tab
values(user,current_timestamp,'b4 delete row');
end;
/

!-- trigger for restricting dml activities

create or replace trigger t1
before insert or update or delete on employees
begin
if  to_char(sysdate,'hh24')  between 9 and 18
or to_char(sysdate,'dy') in ('sat','sun')
then raise_application_error(-20033,'do not work on weekends or shift hours');
end if;
end;
/

update employees
set salary=salary+2
where employee_id=100;


!--new trigger

create table ex_emp
as
select employee_id,last_name,job_id
from employees
where 1=2;

create table emp1 as select * from employees;
create or replace trigger add_to_ex_emp1
before delete on emp1
for each row
begin
insert into ex_emp
values(:old.employee_id,:old.last_name,:old.job_id);
end;
/

DELETE FROM emp1 WHERE employee_id=101; 
select * from ex_emp;

rollback;

select * from emp1 where employee_id=101;

!-- update trigger

create or replace trigger res_update1
before update on emp1
for each row
begin
if
:new.salary<:old.salary
then 
raise_application_error(-20123,'New salary cannot be less than old salary');
rollback;
end if;
end;
/
update emp1
set salary=salary-100
where employee_id=101;

select salary from emp1 where employee_id=101;

!--function

create or replace function take_home_sal
(f1_empid emp1.employee_id%type)
return number
is
thsal number;
begin
select emp1.salary+nvl(emp1.commission_pct,0) into thsal from emp1 where emp1.employee_id=f1_empid;
return thsal;
end;
/


var thsal1 number;

exec :thsal1:=take_home_sal(101);
print thsal1;

