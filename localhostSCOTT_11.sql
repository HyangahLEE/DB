--2018-07-02 (월)

--시퀀스 ( SEQUENCE )
--【형식】
--	CREATE SEQUENCE 시퀀스명
--	[ INCREMENT BY 정수] --증가치 1
--	[ START WITH 정수] --얼마부터 증가할거니
--	[ MAXVALUE n ? NOMAXVALUE] --순번의 최대값
--	[ MINVALUE n ? NOMINVALUE] --순번의 최소값
--	[ CYCLE ? NOCYCLE] --
--	[ CACHE n ? NOCACHE]; --캐시 시퀀스를 이미 20 개 가지고 있음 (기다리지 않고 빠르게 처리 )

CREATE SEQUENCE seq1;
CREATE SEQUENCE seq2
increment by 1
start with 1;

select * from dept;
create sequence seq_deptno
increment by 10
start with 50;

--시퀀스 목록 확인
select * from seq; --user_sequence

--*이미 사용한 시퀀스는 되돌릴수 없다 (번호 되돌리기 못함)
--seq_deptno.nextval 사용한적이 없기때문에 오류 (최소한 한번은 써야지 nextval이 생성된다.)
--(오류)ORA-08002: sequence SEQ_DEPTNO.CURRVAL is not yet defined in this session
select seq_deptno.currval
from dual;
--dept 테이블 seq_Deptno 시퀀스 사용 부서 insert
insert into dept (deptno, dname, loc) values (seq_deptno.nextval,'생산부','서울');
insert into dept (deptno, dname, loc) values (seq_deptno.nextval,'영업부','수원');
select * from dept;
rollback;

create sequence seq_cstVSBoard
increment by 1
start with 1
nocycle
nocache;

create table cstVSBoard (
  seq number not null primary key ,
  writer varchar2(20) not null ,
  pwd varchar2(20) not null ,
  email varchar2(100),
  title varchar2(200) not null ,
  writedate date default sysdate,
  readed number default 0 ,
  ismode char(1) , --y,n
  content clob
  );
  
  --[글쓰기 쿼리]
  insert into cstVSBoard  (seq,writer,pwd,email,title,ismode,content) 
  values (SEQ_CSTVSBOARD.NEXTVAL,'이향아','1234',null,'첫 게시글','y','내용 없음!!');
   insert into cstVSBoard  (seq,writer,pwd,email,title,ismode,content) 
  values (SEQ_CSTVSBOARD.NEXTVAL,'이향아','1234',null,'10 게시글','y','내용 없음!!');
    commit;
  select *
  from cstVSBoard;

 --[글목록]
 select seq,writer, email,title, writedate, readed
 from cstVSBoard
 order by seq desc;

--ㄱ. 한 페이지 당 몇개 게시글? 3
--ㄴ. 총 페이지 수 ? 11/3


--ㄷ. [1],2,3,4
--ㄹ. 선택한 페이지 번호 출력
select seq,writer,email,title, writedate,readed
from(
 select rank() over(order by seq desc) no,seq,writer, email,title, writedate, readed
 from cstVSBoard
 )
 where no between 3*(:pn-1)+1 and 3*(:pn-1)+3;

--[글보기]
--> 트랜잭션 처리 필요 1)2)
--1)조회수 증가
update CSTVSBOARD
set readed = readed +1
where seq = :seq;
commit;

--2) seq 해당 게시글 select
select seq,readed, writer, title, content, writedate
from CSTVSBOARD
where seq = :seq;

--글목록 -> 글보기 ( 답글, 수정, 삭제 )
-- 1) 삭제 권한 확인?
select pwd
from cstvsboard
where seq=:seq;
--pwd=:pwd
select count(*)
from cstvsboard
where seq = 4 and pwd = :pwd;
-- 2) 실제 게시글 삭제 
delete from cstvsboard
where seq= :seq;
commit;

-- 수정
--1) 수정할 권한이 있는지 확인
--2) 수정할 seq 게시글 select  -> 화면출력
Update  cstvsboard
set title = :title, content = :content, email = :email
where seq = :seq;
commit;

-- 검색
select seq,writer,email,title, writedate,readed
from(
 select rank() over(order by seq desc) no,seq,writer, email,title, writedate, readed
 from cstVSBoard
 --where writer like '%:writer%' 
 --where title like '%:title%'
 
 -- where title like '%열%' and content like '%열%'
 )
 where no between 3*(:pn-1)+1 and 3*(:pn-1)+3;
 
--PL/SQL
--SQL + PL = PL/SQL ( 오라클 )

--[declare]
--    1 block 선언 부분 ( 변수, 상수 , 커서(cursor) 선언)
--      a 변수;
--      b 상수;
--      c 커서;
--begin
--    2 block 실행 부분 ( sql실행 - s,i,u,d 등 )
--      insert~;
--      update~;
--
--[exception]
--    3 block - 예외처리부분
--end
--; 지금부터 pl/sql 무조건 실행 부분 선택해서 실행

declare
    --변수
    vnum number;
    vname varchar2(20);
    --상수
    pi constant number(5,3) := 3.14;
begin
    --오라클 값 대입연산자 ? :=  =
    --자바                =   ==
    vnum := 100;
    vname := '홍길동';
    -- 변수 출력
    dbms_output.put_line( '> num =' || vnum);
--exception
end;
--익명 프로시져
declare
    --vename varchar2(10);
    --vsal number(7,2); --자료형 같거나 커야한다.!!!!
    
    --%type 변수 선언
    -->테이블의 구조가 자주 변경되더라고 pl/sql 수정 xx
    vename emp.ename%type;
    vsal emp.sal%type;
begin
    select ename, sal
        into vename, vsal
       -- into 구문 : select, fetch에서 사용되는 절
    from emp
    where empno = 7369;
    
    dbms_output.put_line('> ename : '|| vename ||' , '|| '> sal : ' || vsal);
--exception
end;

--ORA-01422: exact fetch returns more than requested number of rows
--pl/sql 안에서 여러 개의 행을 처리할 때는 커서 사용.
declare
    vename emp.ename%type;
begin
    select ename
        into vename
    from emp
    where deptno=10;
    dbms_output.put_line('> ename : '|| vename);
end;

/*
declare
    vempno emp.empno%type;
    vename emp.ename%type;
    vsal emp.sal%type;
    vcomm emp.comm%type;
    vdeptno emp.deptno%type; 
    vhiredate emp.hiredate%type;
begin
    select empno, ename, sal, comm, deptno, hiredate
        into vempno, vename, vsal, vcomm, vdeptno, vhiredate
    from emp 
    where empno = 7369;
    
    dbms_output.put_line(vempno);
    dbms_output.put_line(vename);
    dbms_output.put_line(vsal);
    dbms_output.put_line(vcomm);
    dbms_output.put_line(vdeptno);
    dbms_output.put_line(vhiredate);

end;*/

--> [%rowtype형 변수 선언]
declare
   vemprow emp%rowtype;
begin
    select empno, ename, sal, comm, deptno, hiredate
        into vemprow.empno, vemprow.ename, vemprow.sal, vemprow.comm, vemprow.deptno, vemprow.hiredate
    from emp 
    where empno = 7369;
    
    dbms_output.put_line(vemprow.empno);
    dbms_output.put_line(vemprow.ename);
    dbms_output.put_line(vemprow.sal);
    dbms_output.put_line(vemprow.comm);
    dbms_output.put_line(vemprow.deptno);
    dbms_output.put_line(vemprow.hiredate);
end;

declare
    vn number := 10;
    vm number;
    vresult number :=0;
begin
    vm :=20;
    vresult := vn +vm;
    DBMS_OUTPUT.PUT_LINE(vn ||'+'||vm||'='||vresult);
end;

--[PL/SQL 제어문]

--IF [(조건식)] THEN
--END IF;

DECLARe
    vkor number(3):=0;
    vRESULT varchar2(10):='수';
begin 
    --실행부
    select kor 
        into vkor
    from score
    where num =1002;
    --
    if(vkor>=90) then DBMS_OUTPUT.PUT_LINE('수');
    elsif (vkor>=80 and vkor<90) then DBMS_OUTPUT.PUT_LINE('우');
    elsif (vkor>=70 and vkor<80) then DBMS_OUTPUT.PUT_LINE('미');
    elsif (vkor>=60 and vkor<70) then DBMS_OUTPUT.PUT_LINE('양');
    else DBMS_OUTPUT.PUT_LINE('가');
    
    end if;
end;