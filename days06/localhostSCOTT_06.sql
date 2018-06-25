--2018-06-25 (��)
--p152 �����Լ�? ��� �����͸� Ư�� �׷����� ���� ���� �� �׷쿡 ���� ����, ���, �ִ밪, �ּҰ� ���� ���ϴ� �Լ�.
--- �����Լ��� �ΰ��� �������� �ʴ´�.
-- �� �����
select count(*) -- '*' ���� �����ϴ�..
        ,count(empno)
        ,count(comm) -- comm �ߺ� �����Ѱ�
from emp;

select count(all deptno)
        ,count(distinct deptno)
from emp; 

--p154 sum(������)
select count(*),sum(sal)
        ,sum(sal)/count(*) --���
        ,avg(sal)
from emp;

--�޿� ���� ���� �޴� ����� sal : max()
select max(sal) , min(sal)
from emp;

--> ����) sal�� ���� ���� �޴� ����� ������ ��� (deptno, empno, ename, sal)
select deptno, empno, ename, sal
from emp
-- p115
-- �� ���ǽ� : any, all, exists, some
-- where ���� subquery�� ���ȴ�.
--where sal = (select max(sal) from emp);
where sal = all (select sal from emp); --�� x
--where sal >= all (select sal from emp); 
-->��µ� ��� sal�� �����ϴ�... == max()��� sal�� ���ڵ� �ϳ��ϳ��� �������� sal�� ��� ���ڵ庸�� ū�� ��
--where sal <= all (select sal from emp); -- min()



-->����2) sal�� ���� ����, ���� �޴� ����� ����
select deptno, empno, ename, sal
from emp
--where sal in (800,5000); 
where sal = (select max(sal) from emp) or sal = (select min(sal) from emp); 
--ORA-00913: too many values !!where������ ���� ���� ���� ��� �ϳ���!
--where sal in (select max(sal),min(sal) from emp); 
--ORA-00903: invalid table name
--where sal in (select max(sal)from emp , select min(sal) from emp);

--emp ���̺��� �� �����, 10���μ������, 20�μ� ����� , 30���μ� �����, 40���μ� �����
select  count(*)
        ,count(decode(deptno,10,'x')) "10��"
        ,count(decode(deptno,20,'x')) "20��"
        ,count(decode(deptno,30,'x')) "30��"
        ,count(decode(deptno,40,'x')) "40��"
from emp;

--�� �μ��� �޿���/�޿����
select  sum(sal), trunc(avg(nvl(sal,0)))
        ,sum(decode(deptno,10,sal)) "10��"
        ,sum(decode(deptno,20,sal)) "20��"
        ,sum(decode(deptno,30,sal)) "30��"
        ,sum(decode(deptno,40,sal)) "40��"
from emp;

--[����] �� �μ��� ���� ���� �޿��� �޴� ����� ������ ���
select deptno, ename, sal
from emp
where sal in (2850, 3000, 5000)
order by deptno;

--> [ ��� ���� ���� ���� ]
select deptno, ename, sal
from emp e1 
where sal = (
             select max(sal) 
             from emp e2 
             where e2.deptno = e1.deptno
             );
             
--> P156 GROUP BY���� Having��
-- �����Լ��� �������� group by���
--roll up, cube ���

--insa���̺� �μ��� �ο��� ���
                        --ORA-00979: not a GROUP BY expression
select buseo, city, name, count(*)
from insa
group by buseo
order by jikwi;

--[�� �����]
--1) insa ���̺��� ��,�� �����
--2) insa���̺��ļ� �� �μ���, ��,�� �����
select buseo 
        ,case mod(substr(ssn,8,1),2)
            when 0 then '����'
            else '����'
        end ����
        ,count(*)
from insa
group by buseo, mod(substr(ssn,8,1),2)
order by buseo;

------�� �μ��� ��, �� , ����� ���
--�޿� ���� , ��ȭ���� \
select buseo
        ,count( decode( mod(substr(ssn,8,1),2),1,1)) "���ڻ����" 
        ,count( decode( mod(substr(ssn,8,1),2),0,1)) "���ڻ����"
        ,to_char(nvl( sum (decode(mod(substr(ssn,8,1),2),1,nvl(basicpay,0) )),0),'L99,999,999') "���޿�����"
        ,to_char(nvl( sum (decode(mod(substr(ssn,8,1),2),0,nvl(basicpay,0) )),0),'L99,999,999') "���޿�����"
from insa
group by buseo
order by buseo;

--EMP ���̺��� �� ���� �Ի��� ��� �� ���
select y,m,count(*)
from emp , (SELECT deptno, ename, hiredate
            , to_char(hiredate, 'yyyy')y
            , to_char(hiredate, 'mm')m
from emp)
group by m ,y
order by y, m;
----
select to_char ( hiredate, 'mm')m, count(*)
from emp
group by to_char( hiredate, 'mm' )
order by m;
---
select count(*)
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
from emp;


--�� �⵵�� �Ի� ����� 
select to_char(hiredate, 'yyyy'), count(*)
from emp 
group by to_char(hiredate, 'yyyy');
--
select to_char(hiredate,'YYYY') y
  , count(*)
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

--having p158 group by�� ������

--insa ���̺��� �μ��ο����� ��� ( 10�� �̻��� ���� )
select buseo, count(*) �����
from insa
group by buseo
having count(*)>=10;

--insa���̺��� ���� ������� 5�� �̻��� �μ��� ���
select buseo,count(*)
from insa
where mod( substr(ssn,8,1),2) = 0
group by buseo
having count(*)>=5;

select buseo, count(decode(mod(substr(ssn,8,1),2),0,1)) ���ڻ����
from insa
group by buseo
having count(decode(mod(substr(ssn,8,1),2),0,1))>=5;


--p158 rollup ���� cube�� 
--1. group by ������ ���ȴ�. 
--2. �׷캰 �Ұ踦 �߰��� �����ִ� ����.

select deptno, sum(sal) from emp  group by deptno;
select deptno, count(*) from emp group by deptno;
select count(*), sum(sal) from emp;
--
select deptno,job, count(*)
from emp
group by deptno, job
order by deptno, job
--group by rollup(deptno);
--group by deptno;