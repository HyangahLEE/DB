--2018.06.22 (금)


-- 날짜 - 날짜 = 일수 but 날짜 + 날짜 = 오류!!
-- 날짜 -/+ 숫자 = 날짜
-- 오라클 '문자 또는 날짜'
--ORA-01722: invalid number

select round(sysdate - to_date('98/01/05'),3)
from dual;

select to_date('1998','yyyy')--98/06/01 현재 시스템 날짜의 1일 날짜
        ,trunc(to_date('1998','yyyy'),'year')
from dual;

select 
    to_date('1998/03', 'YYYY/MM')
    -- 일(1) 월 화 수 목 금 토(7)
    , to_char(to_date('1998/03', 'YYYY/MM')+6, 'D')
    , to_char(to_date('1998/03', 'YYYY/MM')+6, 'DY')
    , to_char(to_date('1998/03', 'YYYY/MM')+6, 'DAY')
    , case  to_char(to_date('1998/03', 'YYYY/MM')+6, 'DY')
        when '일' then 1
        when '월' then 2
        when '화' then 3
        when '수' then 4
        when '목' then 5
        when '금' then 6
        when '토' then 7
      end dayOfWeek
from dual;

-- insa 테이블에서 남자사원만 모두 출력
select buseo, name, ssn, ibsadate
from insa
where mod(substr(ssn,8,1),2)=1;
where substr(ssn,8,1) in (1,3,5,7,9);

--RR/YY 차이점..
-- RRRR = YYYY은 같다 BUT RR != YY
SELECT  -- 50 이상 RR/YY
        to_date('65/02/07','rr/mm/dd')
        , to_char(to_date('65/02/07','rr/mm/dd'), 'YYYY')
        ,to_date('65/02/07','yy/mm/dd')
        ,to_char(to_date('65/02/07','YY/mm/dd'), 'YYYY')
        -- 50 미만 RR/YY
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

--쌤코딩-----------------------------
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

-- 수정 DML COMMIT/ROLLBACK
--update insa
--set  ssn = '820622-2362514'
--where name ='김영년';
--commit;


--내생일 확인 (바인딩 변수 :bitrhday)
select
   trunc(sysdate) -  to_date( :birthday,'MMDD' ) 
from dual;

--만년달력  년도/월
--1. 년/월/1 무슨요일?
--2. 마지막 날짜? LAST_DAY( DATE )
SELECT to_date( :yearmonth, 'YYYY/MM')
        ,to_char(to_date(:yearmonth, 'YYYY/MM'), 'D' ) --1(일) 7(토)
        ,last_day(to_date(:yearmonth, 'YYYY/MM')) "last_day"
        ,to_char(last_day(to_date(:yearmonth, 'YYYY/MM')),'dd')
FROM DUAL;

--2018/1~12 마지막날 출력
--pl/sql 반복문
select last_day(to_date('12','mm'))
from dual;

--ORA-01846: not a valid day of the week
select 
        sysdate
      --  ,next_dat(sysdate,'mon') --xxx
        ,next_day( sysdate, '월' )
        ,next_day( sysdate, '월요일' )
        --2주 후 월요일?
        ,next_day( sysdate + 14, '월' )
from dual;

--MONTHS_BETWEEN과 ADD_MONTHS 함수는 [월 단위로 날짜 연산]을 하는 함수이다.
select sysdate
        ,add_months( sysdate , -2)
        ,add_months( sysdate , 1)
        ,add_months( sysdate , 2)
        ,add_months( sysdate , 3)
        ,add_months( sysdate , 9)
from dual;


-- 곗날 25일

select sysdate
        ,months_between( sysdate , to_date('950211'))
from dual;

select sysdate
        , add_months( sysdate, 2) 
        ,months_between( add_months( sysdate, 2) +31  , sysdate) 
from dual;
--
-- 31일 경우 1증가 : .32258...
--달마다 하루 증가하면 하루치의 값이 다름
select  trunc(1/31,3),trunc(1/28,3),trunc(1/29,3),trunc(1/30,3)
from dual;

--사원테이블 > 나이/ 생일/ 성별/ 퇴사일자 ? x
-- 추출속성(컬럼)


-- 나이 60살까지 근무. insa table, ibsadate, ssn 1)현재나이 > 2)퇴사일자 계산, 3)년 월 일남았는디
select name,ssn, ibsadate 
        ,to_char(sysdate, 'yyyy') - to_char(to_date(substr(ssn, 0,6)),'yyyy')+1 현재나이
        ,add_months(to_date(substr(ssn, 0,6)) , 720)+1 퇴사일자
        ,trunc((add_months(to_date(substr(ssn, 0,6))+1 , 720)-trunc(sysdate))/365) 남은년도
        ,trunc(months_between(add_months(to_date(substr(ssn, 0,6))+1 , 720),trunc(sysdate)))남을개월수
        ,add_months(to_date(substr(ssn, 0,6))+1 , 720)-trunc(sysdate) 남은일자
from insa;

--select name,ssn, ibsadate --,to_date(substr(ssn, 0,6))
--        ,to_char(sysdate, 'yyyy') - to_char(to_date(substr(ssn, 0,6)),'yyyy')+1 현재나이
--        --,sysdate-to_date(substr(ssn, 0,6))
--         , add_months(to_date(substr(ssn, 0,6)) , 720) 퇴사일자
--         ,add_months(to_date(substr(ssn, 0,6)) , 720)-sysdate
--       --  ,TRUNC((months_between(add_months(to_date(substr(ssn, 0,6)) , 720) , sysdate))/12) 년
--         -- ,60-(to_char(sysdate, 'yyyy') -to_char(to_date(substr(ssn, 1,6)),'yyyy')+1) 년   
--        -- ,to_char(sysdate, 'yyyy')+ (60-(to_char(sysdate, 'yyyy') -to_char(to_date(substr(ssn, 1,6)),'yyyy')+1))
--from insa;


select ename, hiredate, sysdate
        ,ceil( sysdate - hiredate ) 근무일수 
      --  ,months_between( trunc(sysdate)+1 , hiredate ) 근무개월수
      --  ,months_between( trunc(sysdate)+1 , hiredate )/12 근무년수
        ,trunc(months_between( trunc(sysdate)+1 , hiredate ),3) 근무년수
from emp;

--[CURRNET_DATE 함수]
--현재 session의 날짜 정보를 [일/월/년 24시:분:초] 형식으로 반환한다.
SELECT  sysdate --시스템의 날짜 시간정보 초까지(date)
        , current_date --date
        ,current_timestamp -- current_date + Timezone정보(timestamp)
        ,Localtimestamp -- timestamp 밀리세컨드 (1/1000초)
from dual;

--[CURRNET_TIMESTAMP함수]
--이 함수는 TIMESTAMP WITH TIME ZONE 데이터타입으로 current date와 session time zone을 반환한다

select sysdate
        ,to_char( sysdate, 'yyyy') 
        , extract(year from sysdate)-- 년도 가져오기
        ,to_char( sysdate, 'mm') 
        , extract(month from sysdate)--월 가져오기
        ,to_char( sysdate, 'dd') 
        , extract(day from sysdate)--일 가져오기
from dual;

SELECT EXTRACT(YEAR FROM LOCALTIMESTAMP) 년,
       EXTRACT(MONTH FROM LOCALTIMESTAMP) 월,
       EXTRACT(DAY FROM LOCALTIMESTAMP) 일,
       TO_CHAR(SYSDATE, 'DY')||'요일' 요일,
       EXTRACT(HOUR FROM LOCALTIMESTAMP) 시,
       EXTRACT(MINUTE FROM LOCALTIMESTAMP) 분,
       EXTRACT(SECOND FROM LOCALTIMESTAMP) 초
  FROM DUAL;

SELECT TO_CHAR(SYSDATE,'YYYY') AS 년,
       TO_CHAR(SYSDATE,'MM') AS 월,
       TO_CHAR(SYSDATE,'DD') AS 일,
       TO_CHAR(SYSDATE,'DAY') AS 요일,
       TO_CHAR(SYSDATE,'HH24') AS 시,
       TO_CHAR(SYSDATE,'MI') AS 분,
       TO_CHAR(SYSDATE,'SS') AS 초
FROM DUAL;

--to_number()      문자열 -> 숫자(NUMBER 실수, 정수) 형변환
select '15' +100
        ,TO_NUMBER('              15            ') + 100
        ,'            15             ' + 100
      --  ,'15A' +1
from dual;

--decode() 함수
--1.sql,pl/sql 안에서 사용하는 함수(if문)
--2. decode 함수를 확장  = case 문
--조건 비교할때 = 연산자(단점) 그래서 case문이 나옴

select ename, sal,comm
        ,sal + nvl(comm,0) pay_1
        ,sal + nvl2(comm,comm,0) pay_2
        ,coalesce(sal+comm,sal) 
from emp;

SELECT name, ssn
        ,decode(mod(substr(ssn, 8,1)),0
                            ,'여자'
                            ,'남자') 성별
        ,case 
        when substr(ssn, 8,1) in (1,3,5,7,9) then '남자'
        else '여자'
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
            end 인상률
        ,case deptno
            when 10 then sal + nvl(comm,0)+sal + nvl(comm,0)*0.2
            when 20 then sal + nvl(comm,0)+sal + nvl(comm,0)*0.1
            when 30 then sal + nvl(comm,0)+sal + nvl(comm,0)*0.05
            end 인상금액
from emp;

-- [*****]
-- emp 테이블의 30번 부서 사원의 수를 출력.
select count(*)
from emp
where deptno = :deptno ;
-- decode() 를 사용해서 30번 부서 사원의 수를 출력.
select 
      count( decode(deptno,30,1)) 사원수  -- 6
      , sum( decode(deptno,30,1)) 사원수  -- 6
from emp;
--

-- 1) emp 테이블의 사원수
select count(*) -- NULL 포함하고자 한다면 count( * )
      ,count(컬럼명)
from emp;

select count( distinct deptno)
from emp;
--
select count( distinct  deptno )
from emp;
-- count() 널을 제외한 수..
select count(*) , count(ename), count(comm)
from emp;
-- 평균 집계함수 ( avg )
-- 183.333333333333333333333333333333333333
select  2200/12
from dual;
-- 550  집계함수는 null 제외... 2200/4
select avg( comm )
from emp;

-- 총사원수 : select count(*) from emp;  12
-- 총사원의 comm의 합 :
-- select sum(comm) from emp;  2200
select comm
from emp
where comm is not null;


select sum( decode(deptno,10,sal + nvl(comm,0))) "10번부서 급여합"
    ,sum( decode(deptno,20,sal + nvl(comm,0)))"20번부서 급여합"
    ,sum( decode(deptno,30,sal + nvl(comm,0)))"30번부서 급여합"
    ,sum(sal + nvl(comm,0))"총 급여합"
from emp;


--EMP 테이블의 평균 급여보다 많으면 GOOD, POOR

select deptno , ename, sal, trunc((select avg(sal )from emp)) avg_sal
        ,decode( sign(sal-(select avg(sal )from emp)),-1,'poor','good')
from emp;

--각 부서의 급여 평균보다 높으면 good/poor
select ename, sal , b.deptno ,round(b.bsalavg) 부서평균
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

