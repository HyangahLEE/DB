-- 2018.07.04(수) : SCOTT
-- 네이버 검색 : 삽입 이상
-- "삽입 이상 데이터베이스 개론 기술/공학 > 컴퓨터/통신/IT"  - 클릭
-- 밑으로 스크롤 후 "정규화의 개념" 클릭
select *
from tabs
where table_name like 'SA%';
select * from sample;
-- 사원    부서
select *
from emp, dept
where emp.deptno = dept.deptno;
--
update emp
set dname = 'sales'
where empno=7369;

-- 오전 모델링..
-- 오후 PL/SQL 프로시저...
create or replace procedure up_프로시저명
(
   argument [(in) 입력용,out 출력용,in out입출력용] datatype,  
   argument [(in) 입력용,out 출력용,in out입출력용] datatype,
   argument [(in) 입력용,out 출력용,in out입출력용] datatype
)
is[as]  -- declare 익명 프로시저
  -- 변수,상수,커서 등 선언부    ;
begin
exception
end;
--
drop procedure 저장프로시저명;

-- num, name, kor, eng, mat, tot, savg, res
desc score;
--
select * from score;
-- insert into score 검색...
create or replace procedure up_insertScore
is
begin
  insert into score (num, name, kor, eng, mat, tot, savg, res)
  values (1007,'양욱형',98,78,66, 242,80.67, '합격' );
  commit;
-- exception
end;
-- Procedure UP_INSERTSCORE이(가) 컴파일되었습니다.
-- Procedure UP_INSERTSCORE 저장 프로시저 실행..
--  1) execute 문으로 실행.
execute UP_INSERTSCORE;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

--  2) 익명프로시저 안에서 실행
begin
  UP_INSERTSCORE;
end;

select *
from user_constraints
where table_name like 'SCO%';
-- 1007 num 학생 정보 삭제
delete from score where num = 1007; 
commit;
-- pk_score_num pk 제약 조건 추가..
alter table score
   add ( constraint pk_score_num primary key(num) );
--
--  3) 다른 저장 프로시저 안에서 실행
select * 
from score;
-- 입력 폼에서 번,이,국,영,수 입력.....
create or replace procedure up_insertScore
(
   pnum in number   -- 프로서지의 인자 datatype 에는  size X
   , pname in varchar2 
   , pkor in score.kor%type :=0
   , peng in number :=0 
   , pmat in number :=0
)
is
  -- 변수,상수,커서 등등 선언부
  vtot number(3) := 0;  -- 세미콜론
  vsavg number(5,2);
  vres varchar2(20) := '합격';
begin
  vtot := pkor + peng + pmat;
  vsavg := vtot / 3 ;
  -- vres 합,불,과락
  -- if 문 / case 문
  case
      when (vsavg < 60) then  vres :='불합격'; 
      when (pkor <40 or peng < 40 or (pmat) < 40 ) then  vres :='과락'; 
      else vres :='합격'; 
  end case ;

  insert into score (num, name, kor, eng, mat, tot, savg, res)
  values (pnum,pname,pkor,peng,pmat, vtot,vsavg, vres );
  commit;
-- exception
end;
-- Procedure UP_INSERTSCORE이(가) 컴파일되었습니다
desc score;
--
execute UP_INSERTSCORE(1008,'김동준',89,77,94);
exec    UP_INSERTSCORE(1009,'강필규',23,98,76);
exec    UP_INSERTSCORE(1010,'강필규');
exec    UP_INSERTSCORE(1011,'이혜원',pmat=>50);
--
select * from score;
-- score 테이블에 rk 컬럼 추가
alter table score
add ( rk number );
--
select * from score;
-- execute up_makeRank;
create or replace procedure up_makeRank
is
  vrank number;
begin
   -- for 커서
   for vrec in (select * from score)  
   loop
      select count(*)+1
       into vrank
    from score
    where tot > vrec.tot;
    update score
    set rk = vrank
    where num = vrec.num;
   end loop;
   
   commit;
-- exception
end;
-- 프로시저 실행
exec up_makeRank;
--
select * 
from score
order by rk asc
;
-- up_updateScore 프로시저
-- num , X
-- name/kor/eng/mat 수정
select * from score;
exec up_updateScore(1009,'강필구',1,2,3);
create or replace procedure up_updateScore
(
   pnum in number   -- 프로서지의 인자 datatype 에는  size X
   , pname in varchar2 
   , pkor in score.kor%type 
   , peng in number 
   , pmat in number 
)
is
  -- 변수,상수,커서 등등 선언부
  vtot number(3) := 0;  -- 세미콜론
  vsavg number(5,2);
  vres varchar2(20) := '합격';
begin
  vtot := pkor + peng + pmat;
  vsavg := vtot / 3 ;
  -- vres 합,불,과락
  -- if 문 / case 문
  case
      when (vsavg < 60) then  vres :='불합격'; 
      when (pkor <40 or peng < 40 or (pmat) < 40 ) then  vres :='과락'; 
      else vres :='합격'; 
  end case ;
  
  update score
  set  name = pname, kor=pkor, eng=peng, mat =pmat
  , tot = vtot, savg = vsavg, res = vres
  where num = pnum;
  commit;

   -- up_updateScore 프로시저 안에서 또 다른 프로시저 호출
   up_makeRank;
-- exception
end;