--20180627

--[오라클 DATA TYPE]
--1. char == char(1) == char(1 byte) 2000 bytes 고정길이
--                      char(1 char)
--2. [n]char == nchar(1) unicode 1문자 2000 bytes 고정길이

-- ( 차이점 )
--3. [var]char == varchar2( size [byte| char]) 4000 bytes 가변길이
--  ex) name char(20)       == char(20byte)         'kenik---------------'
--      name varchar2(20)   == varchar2(20 bytes)   'kenik' 한글6문자,
--4. [n][var]char2 == nchar(1) unicode 1문자 4000 bytes 가변길이
--  ex) name nchar(10)      1문자 2byte   'lee----' 6bytes + 4bytes
--      name nvarchar(10)                'lee' 6bytes

--5. long  자바 byte < short < int < long 숫자형(정수)
--  문자 자료형 , 2GB, 가변길이

--6. NUMBER[(p,[s])]
--      p:1~38 ,s:-94~127
--      age number      == number(38, 127)
--      age number(3)   p  =   age number(3,0) 
--      age number(5,2) p,s

-- [p]recision 전체 자릿수 ( 정밀도*** )
-- [S]cale     소수점 이하 자릿수 ( 최대 유효숫자 자릿 수 ) 
-- 1~22byte
-- 

--p58 날짜 데이터 타입
-- DATE     BC4712년 1월 1일 ~ 9999년 12월 31일 년/월/일/시/분/초 까지
--


--테이블 생성, 수정, 삭제 등등 p48
--1. 데이터를 저장하기 위해 테이블 생성.

--!! 예약어 == 컬럼명 (주의)

--아이디 id 문자 varchar2 가변길이 20byte 설명 >기본키(pk)
--이름  name 문자 varchar2 가변길이 15byte 
--숫자  age 숫자(정수) number(3)  0~999 (제약 0~150)
--생일 birth 날짜  date
--
--제약조건 

--【간단한형식】
--    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--      ( 
--        열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
--       [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
--       [,...]  
--      ); 


create table test1(
id varchar2(20)
,name varchar2(15)
,age number(3)
,birth date

);

select *
from tabs
where table_name like 'test%';

--연락처 , 비고 컬럼 추가
--alter table 
--    add 컬럼 추가, 제약조건 추가

--【형식】컬럼추가
ALTER TABLE test1
ADD (
    tel varchar2(20) 
    ,bigo varchar2(255)
    -- , 국적 varchar2(100) default '대한민국'
  );

--컬럼 크기 수정 ( 비고 컬럼의 varchar2(255) -> (100) )
--【형식】
       ALTER TABLE test1
        MODIFY bigo varchar2(100);
    
    desc test1;
--alter table ~ modify 구문으로 직접적으로 컬럼명 수정 x
-->컬럼명 bigo-> etc 변경
alter table test1 rename column bigo to etc;
ALTER TABLE test1 DROP COLUMN etc; 

--테이블 명 test1을 exam1로 변경
rename test1 to exam1;

select *
from tabs;

--1) create table 문
--2) subquery를 이용한 테이블 생성

create table emp_30 as(
select deptno,empno, ename, hiredate
from emp
where deptno =30
);

create table emp_20 
as(
select empno, ename, sal + nvl(comm,0) pay
from emp
where deptno =20
);
select * from emp_20;

--(*****) emp -> emp_30, emp_20 테이블 생성
-- 컬럼들의 자료형은 서브쿼리의 자료형과 동일함.
desc emp_30;
desc emp_20; -- pay로 가공된 것은 시스템이 알아서 자료형 바꿈
-- 제약조건은 복사되지 않는다..(not null 제약조건만 복사)

--테이블 삭제
drop table exam1; -- 휴지통에 버림 (실제 삭제 xxx -> 복구가능 )
drop table exam1 purge; -- 영구삭제 (복구 불가능)

create table test1(
    num number(7) primary key
    ,name varchar2(20) not null
    , birth date not null
    ,memo varchar2(100)
);

insert into 테이블명 [(컬럼명...)] values (값...);
commit;
insert into test1(num, name, birth, memo) values(1,'이향아','1995/02/11','기타...');
select *
from test1;
insert into test1(num, name, birth, memo) values(2,'임해영','1996/01/28','기타...');
insert into test1(num, name, birth) values(3,'안소희','1992/06/27');
insert into test1(num, name, birth) values(4,'배수빈','1999/04/20');
commit;
insert into test1(num, name, birth) values(5,'원혜린',to_date('01/11/99','mm/dd/rr'));

create table test2 as (
select empno, ename,hiredate from emp where 1=0
);
-- 테이블의 구조는 복사하는데 레코드는 x
desc test2;
select * from test2;

insert into test2
    select empno, ename, hiredate from emp;
 --   12개 행 이(가) 삽입되었습니다.

--테이블 삭제 : drop table test2 purge;
-- test2 테이블 레코드(행) 삭제 : delete / truncate문
--truncate문 : where문 사용 xxx > 원하는 데이터 삭제 xxxxx & rollback,commit 사용 xxxxx
delete from test2;
rollback;

-- insert all : 하나의 insert문을 이용하여 여러 테이블에 데이터 추가 
drop table emp_30;

create table emp_10
as( select * from emp where 1=0 );

create table emp_20
as( select * from emp where 1=0 );

create table emp_30
as( select * from emp where 1=0 );

--[Unconditional insert]
insert all 
           into emp_10 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
           into emp_20 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
           select * from emp;

-- select * from emp 쿼리의 결과 중에 deptno = 10 -> emp_10 테이블

--[conditional insert]
insert all
when deptno = 10 then
    into emp_10 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
when deptno = 20 then
    into emp_20 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
when deptno = 30 then
    into emp_30 values ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
select * from emp;

select *
from emp_20;
rollback;
commit;

create table sales(
employee_id       number(6),
week_id            number(2),
sales_mon          number(8,2),
sales_tue          number(8,2),
sales_wed          number(8,2),
sales_thu          number(8,2),
sales_fri          number(8,2));

insert into sales values(1101,4,100,150,80,60,120);
insert into sales values(1102,5,300,300,230,120,150);

delete from sales where week_id =4;

select * from sales;

create table sales_data(
employee_id        number(6),
week_id            number(2),
sales              number(8,2));


--[Unconditioanl insert ]
insert all --피봇, 언피봇 가능 
    into sales_data values(employee_id, week_id, sales_mon)
    into sales_data values(employee_id, week_id, sales_tue)
    into sales_data values(employee_id, week_id, sales_wed)
    into sales_data values(employee_id, week_id, sales_thu)
    into sales_data values(employee_id, week_id, sales_fri)
    select employee_id, week_id, sales_mon, sales_tue, sales_wed,
           sales_thu, sales_fri
    from sales;
select * from sales_data;

--문제) insa테이블의 num, name 컬럼을 읽어와서 score 테이블 생성
drop table score;
commit;
create table score
as(
select num, name from insa);


--문제) kor, eng, mat, tot, savg 컬럼 추가
alter table score
add(
kor number(3)
,eng number(3)
,mat number(3)
,tot number(3)  default 0
,savg number(5,2) default 0.0
    );
    
-- DML : insert/ delete/ update 수정 - commit,rollback
-- 모든 학생의 국어 점수는 100점으로 설정 (총점 : 평균 수정...)
--update 테이블 명
--set 컬럼명 = 값...
--where 조건절;
update score
set kor = 100, tot = 100+nvl(eng,0)+nvl(mat,0), savg = (100+nvl(eng,0)+ nvl(mat,0))/3;
commit;

select num,name
from score
where name like '%진이%';

update score
set kor=98, eng=78, mat=55, tot = 98+78+55, savg= (98+78+55)/3
where num = 1014; 

update score
set kor = 90,eng=70, mat=80, tot = 90+70+80, savg= (90+70+80)/3
where num =1001;
update score
set kor = 70,eng=60, mat=80, tot = 70+60+80, savg= (70+60+80)/3
where num =1002;
update score
set kor = 60,eng=90, mat=80, tot = 60+90+80, savg= (60+90+80)/3
where num =1003;
update score
set kor = 50,eng=50, mat=50, tot = 50+50+50, savg= (50+50+50)/3
where num =1004;
update score
set kor = 90,eng=100, mat=35, tot = 90+100+35, savg= (90+100+35)/3
where num =1005;
commit;
delete from score
where eng is null;

alter table score rename column 판정 to result;
select * from score;

update score
set result = case
                when savg < 60 then '불합격'
                when (kor<40 or eng <40 or mat <40) then '과락'
                end '합격';
commit;
rollback;
--모든 학생의 mat 5점 추가 plus
update score
set mat = mat +5 , tot = tot +5 ,savg=tot +5/3, 
                result = case
                when (tot +5)/3 < 60 then '불합격'
                when (kor<40 or eng <40 or mat+5 <40) then '과락'
                else '합격'
                end ;
                
                
