--20180626 (화)
--1. 계층형 쿼리
--【형식】 
--	SELECT 	[LEVEL] {*,컬럼명 [alias],...}
--	FROM	테이블명
--	WHERE	조건
--	START WITH 조건
--	CONNECT BY [PRIOR 컬럼1명  비교연산자  컬럼2명]
--		또는 
--		   [컬럼1명 비교연산자 PRIOR 컬럼2명]


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


insert into test (deptno, dname, college, loc) values( 101, '컴퓨터공학과',100,'1호관');
insert into test (deptno, dname, college, loc)  values (102,'멀티미디어학과',100,'2호관');
insert into test (deptno, dname, college, loc) values( 201, '전자공학과' , 200, '3호관');
insert into test (deptno, dname, college, loc) values( 202, '기계공학과',  200, '4호관');
insert into test (deptno, dname, college) values( 100, '정보미디어학부',10);
insert into test (deptno, dname, college) values( 200, '메카트로닉스',10);
insert into test (deptno, dname) values( 10, '공과대학');
commit;

select *
from test;

SELECT deptno,college,dname,loc,LEVEL
FROM test
WHERE dname != '정보미디어학부'
START WITH college IS NULL
CONNECT BY PRIOR deptno=college;

 SELECT deptno,college,dname,loc,LEVEL
FROM test
START WITH college IS NULL
CONNECT BY PRIOR deptno=college
AND dname != '정보미디어학부';


----------------------------
SELECT deptno,dname,college,LEVEL
  FROM test
  START WITH deptno=10
  CONNECT BY PRIOR deptno=college;
-- order by 정렬
select empno, lpad(' ', 3 * (level-1)) || ename, level
   , connect_by_root empno as root_empno
   , connect_by_isleaf
   , sys_connect_by_path(empno,'|')
from emp
-- where
start with mgr is null
connect by prior empno = mgr -- and 조건절
order siblings by deptno ;  -- 정렬 + 계층구조 보존(유지)
---------------------------------


select count(*)
        ,count( decode(deptno,10,1) ) "10번"
        ,count( decode(deptno,20,1) ) "20번"
        ,count( decode(deptno,30,1) ) "30번"
        ,count( decode(deptno,40,1) ) "40번"
from emp;

select * 
from 
(select deptno from emp
)
pivot( count(deptno) for deptno in(10,20,30,40));
--pivot( 집계함수 for 컬럼명 in 리스트);

--각 부서별 sal총합 출력(pivot)
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



-- 문제 2) emp 테이블에서 년도별 월별   입사한 사원수 출력...
select to_char(hiredate,'YYYY') y
  --, count(*)
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
--1980	1	0	0	0	0	0	0	0	0	0	0	0	1
--1981	10	0	2	0	1	1	1	0	0	2	0	1	2
--1982	1	1	0	0	0	0	0	0	0	0	0	0	0

SELECT *
FROM
(
SELECT TO_CHAR(HIREDATE,'YYYY') Y ,TO_NUMBER(TO_CHAR(HIREDATE,'MM')) M --******TO_NUMBER로 형변환 해주기!!
FROM EMP
)
PIVOT( COUNT(M) FOR M IN(1,2,3,4,5,6,7,8,9,10,11,12))
ORDER BY Y;

--COUNT() 집계함수

SELECT COUNT(*) FROM EMP;

--COUNT() OVER() : 질의한 행의 [누적]된 카운트가 출력된다.
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

--COUNT() OVER() 누적된 카운트
--SUM() OVER() 누적된 합
SELECT DEPTNO, SUM(SAL) OVER(ORDER BY SAL) 
        , TRUNC(AVG(SAL) OVER(ORDER BY SAL))
FROM EMP;

--문제) 각 EMP테이블에서 사원들의 급여가 전체 급여액의 몇 %를 차지하는지 출력

-- 문제 ) 각 사원들의 급여가 전체 급여액의 몇 % 출력
select deptno, ename  , sal
    , ( select sum(sal) from emp ) tot_sal
    -- 소수점 2자리까지 출력  3.20%
    , round( sal / ( select sum(sal) from emp ) * 100, 2 ) || '%' a
     
      -- 그 부서에서의 sal의 비율
     ,( select sum(sal) from emp x where x.deptno = y.deptno ) d1
     , round( sal /( select sum(sal) from emp x where x.deptno = y.deptno ) * 100, 2 ) || '%' b1 
       -- 그 부서에서의 sal의 비율
     , sum(sal) over(PARTITION BY deptno order by deptno) d2
     , to_char(round( sal/sum(sal) over(PARTITION BY deptno order by deptno)*100,2), '999.00') || '%'  b2
from emp y
order by deptno;

--오라클 DateType(자료형)
--1. 데이터 타입? [컬럼]이 저장되는 데이터 유형
--2. ㄱ.기본 데이터 타입/ ㄴ. 사용자 정의 유형

--A. char 
--   1. 문자 데이터 타입
--   2. 형식     char( 크기 [byte 또는 char] ) 
--              char(10)  == char(10 byte)   1byte
--              char(1 byte) == char(1) == char
--   3. 크기     2000 바이트     알파벳 2000문자, 한글 3바   666문자
--   4. 고정 크기 ***    [x][blank][blank]


 
--ORA-00955: name is already used by an existing object
create table test_char
(
   aa char            -- char(1 byte)
   , bb char(3)       -- bb char(3 byte)
   , cc char(3 char)  -- 3문자 "홍길동"  "abc"
);

insert into test_char (aa,bb,cc) values ('a','aaa','aaa');
commit;

select aa,bb,'[' || cc || ']'
from test_char;

insert into test_char (aa,bb,cc) values ('b','한','홍길동');
insert into test_char (aa,bb,cc) values ('c','둘','x');

--B. nchar 데이터 타입
-- 1. unicode 값 저장하는 데이터 타입
-- 2. 유니코드 알파벳 1문자 한글 1문자 ->2바이트 처리..
-- 3. 형식  nchar( 크기 )   nchar(3) 3문자  ex) abc / 홍길동
--         nchar  == nchar(1) 1문자
-- 4. 최대로 2000바이트 == 1000문자 

create table test_nchar
(
aa  char(3)             -- char(3 byte) 알 3문자, 한글 1문자
, bb char(3 char)       -- char(3 char) 알, 한 3문자
, cc nchar(3)           -- nchar 유니코드 2바이트, 3문자 , 고정크기*******
);

insert into test_nchar (aa,bb,cc) values('a','aaa','aaa');

select *
from test_nchar;
