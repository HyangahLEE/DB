--2018.06.22 (��)


-- ��¥ - ��¥ = �ϼ� but ��¥ + ��¥ = ����!!
-- ��¥ -/+ ���� = ��¥
-- ����Ŭ '���� �Ǵ� ��¥'
--ORA-01722: invalid number

select round(sysdate - to_date('98/01/05'),3)
from dual;

select to_date('1998','yyyy')--98/06/01 ���� �ý��� ��¥�� 1�� ��¥
        ,trunc(to_date('1998','yyyy'),'year')
from dual;

select 
    to_date('1998/03', 'YYYY/MM')
    -- ��(1) �� ȭ �� �� �� ��(7)
    , to_char(to_date('1998/03', 'YYYY/MM')+6, 'D')
    , to_char(to_date('1998/03', 'YYYY/MM')+6, 'DY')
    , to_char(to_date('1998/03', 'YYYY/MM')+6, 'DAY')
    , case  to_char(to_date('1998/03', 'YYYY/MM')+6, 'DY')
        when '��' then 1
        when '��' then 2
        when 'ȭ' then 3
        when '��' then 4
        when '��' then 5
        when '��' then 6
        when '��' then 7
      end dayOfWeek
from dual;

-- insa ���̺��� ���ڻ���� ��� ���
select buseo, name, ssn, ibsadate
from insa
where mod(substr(ssn,8,1),2)=1;
where substr(ssn,8,1) in (1,3,5,7,9);

--RR/YY ������..
-- RRRR = YYYY�� ���� BUT RR != YY
SELECT  -- 50 �̻� RR/YY
        to_date('65/02/07','rr/mm/dd')
        , to_char(to_date('65/02/07','rr/mm/dd'), 'YYYY')
        ,to_date('65/02/07','yy/mm/dd')
        ,to_char(to_date('65/02/07','YY/mm/dd'), 'YYYY')
        -- 50 �̸� RR/YY
        ,to_date('35/02/07','rr/mm/dd')
        , to_char(to_date('35/02/07','rr/mm/dd'), 'YYYY')
        ,to_date('35/02/07','yy/mm/dd')
        ,to_char(to_date('35/02/07','YY/mm/dd'), 'YYYY')
from dual;

select name, ssn 
       -- ,b-a  as Dday
--        ,Case sign(b-a)
--        when -1 then ABS(b-a)
--        when 0 then ABS(b-a) || 'D-DAY'
--        when 1 then ABS(b-a)
--        end 
     --  , sign(b-a)
       , case sign(b-a)
        when -1 then 'D+'|| ABS(b-a)
        when 0 then 'D-DAY'
        when 1 then 'D-'||ABS(b-a)
        end 
from(
select name, ssn 
        ,to_char(sysdate,'ddd') a
        ,to_char(to_date(substr(ssn, 1,6),'yy/mm/dd'),'ddd') b
        
         
FROM insa);

--���ڵ�-----------------------------
select name , ssn  , sysdate
   , to_date(  substr( ssn,3,4) , 'MMDD' )
   , trunc(sysdate) -  to_date(  substr( ssn,3,4) , 'MMDD' ) 
from insa;
--
select
   sysdate   -- YYYY/MM/DD HH24:MI:SS
   , to_char( trunc(sysdate), 'YYYY/MM/DD HH24:MI:SS') a
   , to_char( to_date(  substr( ssn,3,4) , 'MMDD' ), 'YYYY/MM/DD HH24:MI:SS') b
from insa;
---------------------------------------------------------

-- ���� DML COMMIT/ROLLBACK
--update insa
--set  ssn = '820622-2362514'
--where name ='�迵��';
--commit;


--������ Ȯ�� (���ε� ���� :bitrhday)
select
   trunc(sysdate) -  to_date( :birthday,'MMDD' ) 
from dual;

--����޷�  �⵵/��
--1. ��/��/1 ��������?
--2. ������ ��¥? LAST_DAY( DATE )
SELECT to_date( :yearmonth, 'YYYY/MM')
        ,to_char(to_date(:yearmonth, 'YYYY/MM'), 'D' ) --1(��) 7(��)
        ,last_day(to_date(:yearmonth, 'YYYY/MM')) "last_day"
        ,to_char(last_day(to_date(:yearmonth, 'YYYY/MM')),'dd')
FROM DUAL;

--2018/1~12 �������� ���
--pl/sql �ݺ���
select last_day(to_date('12','mm'))
from dual;

--ORA-01846: not a valid day of the week
select 
        sysdate
      --  ,next_dat(sysdate,'mon') --xxx
        ,next_day( sysdate, '��' )
        ,next_day( sysdate, '������' )
        --2�� �� ������?
        ,next_day( sysdate + 14, '��' )
from dual;

--MONTHS_BETWEEN�� ADD_MONTHS �Լ��� [�� ������ ��¥ ����]�� �ϴ� �Լ��̴�.
select sysdate
        ,add_months( sysdate , -2)
        ,add_months( sysdate , 1)
        ,add_months( sysdate , 2)
        ,add_months( sysdate , 3)
        ,add_months( sysdate , 9)
from dual;


-- �쳯 25��

select sysdate
        ,months_between( sysdate , to_date('950211'))
from dual;

select sysdate
        , add_months( sysdate, 2) 
        ,months_between( add_months( sysdate, 2) +31  , sysdate) 
from dual;
--
-- 31�� ��� 1���� : .32258...
--�޸��� �Ϸ� �����ϸ� �Ϸ�ġ�� ���� �ٸ�
select  trunc(1/31,3),trunc(1/28,3),trunc(1/29,3),trunc(1/30,3)
from dual;

--������̺� > ����/ ����/ ����/ ������� ? x
-- ����Ӽ�(�÷�)


-- ���� 60����� �ٹ�. insa table, ibsadate, ssn 1)���糪�� > 2)������� ���, 3)�� �� �ϳ��Ҵµ�
select name,ssn, ibsadate 
        ,to_char(sysdate, 'yyyy') - to_char(to_date(substr(ssn, 0,6)),'yyyy')+1 ���糪��
        ,add_months(to_date(substr(ssn, 0,6)) , 720)+1 �������
        ,trunc((add_months(to_date(substr(ssn, 0,6))+1 , 720)-trunc(sysdate))/365) �����⵵
        ,trunc(months_between(add_months(to_date(substr(ssn, 0,6))+1 , 720),trunc(sysdate)))����������
        ,add_months(to_date(substr(ssn, 0,6))+1 , 720)-trunc(sysdate) ��������
from insa;

--select name,ssn, ibsadate --,to_date(substr(ssn, 0,6))
--        ,to_char(sysdate, 'yyyy') - to_char(to_date(substr(ssn, 0,6)),'yyyy')+1 ���糪��
--        --,sysdate-to_date(substr(ssn, 0,6))
--         , add_months(to_date(substr(ssn, 0,6)) , 720) �������
--         ,add_months(to_date(substr(ssn, 0,6)) , 720)-sysdate
--       --  ,TRUNC((months_between(add_months(to_date(substr(ssn, 0,6)) , 720) , sysdate))/12) ��
--         -- ,60-(to_char(sysdate, 'yyyy') -to_char(to_date(substr(ssn, 1,6)),'yyyy')+1) ��   
--        -- ,to_char(sysdate, 'yyyy')+ (60-(to_char(sysdate, 'yyyy') -to_char(to_date(substr(ssn, 1,6)),'yyyy')+1))
--from insa;


select ename, hiredate, sysdate
        ,ceil( sysdate - hiredate ) �ٹ��ϼ� 
      --  ,months_between( trunc(sysdate)+1 , hiredate ) �ٹ�������
      --  ,months_between( trunc(sysdate)+1 , hiredate )/12 �ٹ����
        ,trunc(months_between( trunc(sysdate)+1 , hiredate ),3) �ٹ����
from emp;

--[CURRNET_DATE �Լ�]
--���� session�� ��¥ ������ [��/��/�� 24��:��:��] �������� ��ȯ�Ѵ�.
SELECT  sysdate --�ý����� ��¥ �ð����� �ʱ���(date)
        , current_date --date
        ,current_timestamp -- current_date + Timezone����(timestamp)
        ,Localtimestamp -- timestamp �и������� (1/1000��)
from dual;

--[CURRNET_TIMESTAMP�Լ�]
--�� �Լ��� TIMESTAMP WITH TIME ZONE ������Ÿ������ current date�� session time zone�� ��ȯ�Ѵ�

select sysdate
        ,to_char( sysdate, 'yyyy') 
        , extract(year from sysdate)-- �⵵ ��������
        ,to_char( sysdate, 'mm') 
        , extract(month from sysdate)--�� ��������
        ,to_char( sysdate, 'dd') 
        , extract(day from sysdate)--�� ��������
from dual;

SELECT EXTRACT(YEAR FROM LOCALTIMESTAMP) ��,
       EXTRACT(MONTH FROM LOCALTIMESTAMP) ��,
       EXTRACT(DAY FROM LOCALTIMESTAMP) ��,
       TO_CHAR(SYSDATE, 'DY')||'����' ����,
       EXTRACT(HOUR FROM LOCALTIMESTAMP) ��,
       EXTRACT(MINUTE FROM LOCALTIMESTAMP) ��,
       EXTRACT(SECOND FROM LOCALTIMESTAMP) ��
  FROM DUAL;

SELECT TO_CHAR(SYSDATE,'YYYY') AS ��,
       TO_CHAR(SYSDATE,'MM') AS ��,
       TO_CHAR(SYSDATE,'DD') AS ��,
       TO_CHAR(SYSDATE,'DAY') AS ����,
       TO_CHAR(SYSDATE,'HH24') AS ��,
       TO_CHAR(SYSDATE,'MI') AS ��,
       TO_CHAR(SYSDATE,'SS') AS ��
FROM DUAL;

--to_number()      ���ڿ� -> ����(NUMBER �Ǽ�, ����) ����ȯ
select '15' +100
        ,TO_NUMBER('              15            ') + 100
        ,'            15             ' + 100
      --  ,'15A' +1
from dual;

--decode() �Լ�
--1.sql,pl/sql �ȿ��� ����ϴ� �Լ�(if��)
--2. decode �Լ��� Ȯ��  = case ��
--���� ���Ҷ� = ������(����) �׷��� case���� ����

select ename, sal,comm
        ,sal + nvl(comm,0) pay_1
        ,sal + nvl2(comm,comm,0) pay_2
        ,coalesce(sal+comm,sal) 
from emp;

SELECT name, ssn
        ,decode(mod(substr(ssn, 8,1)),0
                            ,'����'
                            ,'����') ����
        ,case 
        when substr(ssn, 8,1) in (1,3,5,7,9) then '����'
        else '����'
        end gender
from insa;

select deptno, ename, sal + nvl(comm,0) pay
        ,decode(deptno,10,sal + nvl(comm,0)*0.2
                      ,20,sal + nvl(comm,0)*0.1
                      ,30,sal + nvl(comm,0)*0.05)
        ,case deptno
            when 10 then sal + nvl(comm,0)*0.2
            when 20 then sal + nvl(comm,0)*0.1
            when 30 then sal + nvl(comm,0)*0.05
            end �λ��
        ,case deptno
            when 10 then sal + nvl(comm,0)+sal + nvl(comm,0)*0.2
            when 20 then sal + nvl(comm,0)+sal + nvl(comm,0)*0.1
            when 30 then sal + nvl(comm,0)+sal + nvl(comm,0)*0.05
            end �λ�ݾ�
from emp;

-- [*****]
-- emp ���̺��� 30�� �μ� ����� ���� ���.
select count(*)
from emp
where deptno = :deptno ;
-- decode() �� ����ؼ� 30�� �μ� ����� ���� ���.
select 
      count( decode(deptno,30,1)) �����  -- 6
      , sum( decode(deptno,30,1)) �����  -- 6
from emp;
--

-- 1) emp ���̺��� �����
select count(*) -- NULL �����ϰ��� �Ѵٸ� count( * )
      ,count(�÷���)
from emp;

select count( distinct deptno)
from emp;
--
select count( distinct  deptno )
from emp;
-- count() ���� ������ ��..
select count(*) , count(ename), count(comm)
from emp;
-- ��� �����Լ� ( avg )
-- 183.333333333333333333333333333333333333
select  2200/12
from dual;
-- 550  �����Լ��� null ����... 2200/4
select avg( comm )
from emp;

-- �ѻ���� : select count(*) from emp;  12
-- �ѻ���� comm�� �� :
-- select sum(comm) from emp;  2200
select comm
from emp
where comm is not null;


select sum( decode(deptno,10,sal + nvl(comm,0))) "10���μ� �޿���"
    ,sum( decode(deptno,20,sal + nvl(comm,0)))"20���μ� �޿���"
    ,sum( decode(deptno,30,sal + nvl(comm,0)))"30���μ� �޿���"
    ,sum(sal + nvl(comm,0))"�� �޿���"
from emp;


--EMP ���̺��� ��� �޿����� ������ GOOD, POOR

select deptno , ename, sal, trunc((select avg(sal )from emp)) avg_sal
        ,decode( sign(sal-(select avg(sal )from emp)),-1,'poor','good')
from emp;

--�� �μ��� �޿� ��պ��� ������ good/poor
select ename, sal , b.deptno ,round(b.bsalavg) �μ����
      -- , decode(sign(sal-round(b.bsalavg)),-1,'poor','good')
from emp a ,(select deptno, avg(sal) bsalavg
from emp
group by deptno)b;

--
select 
        trunc(avg(decode(deptno,10,sal))) 
       ,trunc(avg(decode(deptno,20,sal))) 
       ,trunc(avg(decode(deptno,30,sal))) 
from emp
order by deptno;

