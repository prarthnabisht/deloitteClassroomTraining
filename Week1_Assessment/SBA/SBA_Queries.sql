
!--question 2 part (a)

select sname 
from sailors s,boats b,reserves r
where s.sid1=r.sid1 and r.bid=b.bid and b.color='Red';


!--question2 part (b)
select sname
from sailors
where sid1 in
(select sid1 from reserves);

!--question2 part (c)

select sname,age 
from  sailors
where sname like 'B%B' and length(sname)>=3;

!--question 2 part (d)

create table sailors
(sid1 number(2) PRIMARY KEY,
sname varchar2(40),
rating number,
age decimal(4,1));


create or replace trigger t_restrict
before insert or update or delete on reserves
begin
if to_char(sysdate,'Day')='Monday' or to_char(sysdate,'Day')='Friday'
then
raise_application_error(-20111,'can not alter table on monday and friday');
end if;
end;
/






