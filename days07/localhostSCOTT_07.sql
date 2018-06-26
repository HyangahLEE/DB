--20180626 (ȭ)
--1. ������ ����
--�����ġ� 
--	SELECT 	[LEVEL] {*,�÷��� [alias],...}
--	FROM	���̺��
--	WHERE	����
--	START WITH ����
--	CONNECT BY [PRIOR �÷�1��  �񱳿�����  �÷�2��]
--		�Ǵ� 
--		   [�÷�1�� �񱳿����� PRIOR �÷�2��]


SELECT deptno, empno
        , lpad(' ',3*(level-1)) || ename
        , level
        , sys_connect_by_path(ename,'/') "path"
from emp
start with mgr is null --king
connect by prior empno = mgr;

SELECT mgr,empno,ename,LEVEL
FROM emp
WHERE mgr = 7698
START WITH mgr IS NULL
CONNECT BY PRIOR empno=mgr;


insert into test (deptno, dname, college, loc) values( 101, '��ǻ�Ͱ��а�',100,'1ȣ��');
insert into test (deptno, dname, college, loc)  values (102,'��Ƽ�̵���а�',100,'2ȣ��');
insert into test (deptno, dname, college, loc) values( 201, '���ڰ��а�' , 200, '3ȣ��');
insert into test (deptno, dname, college, loc) values( 202, '�����а�',  200, '4ȣ��');
insert into test (deptno, dname, college) values( 100, '�����̵���к�',10);
insert into test (deptno, dname, college) values( 200, '��īƮ�δн�',10);
insert into test (deptno, dname) values( 10, '��������');
commit;

select *
from test;

SELECT deptno,college,dname,loc,LEVEL
FROM test
WHERE dname != '�����̵���к�'
START WITH college IS NULL
CONNECT BY PRIOR deptno=college;

 SELECT deptno,college,dname,loc,LEVEL
FROM test
START WITH college IS NULL
CONNECT BY PRIOR deptno=college
AND dname != '�����̵���к�';

select empno, lpad(' ',3*(level-1)) || ename, level
from emp
--where 
start with mgr is null
connect by prior empno = mgr --and ������ 
order siblings by deptno; --���� + �������� ����(����)

select empno, lpad(' ',3*(level-1)) || ename, level
        ,connect_by_root empno as root_empno
        , connect_by_isleaf
        , sys_connect_by_path(empno,'/')
from emp
--where 
start with mgr is null
connect by prior empno = mgr --and ������ 
order siblings by deptno; --���� + �������� ����(����)

--
select count(*)
        ,count( decode(deptno,10,1) ) "10��"
        ,count( decode(deptno,20,1) ) "20��"
        ,count( decode(deptno,30,1) ) "30��"
        ,count( decode(deptno,40,1) ) "40��"
from emp;

select * 
from 
(select deptno from emp
)
pivot( count(deptno) for deptno in(10,20,30,40));
--pivot( �����Լ� for �÷��� in ����Ʈ);

--�� �μ��� sal���� ���(pivot)
select *
from 
(select sal,deptno
from emp
)
pivot( sum(sal) for deptno in(10,20,30,40) );

SELECT *
FROM SCORE;


-------
SELECT *
FROM
(
SELECT  NO, NAME,JUMSU
        ,CASE MOD(ROWNUM,3)
            WHEN 1 THEN 'KOR'
            WHEN 2 THEN 'ENG'
            WHEN 0 THEN 'MAT'
        END SUBJECT
FROM SCORE
)
pivot( MAX(JUMSU) for SUBJECT in('KOR','ENG','MAT'));



-- ���� 2) emp ���̺��� �⵵�� ����   �Ի��� ����� ���...
select to_char(hiredate,'YYYY') y
  --, count(*)
  , count( decode( to_char(hiredate,'MM'),1,1 ) )  "1��"
  , count( decode( to_char(hiredate,'MM'),2,1 ) ) "2��"
  , count( decode( to_char(hiredate,'MM'),3,1 ) ) "3��"
  , count( decode( to_char(hiredate,'MM'),4,1 ) ) "4��"
  , count( decode( to_char(hiredate,'MM'),5,1 ) ) "5��"
  , count( decode( to_char(hiredate,'MM'),6,1 ) ) "6��"
  , count( decode( to_char(hiredate,'MM'),7,1 ) ) "7��"
  , count( decode( to_char(hiredate,'MM'),8,1 ) ) "8��"
  , count( decode( to_char(hiredate,'MM'),9,1 ) ) "9��"
  , count( decode( to_char(hiredate,'MM'),10,1 ) ) "10��"
  , count( decode( to_char(hiredate,'MM'),11,1 ) ) "11��"
  , count( decode( to_char(hiredate,'MM'),12,1 ) ) "12��"
from emp
group by to_char(hiredate,'YYYY')
order by y asc;
--1980	1	0	0	0	0	0	0	0	0	0	0	0	1
--1981	10	0	2	0	1	1	1	0	0	2	0	1	2
--1982	1	1	0	0	0	0	0	0	0	0	0	0	0

SELECT *
FROM
(
SELECT TO_CHAR(HIREDATE,'YYYY') Y ,TO_NUMBER(TO_CHAR(HIREDATE,'MM')) M --******TO_NUMBER�� ����ȯ ���ֱ�!!
FROM EMP
)
PIVOT( COUNT(M) FOR M IN(1,2,3,4,5,6,7,8,9,10,11,12))
ORDER BY Y;

--COUNT() �����Լ�

SELECT COUNT(*) FROM EMP;

--COUNT() OVER() : ������ ���� [����]�� ī��Ʈ�� ��µȴ�.
SELECT DEPTNO, ENAME, SAL, COUNT(*) OVER(ORDER BY SAL)
FROM EMP
WHERE DEPTNO =30;
--30	JAMES	950	    1
--30	WARD	1250	3
--30	MARTIN	1250	3
--30	TURNER	1500	4
--30	ALLEN	1600	5
--30	BLAKE	2850	6

SELECT DEPTNO,SAL, COUNT(*) OVER(PARTITION BY DEPTNO ORDER BY SAL)
FROM EMP;

--COUNT() OVER() ������ ī��Ʈ
--SUM() OVER() ������ ��
SELECT DEPTNO, SUM(SAL) OVER(ORDER BY SAL) 
        , TRUNC(AVG(SAL) OVER(ORDER BY SAL))
FROM EMP;

--����) �� EMP���̺��� ������� �޿��� ��ü �޿����� �� %�� �����ϴ��� ���

-- ���� ) �� ������� �޿��� ��ü �޿����� �� % ���
select deptno, ename  , sal
    , ( select sum(sal) from emp ) tot_sal
    -- �Ҽ��� 2�ڸ����� ���  3.20%
    , round( sal / ( select sum(sal) from emp ) * 100, 2 ) || '%' a
     
      -- �� �μ������� sal�� ����
     ,( select sum(sal) from emp x where x.deptno = y.deptno ) d1
     , round( sal /( select sum(sal) from emp x where x.deptno = y.deptno ) * 100, 2 ) || '%' b1 
       -- �� �μ������� sal�� ����
     , sum(sal) over(PARTITION BY deptno order by deptno) d2
     , to_char(round( sal/sum(sal) over(PARTITION BY deptno order by deptno)*100,2), '999.00') || '%'  b2
from emp y
order by deptno;

--����Ŭ DateType(�ڷ���)
--1. ������ Ÿ��? [�÷�]�� ����Ǵ� ������ ����
--2. ��.�⺻ ������ Ÿ��/ ��. ����� ���� ����

--A. char 
--   1. ���� ������ Ÿ��
--   2. ����     char( ũ�� [byte �Ǵ� char] ) 
--              char(10)  == char(10 byte)   1byte
--              char(1 byte) == char(1) == char
--   3. ũ��     2000 ����Ʈ     ���ĺ� 2000����, �ѱ� 3��   666����
--   4. ���� ũ�� ***    [x][blank][blank]


 
--ORA-00955: name is already used by an existing object
create table test_char
(
aa char
, bb char(3)
, cc char(3 char)
);

insert into test_char (aa,bb,cc) values ('a','aaa','aaa');
commit;

select aa,bb,'[' || cc || ']'
from test_char;

insert into test_char (aa,bb,cc) values ('b','��','ȫ�浿');
insert into test_char (aa,bb,cc) values ('c','��','x');

--B. nchar ������ Ÿ��
-- 1. unicode �� �����ϴ� ������ Ÿ��
-- 2. �����ڵ� ���ĺ� 1���� �ѱ� 1���� ->2����Ʈ ó��..
-- 3. ����  nchar( ũ�� )   nchar(3) 3����  ex) abc / ȫ�浿
--         nchar  == nchar(1) 1����
-- 4. �ִ�� 2000����Ʈ == 1000���� 

create table test_nchar
(
aa  char(3)             -- char(3 byte) �� 3����, �ѱ� 1����
, bb char(3 char)       -- char(3 char) ��, �� 3����
, cc nchar(3)           -- nchar �����ڵ� 2����Ʈ, 3���� , ����ũ��*******
);

insert into test_nchar (aa,bb,cc) values('a','aaa','aaa');

select *
from test_nchar;
