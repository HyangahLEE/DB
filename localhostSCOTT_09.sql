--2018.06.28 (��)

--1. ���� ���� Ȯ��
SELECT *
FROM user_constraints; 

--2. �������� - data 
--    ��.��ü���Ἲ 
--    ��.�������ἳ
--    ��.�����ι��Ἲ

select * from emp;
insert into emp values(9999,'SMITH','CLERK',7902,'80/12/17',800,null,90);
--ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found 

--1. ���� ���� ����
--    ��.column level ���
--    ��.Table level ���



create table test01(
-- ���� ���� ���� �������� ������ sys_???
id varchar2(20) constraint PK_TEST01_ID primary key --�������� ���� [column level]
,name varchar2(20)
);

create table test01(
id varchar2(20) 
,name varchar2(20)
, CONSTRAINT pk_test01_id primary key(id)
);

---
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('test02');


--FOREIGN KEY (�ܷ�Ű/����Ű) ����
--TEST01 id(pk) name
--test02  seq(pk)/id(test01.id fk)/content
--
--dept( deptno(pk)
--emp (....,depno(dept.deptno fk))

--FK �÷�����
create table test02(
seq number constraint pk_test02_seq primary key
,id varchar2(20) constraint fk_test02_id
                    references test01(id)
,content varchar2(100)
,constraint fk_test02_id foreign key(id) references test01(id)
);
--FK ���̺���
create table test02(
seq number 
,id varchar2(20) 
,content varchar2(100)
,CONSTRAINT pk_test02_seq primary key(seq)
,constraint fk_test02_id foreign key(id) references test01(id)
);

select *
from user_constraints
where table_name like 'TEST0 _';

INSERT INTO test01 values('aaa','ȫ�浿');
INSERT INTO test01 values('bbb','�����');
INSERT INTO test01 values('ccc','�����');

INSERT INTO test02 values(1,'ccc','��� ����');
INSERT INTO test02 values(2,'bbb','��� �����');
INSERT INTO test02 values(3,'ccc','���� ������');
INSERT INTO test02 values(4,'ccc','�������!');
INSERT INTO test02 values(5,null,'������ ����'); --�θ� �� �����ؾ��Ѵ�.
commit;

select * from test01; --�θ� ���̺�
select * from test02; -- �ڽ� ���̺�
delete from test01 where id= 'aaa'; -- ���� ���ϸ� ��������
delete from test01 where id= 'ccc'; --�����ϰ� �־ ����!!

create table test02(
seq number 
,id varchar2(20) 
,content varchar2(100)
,CONSTRAINT pk_test02_seq primary key(seq)
,constraint fk_test02_id foreign key(id) references test01(id)
                        on delete cascade --���������� ����
);

create table test02(
seq number 
,id varchar2(20) 
,content varchar2(100)
,CONSTRAINT pk_test02_seq primary key(seq)
,constraint fk_test02_id foreign key(id) references test01(id)
                        on delete set null --test02�� null�� �ٲ�  
);

create table test01(

id varchar2(20) 
,name varchar2(20)
);
--Table TEST01��(��) �����Ǿ����ϴ�.
--�������� pk�߰�
alter table test01
add(constraint pk_test01_id primary key(id));
--Table TEST01��(��) ����Ǿ����ϴ�.
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'TEST01';
--�������� ����
ALTER TABLE TEST01
DROP CONSTRAINT pk_test01_id;

--test02���̺� ����  > alter table�� > table�� pk,fk�������ǻ���
create table test02(
id varchar2(2)
,content varchar2(100)
);

drop table test02;


alter table test02
add(
      -- PK
      constraint pk_test02_seq primary key(seq)
      -- FK
      , constraint fk_test02_id foreign key(id) 
        references test01(id)
        -- on delete cascade 
);

--emp���̺� select (empno,ename, hiredate, mgr)
create table emp_copy as(
select empno,ename, hiredate, mgr
from emp
);

select * from emp_copy;
--where 1=0 ������ ���� ������(��)x
--�� �÷��� �ڷ���
desc emp_copy;
--***�������� ���� x(not null�������� oo)
select *
from user_constraints
where table_name like 'EMP%';
--EMP pk/fk -> emp_copy �������� ����x(����ϼ���!!)

alter table emp_copy
add(
constraint pk_empcopy_empno primary key (empno)
,constraint fk_empcopy_mgr foreign key(mgr)
        references emp_copy(empno)
);

create table test03(

empno number(4)
, dd date

--,constraint fk_test03_empno foreign key(empno) references ()
);

alter table test03
add(
constraint pk_test03_empno_dd primary key(empno,dd)
,constraint fk_test03_empno foreign key(empno) references emp(empno)
);

create table a (
id varchar2(10)
, name varchar2(20)
);
--***pk�����Ŀ� notnull + unique �������� �ڵ����� ���� + �ε���!

--[UNIQUE]���� ���� ( ���ϼ� )
--1. pk �ƴ϶� �ߺ� ������� �ʴ� �÷��� ����.
-----------------------------
--[student ���̺�]
--�й�(pk) �л��� �ֹι�ȣ(uk) �̸���(uk) ����ó(uk) 
-------------------------------
--INSA���̺� �������� Ȯ��
select *
from user_constraints
where table_name = 'INSA';

ALTER TABLE INSA
ADD(
CONSTRAINT uk_insa_ssn unique(ssn)
);

--[check ��������...]
alter table score
add(
constraint ck_score_kor check(kor between 0 and 100)
--constraint ck_score_kor check(kor>=0 and kor<=100)
);

select *
from user_constraints
where table_name = 'score';

-- insa���̺� city �÷� check ��������
select distinct city
from insa;

--alter table insa
--add(constraint ck_insa_city check(city in ('����','��õ'...)));


--[NOT NULL] **���̺� �����θ� �������� ����
create table test05
(
   id varchar2(20) not null primary key
   , name varchar2(20) not null  -- �÷� ���� NN ���� ����
   , addr varchar2(100)  -- ����Ʈ null
   -- , addr NOT NULL ���̺�... X
);
-->ADDR�÷��� NOTNULL��
--1)
ALTER TABLE TEST05
MODIFY addr notnull;
--2)
ALTER TABLE TEST05
ADD(
constraint nn_test05_addr CHECK(ADDR IS NOT NULL)
);
-->�������� ����
alter table test05
drop constraint ck_test05_addr;

--[�������� Ȱ��ȭ&��Ȱ��ȭ]
--�����ġ�--Ȱ��ȭ
--	ALTER TABLE ���̺��
--	ENABLE CONSTRAINT constraint��;
--
--�����ġ�--��Ȱ��ȭ
--	ALTER TABLE ���̺��
--	DISABLE CONSTRAINT constraint�� [CASCADE];

--[�������� ����]
--���1)
--ALTER TABLE ���̺�� 
--DROP [CONSTRAINT constraint�� | PRIMARY KEY | UNIQUE(�÷���)]
--[CASCADE];
--
--CASCADE�ɼ��� �����ϴ� FOREIGN KEY�� ���� �� ����Ѵ�.
--
--���2)
--DROP TABLE ���̺�� CASCADE CONSTRAINTS;
--
--���̺�� �� ���̺��� �����ϴ� foreign key�� ���ÿ� ������ �� �ִ�.
--
--���3)
--DROP TABLESPACE ���̺����̽��� 
--INCLUDING CONTENTS
--CASCADE CONSTRAINTS;
--
--�� ����� ���̺��� �ٸ� ���̺����̽��� �ִ� ���̺��� FOREIGN KEY�� ���Ͽ� �����Ǵ� ��� TABLESPACE���� �Բ� �����ϴ� ����̴�.

