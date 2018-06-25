--2018-06-25 (월)
--p152 집계함수? 대상 데이터를 특정 그룹으로 묶은 다음 이 그룹에 대한 총합, 평균, 최대값, 최소값 등을 구하는 함수.
--- 집계함수는 널값을 포함하지 않는다.
-- 총 사원수
select count(*) -- '*' 널을 포함하는..
        ,count(empno)
        ,count(comm) -- comm 중복 ㄴㄴ한값
from emp;

select count(all deptno)
        ,count(distinct deptno)
from emp; 

--p154 sum(숫자형)
select count(*),sum(sal)
        ,sum(sal)/count(*) --평균
        ,avg(sal)
from emp;

--급여 가장 많이 받는 사원의 sal : max()
select max(sal) , min(sal)
from emp;

--> 문제) sal을 가장 많이 받는 사원의 정보를 출력 (deptno, empno, ename, sal)
select deptno, empno, ename, sal
from emp
-- p115
-- 비교 조건식 : any, all, exists, some
-- where 절의 subquery에 사용된다.
--where sal = (select max(sal) from emp);
where sal = all (select sal from emp); --값 x
--where sal >= all (select sal from emp); 
-->출력된 모든 sal을 만족하는... == max()모든 sal의 레코드 하나하나가 서브쿼리 sal의 모든 레코드보다 큰지 비교
--where sal <= all (select sal from emp); -- min()



-->문제2) sal을 가장 많이, 적게 받는 사원의 정보
select deptno, empno, ename, sal
from emp
--where sal in (800,5000); 
where sal = (select max(sal) from emp) or sal = (select min(sal) from emp); 
--ORA-00913: too many values !!where절에서 비교할 때는 비교할 대상 하나만!
--where sal in (select max(sal),min(sal) from emp); 
--ORA-00903: invalid table name
--where sal in (select max(sal)from emp , select min(sal) from emp);

--emp 테이블의 총 사원수, 10번부서사원수, 20부서 사원수 , 30번부서 사원수, 40번부서 사원수
select  count(*)
        ,count(decode(deptno,10,'x')) "10번"
        ,count(decode(deptno,20,'x')) "20번"
        ,count(decode(deptno,30,'x')) "30번"
        ,count(decode(deptno,40,'x')) "40번"
from emp;

--각 부서별 급여합/급여평균
select  sum(sal), trunc(avg(nvl(sal,0)))
        ,sum(decode(deptno,10,sal)) "10번"
        ,sum(decode(deptno,20,sal)) "20번"
        ,sum(decode(deptno,30,sal)) "30번"
        ,sum(decode(deptno,40,sal)) "40번"
from emp;

--[문제] 각 부서별 가장 많이 급여를 받는 사원의 정보를 출력
select deptno, ename, sal
from emp
where sal in (2850, 3000, 5000)
order by deptno;

--> [ 상관 관계 서브 쿼리 ]
select deptno, ename, sal
from emp e1 
where sal = (
             select max(sal) 
             from emp e2 
             where e2.deptno = e1.deptno
             );
             
--> P156 GROUP BY절과 Having절
-- 집계함수를 쓰기위해 group by사용
--roll up, cube 사용

--insa테이블 부서별 인원수 출력
                        --ORA-00979: not a GROUP BY expression
select buseo, city, name, count(*)
from insa
group by buseo
order by jikwi;

--[총 사원수]
--1) insa 테이블에서 남,여 사원수
--2) insa테이블에ㅔ서 각 부서별, 남,여 사원수
select buseo 
        ,case mod(substr(ssn,8,1),2)
            when 0 then '여자'
            else '남자'
        end 성별
        ,count(*)
from insa
group by buseo, mod(substr(ssn,8,1),2)
order by buseo;

------각 부서별 남, 여 , 사원수 출력
--급여 합을 , 통화단위 \
select buseo
        ,count( decode( mod(substr(ssn,8,1),2),1,1)) "남자사원수" 
        ,count( decode( mod(substr(ssn,8,1),2),0,1)) "여자사원수"
        ,to_char(nvl( sum (decode(mod(substr(ssn,8,1),2),1,nvl(basicpay,0) )),0),'L99,999,999') "남급여총합"
        ,to_char(nvl( sum (decode(mod(substr(ssn,8,1),2),0,nvl(basicpay,0) )),0),'L99,999,999') "여급여총합"
from insa
group by buseo
order by buseo;

--EMP 테이블에서 각 월별 입사한 사원 수 출력
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
  , count( decode( to_char(hiredate,'MM'),1,1 ) )  "1월"
  , count( decode( to_char(hiredate,'MM'),2,1 ) ) "2월"
  , count( decode( to_char(hiredate,'MM'),3,1 ) ) "3월"
  , count( decode( to_char(hiredate,'MM'),4,1 ) ) "4월"
  , count( decode( to_char(hiredate,'MM'),5,1 ) ) "5월"
  , count( decode( to_char(hiredate,'MM'),6,1 ) ) "6월"
  , count( decode( to_char(hiredate,'MM'),7,1 ) ) "7월"
  , count( decode( to_char(hiredate,'MM'),8,1 ) ) "8월"
  , count( decode( to_char(hiredate,'MM'),9,1 ) ) "9월"
  , count( decode( to_char(hiredate,'MM'),10,1 ) ) "10월"
  , count( decode( to_char(hiredate,'MM'),11,1 ) ) "11월"
  , count( decode( to_char(hiredate,'MM'),12,1 ) ) "12월"
from emp;


--각 년도별 입사 사원수 
select to_char(hiredate, 'yyyy'), count(*)
from emp 
group by to_char(hiredate, 'yyyy');
--
select to_char(hiredate,'YYYY') y
  , count(*)
  , count( decode( to_char(hiredate,'MM'),1,1 ) )  "1월"
  , count( decode( to_char(hiredate,'MM'),2,1 ) ) "2월"
  , count( decode( to_char(hiredate,'MM'),3,1 ) ) "3월"
  , count( decode( to_char(hiredate,'MM'),4,1 ) ) "4월"
  , count( decode( to_char(hiredate,'MM'),5,1 ) ) "5월"
  , count( decode( to_char(hiredate,'MM'),6,1 ) ) "6월"
  , count( decode( to_char(hiredate,'MM'),7,1 ) ) "7월"
  , count( decode( to_char(hiredate,'MM'),8,1 ) ) "8월"
  , count( decode( to_char(hiredate,'MM'),9,1 ) ) "9월"
  , count( decode( to_char(hiredate,'MM'),10,1 ) ) "10월"
  , count( decode( to_char(hiredate,'MM'),11,1 ) ) "11월"
  , count( decode( to_char(hiredate,'MM'),12,1 ) ) "12월"
from emp
group by to_char(hiredate,'YYYY')
order by y asc;

--having p158 group by의 조건절

--insa 테이블에서 부서인원수를 출력 ( 10명 이상인 조건 )
select buseo, count(*) 사원수
from insa
group by buseo
having count(*)>=10;

--insa테이블에서 여자 사원수가 5명 이상인 부서명 출력
select buseo,count(*)
from insa
where mod( substr(ssn,8,1),2) = 0
group by buseo
having count(*)>=5;

select buseo, count(decode(mod(substr(ssn,8,1),2),0,1)) 여자사원수
from insa
group by buseo
having count(decode(mod(substr(ssn,8,1),2),0,1))>=5;


--p158 rollup 절과 cube절 
--1. group by 절에서 사용된다. 
--2. 그룹별 소계를 추가로 보여주는 역할.

select deptno, sum(sal) from emp  group by deptno;
select deptno, count(*) from emp group by deptno;
select count(*), sum(sal) from emp;
--
select deptno,job, count(*)
from emp
--group by deptno,job;
--group by rollup(deptno,job)
group by cube(deptno,job)
order by deptno, job;
--group by rollup(deptno);
--group by deptno;

select deptno, job, count(*)
FROM EMP
--GROUP BY deptno, rollup(job);
group by rollup(deptno,job);


--p110
-- 의사 ( Pseudo ) 컬럼?
--  ㄱ. 테이블의 컬럼 처럼 동작.
--  ㄴ. 실제 테이블에 저장되지 않는 컬럼
--  ㄷ. select 사용가능 (insert, update, delete 문 사용x)
--  ㄹ. 종류? 계층적 쿼리 : connect_by_???, level
--           시퀀스 : nextval, currval
--           행(레코드) : rownum, rowid

-- 1)rownum 의사컬럼
select rownum, empno, ename, hiredate
from emp;
-----처리순서
select rownum, ename, sal+ nvl(comm,0) pay--6
from emp
order by pay; -- 7

--/-*-************
--급여순으로 랭킹
select rownum ,t.ename, t.pay
from 
(
select ename, sal+ nvl(comm,0) pay --6
from emp
order by pay
) t ;
--emp테이블에서 급여를 가장 많이 받는 사원 5명 출력
select rownum ,t.ename, t.pay
from 
(
select ename, sal+ nvl(comm,0) pay --6
from emp
order by pay desc
) t 
where rownum <=5;

--3-6등
select rownum ,t.ename, t.pay
from 
(
select ename, sal+ nvl(comm,0) pay --6
from emp
order by pay desc
) t 
where  rownum between 3 and 6;
--
where rownum >= 3 and rownum <=6;
select t.*
from (
  select rownum rnum, ename, pay
  from
  (
    select ename, sal + nvl( comm, 0) pay  -- 6
    from emp
    order by pay desc
  )  
) t
where rnu   m  between 3 and 6;
--
--2)rowid 의사컬럼 : 행(row)의 고유한 값,
--                  테이블에 젖ㅇ된 각 로우가 저장된 주소값
select rowid, ename, hiredate
from emp;

-- P231 03.분석함수 
-- 분석함수? 테이블에 있는 로우(행)에 대해 특정 그룹별로 집계값을 산출할 때 사용
-- 형식) 분석함수(매개변수) OVER ( PARTITION BY expr1... ORDER BY expr3...  window절 )
-- 종류) rownum 의사컬럼
--      row_number()
--      rank() / dense_rank()
--      cume_dist() / percent_rank()
--      ntitle(expr)
--      lag, lead()

--emp테이블에서 급여 많이 받는 사원 top5
--1)inline view 
--2)rownum where rownum<=5

-- 위의 코딩을 분석함수 : rank() 사용...
select rnum , ename, sal, comm
from (
          select ename, sal, comm
                , rank() over(ORDER BY sal desc
                             , nvl(comm,0) desc) rnum
          from emp
) t
where rnum between 3 and 6;
--where rnum <= 5;

-- > emp 테이블에서 각 부서별 가장 많은 급여 받는 사원 정보 출력.
-- [ 상관 서브 쿼리 ]
select deptno, ename, sal  
from emp t
where sal = ( 
                select max(sal) 
                from emp e 
                where e.deptno = t.deptno
            );
-- > rank() 분석함수 사용... 
select * 
from (
      select deptno, ename, sal
            , rank()  over (partition by deptno order by sal desc) dept_sal_rank
      from emp
) t 
where t.dept_sal_rank <= 2;

--rank()/ dense_rank() 두 분석함수의 차이점?
select deptno, ename, sal
        ,rank() over(order by sal) rnum1
        ,dense_rank() over(order by sal) rnum2
from emp;

--rank() / dense_rank() / row_number() 차이점...
--deptno부서별로 출력
select deptno, sal, ename
        ,rank() over(partition by deptno order by sal) rank_sal
        ,dense_rank() over(partition by deptno order by sal) rank_sal
        ,row_number() over(partition by deptno order by sal) rank_sal
from emp;

--insa 테이블에서 기본급(basicpay) 상위 10%만(이름, 기본급) 출력
select *
from
(
select name,basicpay
       , rank() over(order by basicpay desc) rank
from insa)t
where t.rank<= round((select count(*) from insa)*0.1);

--p235 cume_dist() : 주어진 그룹에 대한 상대적인 누적분포도의 값 반환
--                   0초과 ~ 1이하 사이의 값을 반환
--각 부서별 급여에 따른 누적 분포도 값을 출력...
select deptno, ename, sal 
        ,cume_dist() over(partition by deptno order by sal) deptno_dist
from emp;

--insa 테이블에서 기본급 상위 10%출력
select name, basicpay
       , trunc(cume_dist() over(order by basicpay desc),3) d
       , trunc(percent_rank() over(order by basicpay desc),3)d
from insa;

--p 237 NTITLE ( expr ) 19명 -> 4팀으로 분리...
select deptno,ename, sal
      -- , ntile(4) over(partition by deptno order by sal desc) ntile
      ,ntile(4) over(order by sal desc) ntile
from emp;

-- 1)pivot(피봇)/ unpivot 설명
--  ㄱ. 각 부서원의 사원수를 조회 (가로)
-- 10 20 30 40
-- 3  3  6  0
select (select count(*) from emp where deptno = 10) "10"
        ,(select count(*) from emp where deptno = 20) "20"
        ,(select count(*) from emp where deptno = 30) "30"
        ,(select count(*) from emp where deptno = 40) "40"
from dual;

select count( decode(deptno, 10, 1) ) "10"
        ,count( decode(deptno, 20, 1) ) "20"
        ,count( decode(deptno, 30, 1) ) "30"
        ,count( decode(deptno, 40, 1) ) "40"
from emp;

--세로
select deptno, count(*)
from emp
group by deptno
order by deptno asc;

-- 피봇(pivot)
select *
from( select deptno from emp)
pivot ( count(deptno) for deptno in (10,20,30,40) );


