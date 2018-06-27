--20180627

create table emp(
   id number primary key, 
   name varchar2(10) not null,
   salary  number,
   bonus number default 100
   );
   
insert into emp(id,name,salary) values(1001,'jijoe',150);
insert into emp(id,name,salary) values(1002,'cho',130);
insert into emp(id,name,salary) values(1003,'kim',140);
select * from emp;
commit;


create table bonus(id number, bonus number default 100);

insert into bonus(id) (select e.id from emp e);

select * from bonus;

merge into bonus D
    using (select id,salary from emp) S
    on (D.id = S.id)
    when matched then update set
    D.bonus=D.bonus + S.salary*0.01
    when not matched then insert(D.id, D.bonus)
    values(S.id,S.salary*0.01);
