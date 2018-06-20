--20180620
--EMP테이블에서 수당을 몇명이나 받았는지? 수당 총 얼마나 지급? 수당이 어떤 사원한테 지급?
--【형식】
--     expr IS [NOT] NULL 

--1) 수당을 받은 사원의 정보 출력
SELECT ENAME, COMM
FROM EMP
--WHERE COMm is not NULL or comm!=0;
WHERE COMm is NULL;
--2) 수당을 받지못한 사원의 정보를 출력
select ename, comm
from emp
WHERE comm =0 or comm is null;
--3) insa 테이블에서 성이 '이'씨 사원들 모두 퇴사...
--[like 연산자]

select *
from insa
where name not like '이%';

SELECT NAME, SSN
            , substr(ssn,0,2) year -- 주민번호(ssn) 년도 2자리
            , substr(ssn,1,2) year -- 주민번호(ssn) 년도 2자리
            , substr(ssn,3,2) month -- 주민번호(ssn) 월 2자리
            , substr(ssn,5,2) as "date"  -- 주민번호(ssn) 일 2자리
            , substr(ssn,8,1) gender -- 주민번호(ssn) 성별 1자리
            , substr(ssn,8) ssn_last 
            , concat(substr(ssn,0,7),'*******')
FROM INSA;

--sysdata > 현재 시스템 날짜/시간 정보, 함수()
select sysdata from dual;
select substr('abcdefg', -3,2)  --m 음수..? 끝을 시작 위치로 해서 문자열 잘라올때.
        , SUBSTR('abcdefg', -1,2)
from dual; --dual ? sys가 가지고 있는 dummy테이블

--[오라클 문자를 다루는 함수]
 SELECT ENAME, sal + nvl(comm,0) pay
                ,upper(ename)
                ,lower(ename)
                ,initcap(ename) --앞문자만 대문자
                ,length(ename) --문자열 길이
                , CONCAT(SUBSTR(ENAME,0,3),'***' )
 FROM EMP
 order by pay desc;
 --order by ename asc;
 --order by ename desc;
 
--[ 정렬 (SORT) ]: 오름차순(ASC), 내림차순 (DESC) 정렬
select city, buseo, jikwi, name
from insa
order by 1, 2 desc;
order by city asc, buseo asc;

--ORA-00911: invalid character
select '이름은 '|| ename || '이고, 직업은 ' || job || ' 이다.' AS MESSAGE
from emp;


--[INSTR() 문자 index찾기]
select instr('KOREA','E')
FROM dual;

select ename
        ,instr(ename,'J')
        ,INSTR(ENAME,'L')
        ,INSTR(ENAME,'L',3) --찾기 시작하는 위치가 3번째 인자값
from emp;
--where instr(ename,'J') =1; --ENAME 'J'가 첫문자로 시작하는 사원
--WHERE INSTR(ENAME,'L')>0; --L이 포함된 함수
select instr('corporate floor','or',-3,2)
       ,instr('corporate floor','or',3)  --'corporate floor'에서'or'이란 문자를 3인자값 이상부터 찾아라
       ,instr('corporate floor','or',3,2)-- 찾는 위치에서 2번째 있는 or
       ,instr('corporate floor','or',-3,2) --뒤에서 3번째 부터 2번째 있는 or
from dual;

SELECT *
FROM TEST;

--데이터 추가 : DML (insert문) + commit, rollback
--INSERT INTO 테이블명 (컬럼명..) VALUES 값;
INSERT INTO test (no, tel) VALUES (1,'02)235-1425'); 
INSERT INTO test (no, tel) VALUES (2,'031)268-2048');  
INSERT INTO test (no, tel) VALUES (3,'02)485-1777');
INSERT INTO test (no, tel) VALUES (4,'053)274-1523');  
commit;
-- 데이터 수정 : DML (update) --commut, rollback
--update 테이블명
--set 수정할 컬럼과 값
--where 어떤것을 수정 조건;

--instr() 설명
--ㄱ. 국번 출력
--ㄴ. 중간번호 출력
--ㄷ. 끝번호 출력

--select 
--   tel
--   , instr(tel, ')')
--   , instr(tel, '-')
--   , substr( tel, 1, instr(tel, ')')-1 ) 국번
--   , substr( tel,instr(tel, ')')+1,instr(tel, '-')-instr(tel, ')')-1  ) 중간전번
--   , substr( tel, instr(tel, '-')+1 ) 마지막전번4
--from test;

select SUBSTR(TEL,1,INSTR(TEL,')')) 국번
        ,substr(tel,INSTR(TEL,')')+1,3) 중간번호
        ,substr(tel,INSTR(TEL,'-')+1,4) 끝번호
from test;

with temp
as(
select tel
        ,INSTR(TEL,')')a
        ,INSTR(TEL,'-')b
from test
)
select  tel
   , substr( tel, 1, a-1 ) 국번
   , substr( tel, a+1,b-a-1  ) 중간전번
   , substr( tel, b+1 ) 마지막전번
from temp;



--[RPAD()/LPAD()] 함수설명 >자리수 확보, 원하는 문자열
SELECT ENAME
        ,SAL +NVL(COMM,0) pay
        , rpad(SAL +NVL(COMM,0),10,'*')rp
        ,lpad(SAL +NVL(COMM,0),10,'*')lp
from emp;

select no,tel
      ,rtrim(tel,'0')
      ,ltrim(tel,'0')
      ,ltrim('          hyangh       ',' ') || ']'
      ,rtrim('          hyangh       ',' ')|| ']'
      ,rtrim('******800*****','*')
      ,rtrim('BROWINGyxyxy','xy') a
from test;

--[ASCII]

select ename
        ,ascii(ename) --> 첫번째 문자값 아스키 코드 
from emp;

select ascii('홍길동')
from dual;

SELECT ENAME
        ,ASCII(ENAME)
        ,CHR(ASCII(ename))
        ,chr(15571341) --3바이트 
from emp;

SELECT GREATEST(10,50,30,20)
        ,LEAST(10,50,30,20)
        ,GREATEST('kbs','mbc','sbs')
        ,LEAST('kbs','mbc','sbs')
FROM DUAL;

select ename
    , replace(ename, 'LA') --> 두번째 인자값이 없으면 삭제
    , replace(ename, 'LA','★') 
    , replace(ename, 'LA','<span>LA</span>') 
FROM EMP;


SELECT ENAME
    ,LENGTH(ENAME)
    ,VSIZE(ENAME) || 'bytes'--1byte
FROM EMP;
   
SELECT name
    ,LENGTH(NAME)
    ,VSIZE(NAME) || 'bytes'--3byte
FROM insa;


--부서명 : 한글_ 시작하는 부서정보 출력
--like 연산자 : 와일드카드( % ,_ )
select *
from dept
where dname like '한글_%';

select *
from dept
where dname like '한글\_%';--\★ : ★를 와일드 카드에서 제외 시키겠다. 
                            --> 한글_ 가 들어가는 dname을 출력하라
                            
SELECT  *
FROM BOOKS
WHERE TITLE LIKE '%100\%%' escape '\';