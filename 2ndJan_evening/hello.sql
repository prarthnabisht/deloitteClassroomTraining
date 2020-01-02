set serverout on
set verify off
declare
type num_tab_type is table of number
index by binary_integer;
num_tab num_tab_type;
begin
for i in 1..10
loop
num_tab(i):=i*10;
end loop;
for i in num_tab.first..num_tab.last
loop
dbms_output.put_line(num_tab(i));
end loop;
end;
/


!---new table

set serverout on
set verify off
declare
type emp_record_type is record
(
lname employees.last_name%type,
sal employees.salary%type
);
type num_tab_type is table of emp_record_type
index by binary_integer;
num_tab num_tab_type;
begin
for i in 100..109
loop
select last_name,salary
into num_tab(i)
from employees
where employee_id=(i);
end loop;
for i in num_tab.first..num_tab.last
loop
dbms_output.put_line(num_tab(i).lname);
dbms_output.put_line(num_tab(i).sal);
end loop;
end;
/