--20180627

--[����Ŭ DATA TYPE]
--1. char == char(1) == char(1 byte) 2000 bytes ��������
--                      char(1 char)
--2. [n]char == nchar(1) unicode 1���� 2000 bytes ��������

-- ( ������ )
--3. [var]char == varchar2( size [byte| char]) 4000 bytes ��������
--  ex) name char(20)       == char(20byte)         'kenik---------------'
--      name varchar2(20)   == varchar2(20 bytes)   'kenik' �ѱ�6����,
--4. [n][var]char2 == nchar(1) unicode 1���� 4000 bytes ��������
--  ex) name nchar(10)      1���� 2byte   'lee----' 6bytes + 4bytes
--      name nvarchar(10)                'lee' 6bytes

--5. long  �ڹ� byte < short < int < long ������(����)
--  ���� �ڷ��� , 2GB, ��������

--6. NUMBER[(p,[s])]
--      p:1~38 ,s:-94~127
--      age number      == number(38, 127)
--      age number(3)   p  =   age number(3,0) 
--      age number(5,2) p,s

-- [p]recision ��ü �ڸ��� ( ���е�*** )
-- [S]cale     �Ҽ��� ���� �ڸ��� ( �ִ� ��ȿ���� �ڸ� �� ) 
-- 1~22byte
-- 

--p58 ��¥ ������ Ÿ��
-- DATE     BC4712�� 1�� 1�� ~ 9999�� 12�� 31�� ��/��/��/��/��/�� ����
--


--���̺� ����, ����, ���� ��� p48
--1. �����͸� �����ϱ� ���� ���̺� ����.

--!! ����� == �÷��� (����)

--���̵� id ���� varchar2 �������� 20byte ���� >�⺻Ű(pk)
--�̸�  name ���� varchar2 �������� 15byte 
--����  age ����(����) number(3)  0~999 (���� 0~150)
--���� birth ��¥  date
--
--�������� 

--�����������ġ�
--    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--      ( 
--        ���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] 
--       [,���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] ] 
--       [,...]  
--      ); 


create table test1(
id varchar2(20)
,name varchar2(15)
,age number(3)
,birth date

);

select *
from tabs
where table_name like 'test%';

--����ó , ��� �÷� �߰�
--alter table 
--    add �÷� �߰�, �������� �߰�

--�����ġ��÷��߰�
ALTER TABLE test1
ADD (
    tel varchar2(20) 
    ,bigo varchar2(255)
    -- , ���� varchar2(100) default '���ѹα�'
  );

--�÷� ũ�� ���� ( ��� �÷��� varchar2(255) -> (100) )
--�����ġ�
       ALTER TABLE test1
        MODIFY bigo varchar2(100);
    
    desc test1;
--alter table ~ modify �������� ���������� �÷��� ���� x
-->�÷��� bigo-> etc ����
alter table test1 rename column bigo to etc;
ALTER TABLE test1 DROP COLUMN etc; 

--���̺� �� test1�� exam1�� ����
rename test1 to exam1;

select *
from tabs;

--1) create table ��
--2) subquery�� �̿��� ���̺� ����

create table emp_30 as(
select deptno,empno, ename, hiredate
from emp
where deptno =30
);

create table emp_20 
as(
select empno, ename, sal + nvl(comm,0) pay
from emp
where deptno =20
);
select * from emp_20;

--(*****) emp -> emp_30, emp_20 ���̺� ����
-- �÷����� �ڷ����� ���������� �ڷ����� ������.
desc emp_30;
desc emp_20; -- pay�� ������ ���� �ý����� �˾Ƽ� �ڷ��� �ٲ�
-- ���������� ������� �ʴ´�..(not null �������Ǹ� ����)

--���̺� ����
drop table exam1; -- �����뿡 ���� (���� ���� xxx -> �������� )
drop table exam1 purge; -- �������� (���� �Ұ���)

create table test1(
    num number(7) primary key
    ,name varchar2(20) not null
    , birth date not null
    ,memo varchar2(100)
);

insert into ���̺�� [(�÷���...)] values (��...);
commit;
insert into test1(num, name, birth, memo) values(1,'�����','1995/02/11','��Ÿ...');
select *
from test1;
insert into test1(num, name, birth, memo) values(2,'���ؿ�','1996/01/28','��Ÿ...');
insert into test1(num, name, birth) values(3,'�ȼ���','1992/06/27');
insert into test1(num, name, birth) values(4,'�����','1999/04/20');
commit;
insert into test1(num, name, birth) values(5,'������',to_date('01/11/99','mm/dd/rr'));

create table test2 as (
select empno, ename,hiredate from emp where 1=0
);
-- ���̺��� ������ �����ϴµ� ���ڵ�� x
desc test2;
select * from test2;

insert into test2
    select empno, ename, hiredate from emp;
 --   12�� �� ��(��) ���ԵǾ����ϴ�.

--���̺� ���� : drop table test2 purge;
-- test2 ���̺� ���ڵ�(��) ���� : delete / truncate��
--truncate�� : where�� ��� xxx > ���ϴ� ������ ���� xxxxx & rollback,commit ��� xxxxx
delete from test2;
rollback;

-- insert all : �ϳ��� insert���� �̿��Ͽ� ���� ���̺� ������ �߰� 
drop table emp_30;

create table emp_10
as( select * from emp where 1=0 );

create table emp_20
as( select * from emp where 1=0 );

create table emp_30
as( select * from emp where 1=0 );

--[Unconditional insert]
insert all 
           into emp_10 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
           into emp_20 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
           select * from emp;

-- select * from emp ������ ��� �߿� deptno = 10 -> emp_10 ���̺�

--[conditional insert]
insert all
when deptno = 10 then
    into emp_10 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
when deptno = 20 then
    into emp_20 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
when deptno = 30 then
    into emp_30 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
select * from emp;

select *
from emp_20;
rollback;
commit;

create table sales(
employee_id       number(6),
week_id            number(2),
sales_mon          number(8,2),
sales_tue          number(8,2),
sales_wed          number(8,2),
sales_thu          number(8,2),
sales_fri          number(8,2));

insert into sales values(1101,4,100,150,80,60,120);
insert into sales values(1102,5,300,300,230,120,150);

delete from sales where week_id =4;

select * from sales;

create table sales_data(
employee_id        number(6),
week_id            number(2),
sales              number(8,2));


--[Unconditioanl insert ]
insert all --�Ǻ�, ���Ǻ� ���� 
    into sales_data values(employee_id, week_id, sales_mon)
    into sales_data values(employee_id, week_id, sales_tue)
    into sales_data values(employee_id, week_id, sales_wed)
    into sales_data values(employee_id, week_id, sales_thu)
    into sales_data values(employee_id, week_id, sales_fri)
    select employee_id, week_id, sales_mon, sales_tue, sales_wed,
           sales_thu, sales_fri
    from sales;
select * from sales_data;

--����) insa���̺��� num, name �÷��� �о�ͼ� score ���̺� ����
drop table score;
commit;
create table score
as(
select num, name from insa);


--����) kor, eng, mat, tot, savg �÷� �߰�
alter table score
add(
kor number(3)
,eng number(3)
,mat number(3)
,tot number(3)  default 0
,savg number(5,2) default 0.0
    );
    
-- DML : insert/ delete/ update ���� - commit,rollback
-- ��� �л��� ���� ������ 100������ ���� (���� : ��� ����...)
--update ���̺� ��
--set �÷��� = ��...
--where ������;
update score
set kor = 100, tot = 100+nvl(eng,0)+nvl(mat,0), savg = (100+nvl(eng,0)+ nvl(mat,0))/3;
commit;

select num,name
from score
where name like '%����%';

update score
set kor=98, eng=78, mat=55, tot = 98+78+55, savg= (98+78+55)/3
where num = 1014; 

update score
set kor = 90,eng=70, mat=80, tot = 90+70+80, savg= (90+70+80)/3
where num =1001;
update score
set kor = 70,eng=60, mat=80, tot = 70+60+80, savg= (70+60+80)/3
where num =1002;
update score
set kor = 60,eng=90, mat=80, tot = 60+90+80, savg= (60+90+80)/3
where num =1003;
update score
set kor = 50,eng=50, mat=50, tot = 50+50+50, savg= (50+50+50)/3
where num =1004;
update score
set kor = 90,eng=100, mat=35, tot = 90+100+35, savg= (90+100+35)/3
where num =1005;
commit;
delete from score
where eng is null;

alter table score rename column ���� to result;
select * from score;

update score
set result = case
                when savg < 60 then '���հ�'
                when (kor<40 or eng <40 or mat <40) then '����'
                end '�հ�';
commit;
rollback;
--��� �л��� mat 5�� �߰� plus
update score
set mat = mat +5 , tot = tot +5 ,savg=tot +5/3, 
                result = case
                when (tot +5)/3 < 60 then '���հ�'
                when (kor<40 or eng <40 or mat+5 <40) then '����'
                else '�հ�'
                end ;
                
                
