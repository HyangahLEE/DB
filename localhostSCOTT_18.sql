-- 2018. 07. 11.(수) 18일차

-- p432 ~ p452 동적 SQL

-- 익명 프로시저
--1.
declare
    vsql varchar2(1000);
begin
    vsql := 'select deptno, empno, ename, job ';
    vsql := vsql ||' from emp ';
    vsql := vsql || ' where empno = 7369 ';
    
    execute immediate vsql; -- 동적쿼리 실행 (NDS)
end;


--2 
declare
    vsql varchar2(1000);
    vdeptno emp.deptno%type; 
    vempno emp.empno%type; 
    vename emp.ename%type; 
    vjob emp.job%type; 
begin
    vsql := 'select deptno, empno, ename, job ';    
    vsql := vsql ||' from emp ';
    vsql := vsql || ' where empno = 7369 ';
    
    execute immediate vsql -- 동적쿼리 실행 (NDS)
    into vdeptno, vempno, vename, vjob;
    dbms_output.put_line( vdeptno || ' ' || vempno || ' ' || vename ||' ' || vjob) ;   
end;


--3
declare
    vsql varchar2(1000);
    vdeptno emp.deptno%type; 
    vempno emp.empno%type; 
    vename emp.ename%type; 
    vjob emp.job%type; 
    
    pempno emp.empno%type := 7369;
begin
    vsql := 'select deptno, empno, ename, job ';    
    vsql := vsql ||' from emp ';
    vsql := vsql || ' where empno = ' || pempno;
    
    execute immediate vsql -- 동적쿼리 실행 (NDS)
    into vdeptno, vempno, vename, vjob;
    dbms_output.put_line( vdeptno || ' ' || vempno || ' ' || vename ||' ' || vjob) ;   
end;


--4
declare
    vsql varchar2(1000);
    vdeptno emp.deptno%type; 
    vempno emp.empno%type; 
    vename emp.ename%type; 
    vjob emp.job%type; 
    
    pempno emp.empno%type := 7369;
begin
    vsql := 'select deptno, empno, ename, job ';    
    vsql := vsql ||' from emp ';
    vsql := vsql || ' where empno = ' || pempno;
    
    execute immediate vsql -- 동적쿼리 실행 (NDS)
    into vdeptno, vempno, vename, vjob;
    dbms_output.put_line( vdeptno || ' ' || vempno || ' ' || vename ||' ' || vjob) ;   
    
end;
--5. 동적 sql를 dml사용 
create or replace procedure up_insert_dept
(
    pdeptno dept.deptno%type,
    pdname dept.dname%type,
    ploc dept.loc%type
)
is 
    vdeptno dept.deptno%type;
    vsql varchar2(1000);
begin
    vsql :='insert into dept ';--공백 꼭!!!붙여주기
    vsql := vsql || ' values (:a, :b, :c)';
    
    execute immediate vsql
        using vdeptno,pdname, ploc;
end;

exec up_insert_dept('영업부','서울');
select * from dept;
rollback;

--p 447 open for문 ****
--select 동적sql의 결과가 다중행을...처리?  open for문 사용

--커서변수를 사용하는 방법 2가지
--ㄱ. ref cursor
--ㄴ. sys_refcursor  
--open 커서변수 for 동적sql
--using 매개변수 ...;


--6.
declare
    --커서변수 1) ref cursor 사용
    --ㄱ. 커서 타입 선언
    type query_physicist is ref cursor;
    --ㄴ. 커서 변수 선언
    vcursor query_physicist;
    vsql varchar2(1000);
    vrow emp%rowtype;
    pdeptno dept.deptno%type := 10;
begin 
    vsql := 'select * ';
    vsql := vsql || ' from emp ';
    vsql := vsql || ' where deptno = :deptno ';
    open vcursor for vsql
    using pdeptno;
    
    --동적 sql 결과 확인
    loop
    fetch vcursor into vrow;
    exit when vcursor%notfound;
    dbms_output.put_line( vrow.deptno || ' ' || vrow.empno || ' ' || vrow.ename ||' ' || vrow.job) ; 
    end loop;
    close vcursor;
end;

--7
declare
    --커서변수  sys_refcursor 사용
    vcursor sys_refcursor;
    vsql varchar2(1000);
    vrow emp%rowtype;
    pdeptno dept.deptno%type := 10;
begin 
    vsql := 'select * ';
    vsql := vsql || ' from emp ';
    vsql := vsql || ' where deptno = :deptno ';
    open vcursor for vsql
    using pdeptno;
    

    loop
    fetch vcursor into vrow;
    exit when vcursor%notfound;
    dbms_output.put_line( vrow.deptno || ' ' || vrow.empno || ' ' || vrow.ename ||' ' || vrow.job) ; 
    end loop;
    close vcursor;
end;

--
select *
from cstvsboard
where title like '%-64%' or content like '%-64%';
where writer like 'admin';
where title like '%-64%';
-- 랜덤하게 5명 writer 컬럼 admin 으로 수정.
declare
  vseq cstvsboard.seq%type;
  vsql varchar2(1000);
begin
  for i in 1.. 5
  loop
    vseq := round(dbms_random.value(1, 300));
    vsql := 'update cstvsboard    set writer = ''admin''     where seq = ' || vseq;
    execute immediate vsql;
  end loop;
  commit;
end;

--
-- ■ where 조건절이 동적으로 바뀌는 경우
-- ( 이름, 제목, 제목+내용 으로 검색 )
create or replace procedure up_search_cstvsboard
(
  psearchCondition number,
  psearchWord varchar2
)
is
-- ㄱ. 커서 변수 선언 
  vcursor SYS_REFCURSOR; 
  vrow cstvsboard%rowtype;
  vsql varchar2(1000); 
begin
  vsql := 'select * from cstvsboard ';
  if(  psearchCondition = 1) then
    vsql := vsql || ' where writer like :sword';
  elsif(  psearchCondition = 2) then
    vsql := vsql || ' where title like :sword';
  elsif(  psearchCondition = 3) then
    vsql := vsql || ' where title like :sword or content like :sword';
  end if;
  -- 
  
  if psearchCondition = 3 then
     open vcursor for vsql using '%' || psearchWord || '%', '%' || psearchWord || '%';
  else
     open vcursor for vsql using '%' || psearchWord || '%';
  end if;
  
  -- 지금은 여기서 출력해서 확인
  loop
  fetch vcursor into vrow;
  exit when vcursor%notfound;
  dbms_output.put_line(vrow.writer || ' ' ||vrow.title);
  end loop;
  close vcursor;          
end;
--
update cstvsboard
set   content = 'XXX-646'
where seq = 100;
commit;
-- 테스트
execute UP_SEARCH_CSTVSBOARD( 1, 'adm'); 
execute UP_SEARCH_CSTVSBOARD( 2, '-646');
execute UP_SEARCH_CSTVSBOARD( 3, '-646');
--
--p431
------------------

CREATE OR REPLACE PACKAGE CryptIT AS 
   FUNCTION encrypt( str VARCHAR2,  
                     hash VARCHAR2 ) RETURN VARCHAR2;
   FUNCTION decrypt( xCrypt VARCHAR2,
                     hash VARCHAR2 ) RETURN VARCHAR2;
END CryptIT;


-- 패키지 몸체
CREATE OR REPLACE PACKAGE BODY CryptIT IS 
   crypted_string VARCHAR2(2000);
 
   FUNCTION encrypt(str VARCHAR2, hash VARCHAR2)
   RETURN VARCHAR2
   IS
       pieces_of_eight NUMBER := ((FLOOR(LENGTH(str)/8 + .9)) * 8);
    BEGIN
       dbms_obfuscation_toolkit.DESEncrypt(
               input_string     => RPAD(str, pieces_of_eight ),
               key_string       => RPAD(hash,8,'#'), 
               encrypted_string => crypted_string );

      RETURN crypted_string;
   END;
 
   FUNCTION decrypt( xCrypt VARCHAR2, hash VARCHAR2 )
   RETURN VARCHAR2 IS
   BEGIN
      dbms_obfuscation_toolkit.DESDecrypt(
               input_string     => xCrypt, 
               key_string       => RPAD(hash,8,'#'), 
               decrypted_string => crypted_string );

      RETURN TRIM(crypted_string);
   END;
END CryptIT;