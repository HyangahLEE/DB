--2018 06 21 �� 

select *
from emp
WHERE ENAME LIKE '%%'--��� ���
--where deptno = 30 and ename like 'A%'
order by ename asc;

SELECT NAME 
       ,length(name)
       ,vsize(name)
FROM INSA;

select 3+5
        , sysdate --�ý��ۿ� ����� ���� ��¥�� ��ȯ�ϴ� �Լ�
                  --�� �Լ��� �̿��Ͽ� �� �Խ��ǿ��� ���� ����� �ð��� �ڵ������� ����
        , current_date
        , CURRENT_TIMESTAMP --�� �ؿ� �������� ����
from dual;

--��¥ �ڷ��� ( DATE ) + TNTWK = ��¥
SELECT ENAME, HIREDATE
        , hiredate + 100
        , sysdate + 10 --��(day) �� 
        -- 1/24/60/60
       -- �� �ð� �� ��
       ,sysdate - hiredate --�ٹ��ϼ�
FROM EMP;

-- �� TO_DATE ����, ���� Ÿ���� ��¥ Ÿ������ ��ȯ 
--�����ġ�
--     TO_DATE( char [,'fmt' [,'nlsparam']])
select '2018/04/26' ������
       -- , to_date('2018.04.26', 'YYYY.MM.dd') a
        , to_date('2018/04/26') b
        , sysdate --����
        , ceil(sysdate - to_date('2018/04/26')) --��¥x, ���ڿ��� �ν�
        -- ORA-01722: invalid number
        -- ��¥ + ���� , ��¥ - ���� , ��¥ +/- ��¥ 
from dual; 

select deptno, empno, ename job, hiredate
from emp
where deptno =20 
--union 
--union all
--minus
intersect
select deptno, empno, ename job, hiredate
from emp
where deptno =10;
-- sql ������ : ���� ������

with temp as(
select deptno, ename , sal
    ,nvl(comm, 0) comm
    ,sal +nvl2(comm,comm,0) as pay
from emp
order by pay desc
)
select temp.deptno, temp.ename, temp.sal
from temp
where temp.pay >=2500;



--�� subquery ( �������� )
select temp.deptno, temp.ename, temp.sal
from( -- from �� �ڿ� ���� ���� ���� == �ζ��� ��(inline-view)
    select deptno, ename , sal
    ,nvl(comm, 0) comm
    ,sal +nvl2(comm,comm,0) as pay
    from emp
    order by pay desc) temp
where temp.pay>=2500;

--�Ի����ڰ� 97~98�⵵�� �Ի��� ����� ������ ���
select num, name, ibsadate
from insa
--where ibsadate between '96/01/01' and '98/12/31';
--where substr(ibsadate, 1, 2) in ('97',98); --�ڵ� ����ȯ 
--����ǥ���� ^9(7|8)[0-9]{4}
where regexp_like(ibsadate, '^9(7|8)(/[0-9]{2}){2}');
--where regexp_like(ibsadate, '^9(7|8)'); --'^9[78]'


--90��� �Ի��� ��� �߿� 97/98 ������ ������ 90��� ��� ���� ���
select num, name, ibsadate
from insa
where regexp_like(ibsadate, '^9[^78]');
--where ibsadate not between '96/01/01' and '98/12/31' and ibsadate like'9%';

select '[' || '       ��        ��        ��          ' || ']'
    ,'[' || rtrim('       ��        ��        ��          ') || ']'
    ,'[' || ltrim('       ��        ��        ��          ') || ']'
    ,'[' || trim('       ��        ��        ��          ') || ']'
    ,'[' || replace('       ��        ��        ��          ', ' ') || ']'
from dual;

-- �ֹε�Ϲ�ȣ(ssn) -> ���ó�¥���� �� �� ��Ҵ��� ?  ��ƿ� �ϼ� 
-- ORA-01722: invalid number
select name, ssn  --  [6]-7
     , substr( ssn , 1, 6 ) ssn6
     -- ,  '18971212-1' ���ڿ�(����) - DATE ��¥�� ����ȯ   -- substr( ssn , 1, 6 )
     , to_date( substr( ssn , 1, 6 ) , 'YYMMDD') birth
     , abs(sysdate -  to_date( substr( ssn , 1, 6 ) , 'YYMMDD')) "��ƿ� �ϼ�"
     -- , sysdate -  to_date( '77/12/12' , 'RR/MM/DD' ) "��ƿ� �ϼ�"
     -- , sysdate - to_date( '1977��12��12��', 'YYYY��MM��DD��') ??
from insa;

-- [ ���� �Լ� ]
select ename, hiredate
from emp;
--�����ġ��ݿø� �Լ�
--   ROUND ( n , 2����)

select 
    round(3.141592)    -- �Ҽ��� 1��° �ڸ����� �ݿø�.
    , round(3.541592)  -- �Ҽ��� 1��° �ڸ����� �ݿø�.
    ---               b+1 ��° �ڸ�... 
    , round(3.141392, 3)  -- �Ҽ��� 4��° �ڸ����� �ݿø�.
    , round(3.541892, 3)  -- �Ҽ��� 4��° �ڸ����� �ݿø�.
    , round(1276.141592, -1) -- -1  ���ڸ�
    , round(1276.141592, -2) --  -2 ���ڸ�
    , round(1276.141592, -3) -- -3 ���ڸ�
from dual;
--
select ename
,sal
,sal/22
, round(sal/22)
,round(sal/22,2)
,round(sal/22,-1)
from emp where deptno=10;
-- trunc(n,m)�� �Է� �� n�� m �ڸ������� �����Ѵ�.
--�����ġ�
--	TRUNC (n [,m] )
select
   trunc( 3.141592 )   -- m ����  �Ҽ��� 1��° �ڸ� ����
   , trunc( 3.941592 ) -- m ����  �Ҽ��� 1��° �ڸ� ����
   , trunc( 3.941592 , 1 )    -- m+1 �ڸ����� ����
   , trunc( 375.941592 , -1 ) -- ���� �ڸ� ����
from dual;

-- ceil ����
--�����ġ�
--  	CEIL(n) 
select ceil(  3.14 ) 
from dual;

-- [ floor() / trunc() ���� �Լ��� ������ ]
-- �Ǽ�,���� TRUNC (n [,m] )  ���� ��ġ m
-- ����     FLOOR (n)        ������ �Ҽ��� 1��° �ڸ����� ����.. 
select CEIL(19.7), FLOOR(12.945) 
from dual;
-- +  -  *  / ���������.
-- JAVA      4 / 5    0                  4%5
-- Oracle             0.8  ������
select   4+5 , 4-5 , 4*5
       -- , 4.3/0   -- ORA-01476: divisor is equal to zero
       -- , 4/0     -- ORA-01476: divisor is equal to zero
       -- , 4%5     -- ORA-00911: invalid character
       -- mod() ������ ���ϴ� �Լ�
       , mod( 4, 5 )
       -- , mod( 4, 0 )   % /  0 
       -- , mod( 4.3, 0 )   
from dual;
-- comm �� ó��...
select ename, sal, comm
       , mod( sal, comm)
    -- , mod( sal , nvl(comm,0) )
from emp
-- ORA-00904: "COM": invalid identifir
where comm is not null;
-- where com  ^=  null;

-- abs()  round() trunc()/floor()    ceil()  mod()
select  ceil( 19/3 )
from dual;
-- �Խ���(JSP)
-- ����¡ ó���� ��..... 
--         ��� 1   ���� -1   0  0
select sign(15), sign(-15) , sign(0)
from dual;
--  ��� pay ���� ���� ������  '�ʰ�'    '�̴�'
--                          '�հ�'    '���հ�'
select ename, pay, p_avg
      , sign( pay-p_avg ) 
from 
(
  select ename, sal+nvl( comm,  0) pay
         , ( select  avg( sal+nvl( comm,  0) ) payavg from emp ) p_avg
  from emp
) t
;

-- ���� �Լ� : avg() ��� �����ϴ� �Լ�.....
-- 2260.416666666666666666666666666666666667
select  avg( sal+nvl( comm,  0) ) payavg
from emp;

-- ���  = �޿� ���� / �����(12)
-- ���� �Լ� : count(*)  12��
select count(*)
from emp;

-- ���� �Լ� : sum() 27125
select sum(sal + nvl( comm, 0)) 
from emp;
--
select 27125/12
from dual;

--

select ( select sum(sal + nvl( comm, 0)) from emp )
       /( select count(*)from emp )
from dual;

-- power(n,m)
select power(2,3),power(2,-3)
from dual;

-- sqrt()������ ���ϴ� �Լ� 
select sqrt(4), sqrt(2)
from dual;

--round(date) ��¥���� > ������ �������� ���� �ݿø� 2018.06.21 14:??:??
--                                             2018.06.22 00:00:00

select sysdate
        , round(sysdate)
        , round (sysdate, 'year')
        , round (sysdate, 'month')
        , round (sysdate, 'day')
from dual;

select sysdate
        ,sysdate - to_date('1990�� 02�� 11��', 'yyyy"��"mm"��"dd"��"')
from dual;

--pay�� 3�ڸ����� �޸� ��� + ��ȭ����(��) ���̰� �ʹ�. 
--TO_DATE() ��¥ �� ��ȯ
-- TO_char() ������ ��ȯ
--  ��. number(����) ->�������� ( 3�ڸ����� �޸� ��� + ��ȭ����(��) )
--  ��. date(��¥) -> ��������
select name, basicpay+ sudang pay
        ,
from insa;

--�����ġ�>> �� �ڸ� ���ڸ��� ','�� ǥ���ϰų� $�� ���� ȭ�� ������ ������ ���� �����ͷ� ��ȯ�� �� �ִ�. 
--      TO_CHAR( n [,'fmt' [,'nlsparam']])
select ename ,sal 
        , to_char(sal , 'L9,999,999.9') --$9,999,999.9
from emp;

--���� ū �޿� 
--ORA-00937: not a single-group group function
select ename,
        max(sal), min(sal)
from emp;

SELECT name, ibsadate
        ,to_char(ibsadate, 'yyyy"��" mm"��" dd"��" (dy) ,day')
from insa;


--case �÷���/ ǥ������
--            when then
--            when then
--            :
--        end
select name, ssn
        ,to_char(to_date(substr(ssn,1,6)),'yyyy"��" mm"��" dd"��"') ������� 
        , trunc((sysdate - to_date(substr(ssn,1,6)))/365) ����
       -- ,to_char(sysdate, 'yyyy')  ����
        ,case mod(substr(ssn,8,1),2)
            when 1 then '����'
            else '����'
           --when '2' then '����'
            end ����                  
from insa;

select name , ssn, ���� , �������_1
   ,  to_char( sysdate , 'YYYY')
   ,  substr( �������_1, 1, 4)
   , to_number(to_char( sysdate , 'YYYY')) -  substr( �������_1, 1, 4) age
from 
(
select name , ssn
   , substr( ssn, 8, 1 ) gender
   , case mod( substr( ssn, 8, 1 ), 2)   -- mod('1',2)
        when 1 then '����'
        else '����'
        --when 0 then '����' 
     end ����
   , substr(  ssn  , 1 , 6   )
   , case 
        when substr( ssn, 8, 1 ) in ('1','2','5','6') then   '19' || substr(  ssn  , 1 , 6   )
        when substr( ssn, 8, 1 ) in ('3','4','7','8') then   '20' || substr(  ssn  , 1 , 6   )
        else '18' || substr(  ssn  , 1 , 6   )
     end �������_1
--   , case  substr( ssn, 8, 1 )
--        when  '1' then   '19' || substr(  ssn  , 1 , 6   )
--        when  '2' then   '19' || substr(  ssn  , 1 , 6   )
--        when  '3' then   '20' || substr(  ssn  , 1 , 6   )
--        when  '4' then   '20' || substr(  ssn  , 1 , 6   )
--        when  '5' then   '19' || substr(  ssn  , 1 , 6   )
--        when  '6' then   '19' || substr(  ssn  , 1 , 6   )
--        when  '7' then   '20' || substr(  ssn  , 1 , 6   )
--        when  '8' then   '20' || substr(  ssn  , 1 , 6   )
--        when  '9' then   '18' || substr(  ssn  , 1 , 6   )
--        when  '0' then   '18' || substr(  ssn  , 1 , 6   )
--     end �������_2 
from insa
);

select deptno, empno, ename, sal + nvl(comm,0) pay
        ,case deptno
        when 10 then '20%'
        when 20 then '10%'
        when 30 then '5%'
        end "�λ��"
        ,case deptno
         when 10 then (sal + nvl(comm,0))*0.2
         when 20 then (sal + nvl(comm,0))*0.1
         when 30 then (sal + nvl(comm,0))*0.05
      end "�λ��"
        , case deptno
        when 10 then sal + nvl(comm,0) + sal + nvl(comm,0)*0.2
        when 20 then sal + nvl(comm,0) + sal + nvl(comm,0)*0.5
        when 30 then sal + nvl(comm,0) + sal + nvl(comm,0)*0.05
         end increasedpay
from emp
order by deptno;


