--2018 06 21 목 

select *
from emp
WHERE ENAME LIKE '%%'--모든 사원
--where deptno = 30 and ename like 'A%'
order by ename asc;

SELECT NAME 
       ,length(name)
       ,vsize(name)
FROM INSA;

select 3+5
        , sysdate --시스템에 저장된 현재 날짜를 반환하는 함수
                  --이 함수를 이용하여 웹 게시판에서 글을 등록한 시각을 자동적으로 저장
        , current_date
        , CURRENT_TIMESTAMP --초 밑에 단위까지 포함
from dual;

--날짜 자료형 ( DATE ) + TNTWK = 날짜
SELECT ENAME, HIREDATE
        , hiredate + 100
        , sysdate + 10 --일(day) 수 
        -- 1/24/60/60
       -- 일 시간 분 초
       ,sysdate - hiredate --근무일수
FROM EMP;

-- ▣ TO_DATE 숫자, 문자 타입을 날짜 타입으로 변환 
--【형식】
--     TO_DATE( char [,'fmt' [,'nlsparam']])
select '2018/04/26' 개강일
       -- , to_date('2018.04.26', 'YYYY.MM.dd') a
        , to_date('2018/04/26') b
        , sysdate --오늘
        , ceil(sysdate - to_date('2018/04/26')) --날짜x, 문자열로 인식
        -- ORA-01722: invalid number
        -- 날짜 + 숫자 , 날짜 - 숫자 , 날짜 +/- 날짜 
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
-- sql 연산자 : 집합 연산자

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



--▣ subquery ( 서브쿼리 )
select temp.deptno, temp.ename, temp.sal
from( -- from 절 뒤에 오는 서브 쿼리 == 인라인 뷰(inline-view)
    select deptno, ename , sal
    ,nvl(comm, 0) comm
    ,sal +nvl2(comm,comm,0) as pay
    from emp
    order by pay desc) temp
where temp.pay>=2500;

--입사일자가 97~98년도에 입사한 사원의 정보를 출력
select num, name, ibsadate
from insa
--where ibsadate between '96/01/01' and '98/12/31';
--where substr(ibsadate, 1, 2) in ('97',98); --자동 형변환 
--정규표현식 ^9(7|8)[0-9]{4}
where regexp_like(ibsadate, '^9(7|8)(/[0-9]{2}){2}');
--where regexp_like(ibsadate, '^9(7|8)'); --'^9[78]'


--90년대 입사한 사원 중에 97/98 제외한 나머지 90년대 사원 정보 출력
select num, name, ibsadate
from insa
where regexp_like(ibsadate, '^9[^78]');
--where ibsadate not between '96/01/01' and '98/12/31' and ibsadate like'9%';

select '[' || '       삼        겹        살          ' || ']'
    ,'[' || rtrim('       삼        겹        살          ') || ']'
    ,'[' || ltrim('       삼        겹        살          ') || ']'
    ,'[' || trim('       삼        겹        살          ') || ']'
    ,'[' || replace('       삼        겹        살          ', ' ') || ']'
from dual;

-- 주민등록번호(ssn) -> 오늘날짜까지 몇 일 살았는지 ?  살아온 일수 
-- ORA-01722: invalid number
select name, ssn  --  [6]-7
     , substr( ssn , 1, 6 ) ssn6
     -- ,  '18971212-1' 문자열(정수) - DATE 날짜형 형변환   -- substr( ssn , 1, 6 )
     , to_date( substr( ssn , 1, 6 ) , 'YYMMDD') birth
     , abs(sysdate -  to_date( substr( ssn , 1, 6 ) , 'YYMMDD')) "살아온 일수"
     -- , sysdate -  to_date( '77/12/12' , 'RR/MM/DD' ) "살아온 일수"
     -- , sysdate - to_date( '1977년12월12일', 'YYYY년MM월DD일') ??
from insa;

-- [ 숫자 함수 ]
select ename, hiredate
from emp;
--【형식】반올림 함수
--   ROUND ( n , 2인자)

select 
    round(3.141592)    -- 소수점 1번째 자리에서 반올림.
    , round(3.541592)  -- 소수점 1번째 자리에서 반올림.
    ---               b+1 번째 자리... 
    , round(3.141392, 3)  -- 소수점 4번째 자리에서 반올림.
    , round(3.541892, 3)  -- 소수점 4번째 자리에서 반올림.
    , round(1276.141592, -1) -- -1  일자리
    , round(1276.141592, -2) --  -2 십자리
    , round(1276.141592, -3) -- -3 백자리
from dual;
--
select ename
,sal
,sal/22
, round(sal/22)
,round(sal/22,2)
,round(sal/22,-1)
from emp where deptno=10;
-- trunc(n,m)은 입력 값 n을 m 자릿수에서 절삭한다.
--【형식】
--	TRUNC (n [,m] )
select
   trunc( 3.141592 )   -- m 생략  소수점 1번째 자리 절삭
   , trunc( 3.941592 ) -- m 생략  소수점 1번째 자리 절삭
   , trunc( 3.941592 , 1 )    -- m+1 자리에서 절삭
   , trunc( 375.941592 , -1 ) -- 일의 자리 절삭
from dual;

-- ceil 절상
--【형식】
--  	CEIL(n) 
select ceil(  3.14 ) 
from dual;

-- [ floor() / trunc() 절삭 함수의 차이점 ]
-- 실수,정수 TRUNC (n [,m] )  절삭 위치 m
-- 정수     FLOOR (n)        무조건 소수점 1번째 자리에서 절삭.. 
select CEIL(19.7), FLOOR(12.945) 
from dual;
-- +  -  *  / 산술연산자.
-- JAVA      4 / 5    0                  4%5
-- Oracle             0.8  차이점
select   4+5 , 4-5 , 4*5
       -- , 4.3/0   -- ORA-01476: divisor is equal to zero
       -- , 4/0     -- ORA-01476: divisor is equal to zero
       -- , 4%5     -- ORA-00911: invalid character
       -- mod() 나머지 구하는 함수
       , mod( 4, 5 )
       -- , mod( 4, 0 )   % /  0 
       -- , mod( 4.3, 0 )   
from dual;
-- comm 널 처리...
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
-- 게시판(JSP)
-- 페이징 처리할 때..... 
--         양수 1   음수 -1   0  0
select sign(15), sign(-15) , sign(0)
from dual;
--  평균 pay 보다 많이 받으면  '초과'    '미달'
--                          '합격'    '불합격'
select ename, pay, p_avg
      , sign( pay-p_avg ) 
from 
(
  select ename, sal+nvl( comm,  0) pay
         , ( select  avg( sal+nvl( comm,  0) ) payavg from emp ) p_avg
  from emp
) t
;

-- 집계 함수 : avg() 평균 집계하는 함수.....
-- 2260.416666666666666666666666666666666667
select  avg( sal+nvl( comm,  0) ) payavg
from emp;

-- 평균  = 급여 총합 / 사원수(12)
-- 집계 함수 : count(*)  12명
select count(*)
from emp;

-- 집계 함수 : sum() 27125
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

-- sqrt()제곱근 구하는 함수 
select sqrt(4), sqrt(2)
from dual;

--round(date) 날짜형태 > 정오를 기준으로 일을 반올림 2018.06.21 14:??:??
--                                             2018.06.22 00:00:00

select sysdate
        , round(sysdate)
        , round (sysdate, 'year')
        , round (sysdate, 'month')
        , round (sysdate, 'day')
from dual;

select sysdate
        ,sysdate - to_date('1990년 02월 11일', 'yyyy"년"mm"월"dd"일"')
from dual;

--pay를 3자리마다 콤마 출력 + 통화단위(원) 붙이고 싶다. 
--TO_DATE() 날짜 형 변환
-- TO_char() 문자형 변환
--  ㄱ. number(숫자) ->문자형태 ( 3자리마다 콤마 출력 + 통화단위(원) )
--  ㄴ. date(날짜) -> 문자형태
select name, basicpay+ sudang pay
        ,
from insa;

--【형식】>> 세 자리 숫자마다 ','를 표시하거나 $와 같이 화폐 단위를 포함한 문자 데이터로 변환할 수 있다. 
--      TO_CHAR( n [,'fmt' [,'nlsparam']])
select ename ,sal 
        , to_char(sal , 'L9,999,999.9') --$9,999,999.9
from emp;

--가장 큰 급여 
--ORA-00937: not a single-group group function
select ename,
        max(sal), min(sal)
from emp;

SELECT name, ibsadate
        ,to_char(ibsadate, 'yyyy"년" mm"월" dd"일" (dy) ,day')
from insa;


--case 컬럼명/ 표현수식
--            when then
--            when then
--            :
--        end
select name, ssn
        ,to_char(to_date(substr(ssn,1,6)),'yyyy"년" mm"월" dd"일"') 생년월일 
        , trunc((sysdate - to_date(substr(ssn,1,6)))/365) 나이
       -- ,to_char(sysdate, 'yyyy')  나이
        ,case mod(substr(ssn,8,1),2)
            when 1 then '남자'
            else '여자'
           --when '2' then '여자'
            end 성별                  
from insa;

select name , ssn, 성별 , 생년월일_1
   ,  to_char( sysdate , 'YYYY')
   ,  substr( 생년월일_1, 1, 4)
   , to_number(to_char( sysdate , 'YYYY')) -  substr( 생년월일_1, 1, 4) age
from 
(
select name , ssn
   , substr( ssn, 8, 1 ) gender
   , case mod( substr( ssn, 8, 1 ), 2)   -- mod('1',2)
        when 1 then '남자'
        else '여자'
        --when 0 then '여자' 
     end 성별
   , substr(  ssn  , 1 , 6   )
   , case 
        when substr( ssn, 8, 1 ) in ('1','2','5','6') then   '19' || substr(  ssn  , 1 , 6   )
        when substr( ssn, 8, 1 ) in ('3','4','7','8') then   '20' || substr(  ssn  , 1 , 6   )
        else '18' || substr(  ssn  , 1 , 6   )
     end 생년월일_1
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
--     end 생년월일_2 
from insa
);

select deptno, empno, ename, sal + nvl(comm,0) pay
        ,case deptno
        when 10 then '20%'
        when 20 then '10%'
        when 30 then '5%'
        end "인상률"
        ,case deptno
         when 10 then (sal + nvl(comm,0))*0.2
         when 20 then (sal + nvl(comm,0))*0.1
         when 30 then (sal + nvl(comm,0))*0.05
      end "인상률"
        , case deptno
        when 10 then sal + nvl(comm,0) + sal + nvl(comm,0)*0.2
        when 20 then sal + nvl(comm,0) + sal + nvl(comm,0)*0.5
        when 30 then sal + nvl(comm,0) + sal + nvl(comm,0)*0.05
         end increasedpay
from emp
order by deptno;


