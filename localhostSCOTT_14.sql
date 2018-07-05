--2018.07.05 (목)

select * from user_sequences;
create sequence seq_dept
increment by 10
start with 50;

--1.dept 테이블 deptno, dname, loc


create or replace procedure up_insertDept
(
    pdname in dept.dname%type := null,
    ploc in dept.loc%type default null
)
is
begin
    insert into dept(deptno, dname, loc) values ( seq_dept.nextval, pdname,ploc);
    commit;
end;

execute up_insertDept('영업부','서울');

select * from dept;

create or replace procedure up_deleteDept
(pdeptno in dept.deptno%type := null)
is

begin

delete from dept where deptno = pdeptno;
commit;
end;

execute up_deleteDept(50);
execute up_deleteDept(70);

create or replace procedure up_updateDept
(
  pdeptno dept.deptno%type ,
  pdname varchar2 := null,
  ploc dept.loc%type default null
)
is
  vdname dept.dname%type;
  vloc   dept.loc%type;
begin
   select dname, loc 
      into vdname, vloc
   from dept
   where deptno = pdeptno;
   -- danme 널이면 예외 발생... 수정할 deptno 없다..
   update dept
   set   dname = case 
                   when pdname is null then vdname
                   else pdname
                 end
       , loc = case 
                 when ploc is null then vloc
                 else ploc
             end
   where deptno = pdeptno;
   commit;
-- exception
end;

execute up_updateDept(50);
execute up_updateDept(60,ploc=>'충주');


create or replace procedure up_selectDept
(
  pdeptno dept.deptno%type := null
)
is
  vrec dept%rowtype;
begin
  if pdeptno is null then
    for vrec in (select * from dept)
    loop
      dbms_output.put_line(vrec.deptno || ' ' || vrec.dname 
                       || ' ' ||  vrec.loc);
    end loop;
  else
      select * 
         into vrec
      from dept
      where deptno = pdeptno;
      dbms_output.put_line(vrec.deptno || ' ' || vrec.dname 
                       || ' ' ||  vrec.loc);
  end if;
-- exception
end;

-- 프로시저 확인
exec up_selectDept(10);
exec up_selectDept;

--
create or replace procedure up_test
(
   pa in number      -- 입력용
   , pb in number    -- 입력용 파라미터
   , pc out number   -- 출력용 파라미터
)
is
begin
   pc   :=   pa + pb ;  -- c 파라미터 1234 값을 할당(대입)
-- exception
end;

-- variable / print 키워드?
variable c number;
exec  up_test(100,200, :c );
print c;
--
variable aa number;
begin 
   :aa :=  55;
end;
print aa;
--
create or replace procedure up_empnoCheck
(
pempno EMP.EMPNO%type,
pempnoCheck out number
)
is
begin
    select count(*)
            into pempnoCheck
    from emp
    where empno = pempno;
end;

 -- 회원 가입할 때
-- 아이디   [ kenik ] [사용여부버튼]
-- kenik -> 고객테이블   id  

-- 아이디 중복 체크하는 프로시저 : up_idCheck
-- pempno    in   kenik
-- pempnoCheck out  1, 0
-- emp 테이블        empno

var vempnoCheck number;
begin
    up_empnoCheck( 7369 , :vempnoCheck );
    
    if :vempnoCheck=1 then
        DBMS_OUTPUT.PUT_LINE('사용 불가능 합니다.');
    else
        DBMS_OUTPUT.PUT_LINE('사용 가능합니다.');
    end if;
end;
--exec up_empnoCheck( 7369 , :vempnoCheck );  -- 0
--exec up_empnoCheck( 7777 , :vempnoCheck );  -- 1
print empnoCheck;  

-- [ 로그인 ] 인증
--id
--password
--[로그인]
-- 1)id 존재하지 않을 경우      
-- 2)id 존재하지만 password가 맞지 않을경우
-- 3)id/password 성공 -> 로그인성공

--empno -1
--ename 0
--empno/ename 1

create or replace procedure up_logon
(
pid emp.empno%type
,ppwd emp.ename%type
,presult out number
)
is 
 vid number(1); --존재하면 1 아니면 0
 vpwd emp.ename%type;
begin
  select count(*)
        into vid
    from emp
    where empno = pid;
    
    if vid =1 then 
        select ename into vpwd
        from emp 
        where empno = pid;
      if vpwd = ppwd
      then presult := 1;
      else presult := 0;
      end if;
    else
         presult := -1;
    end if;
end;

var vresult number;

begin
  up_logon(7369,'SMITH',:vresult);
  if( :vresult = -1 ) then
     dbms_output.put_line('ID(empno)가 존재하지 않습니다.');
  elsif :vresult = 0  then
    dbms_output.put_line('PWD(ename)가 틀렸습니다.');
  elsif :vresult = 1  then
     dbms_output.put_line('로그인 성공.');
  end if;
end;

--

create or replace procedure add_one
 (p_phone_no    IN OUT  varchar2)
IS
BEGIN
p_phone_no := SUBSTR (p_phone_no, 1,1) || 1 ||
  SUBSTR(p_phone_no, 2, length(p_phone_no));
END add_one;

-- 2. 세션 유지 할 수 있는 변수
variable phone_num varchar2(15);
begin 
    :phone_num := '1234-121212';
END;
print phone_num;
execute add_one(:phone_num);
-------------------------------
-->> 테이블 2개 생성
--mem1<아이디/비밀번호/이름>

CREATE TABLE mem1 (
	id VARCHAR2(20) 
    ,pwd VARCHAR2(20) NOT NULL
    ,name VARCHAR2(20) NOT NULL
    ,CONSTRAINT pk_mem1_id PRIMARY KEY(id)
);

--mem2<아이디/연락처/생일>
CREATE TABLE mem2 (
	id VARCHAR2(20)--식별관ㄱㅖ pfk
    ,tel VARCHAR2(20)
    ,birth DATE
    ,CONSTRAINT pk_mem2_id PRIMARY KEY(id)
    ,CONSTRAINT fk_mem2_id FOREIGN KEY (id) REFERENCES mem1(id)
);
----------
-->> 프로시저 생성 (insMem)
CREATE OR REPLACE PROCEDURE insMem
(
	pid IN mem1.id%TYPE
    ,ppwd IN mem1.pwd%TYPE
    ,pname IN mem1.name%TYPE
    ,ptel IN mem2.tel%TYPE  :=null
    ,pbirth IN mem2.birth%TYPE :=null
)
IS
BEGIN
    INSERT INTO mem1(id, pwd, name)	VALUES(pid, ppwd, pname);

    IF
           NOT(ptel IS NULL AND pbirth IS NULL)  
        or ( ptel IS NULL AND pbirth IS not NULL ) 
        or ( ptel IS not NULL AND pbirth IS NULL ) 
    then 
      INSERT INTO mem2(id, tel, birth)
              VALUES (pid, ptel, pbirth);
    END IF;
    COMMIT;
END;

EXECUTE insMem('11', '11', '홍길동', '111-111-111', '2000-10-10');
EXECUTE insMem('22', '22', '김길동', '111-222-111', NULL);
EXECUTE insMem('33', '33', '박길동', NULL, '2000-08-08');
EXECUTE insMem('44', '44', '최길동', null, null);

SELECT * FROM mem1;
SELECT * FROM mem2;
--
select *
from user_procedures;


---------------
-- stored Function( 저장 함수 )
-- 차이점 ? 리턴값
--create or replace function 함수명
--(
--)
--return 자료형;
--is
--begin 
--    return(리턴값)
--end;

--insa 테이블 num, name, ssn
select num,name, ssn
        ,decode( mod( substr(ssn,8,1) ,2),0,'여','남') as gender
from insa;
--주민번호 -> 남자 여자 저장함수 선언 ->사용
-- 저장함수 : select 절, 프로시저
select num, name, ssn, getGender(ssn)
from insa;
--
create or replace function getGender
(
 pssn insa.ssn%type
)
return varchar2
is 
    vgender varchar2(6) :='여자';
begin
    if mod( substr(pssn,8,1),2)=1 
    then vgender :='남자';
    end if;
    return vgender;
end;

select getGender('950211-1111111')
from dual;

grant select on insa to hr;

-- 커서 ( cursor )
-- 1)커서 정의 2)커서 사용 3)커서 종류 4) 커서 생-사 형식


declare
  --vemprow emp%rowtype;
begin

    for vemprow in ( select * from emp)
    loop
     dbms_output.put_line( vemprow.empno || ' ' ||
   vemprow.ename || ' ' ||
   vemprow.sal || ' ' ||
   vemprow.hiredate
   );
    end loop;
-- exception
end;

--> 명시적 커서 

declare
  vemprow emp%rowtype;
 cursor emp_list
    is select * from emp;
begin
    open emp_list;
    
    loop
        fetch emp_list into vemprow;
         dbms_output.put_line( vemprow.empno || ' ' ||
   vemprow.ename || ' ' ||
   vemprow.sal || ' ' ||
   vemprow.hiredate
   );
    exit when emp_list%notfound;
    end loop;  
    
    close emp_list;
end;
--
--up_emplist 저장 프로시저
create or replace procedure up_emplist
--()
is
  vemprow emp%rowtype;
  cursor emp_list 
     is select * from emp;
begin
   open emp_list;
   
   loop
     fetch emp_list into vemprow;
     exit when emp_list%notfound;  
     dbms_output.put_line( vemprow.empno || ' ' ||
      vemprow.ename || ' ' ||
      vemprow.sal || ' ' ||
      vemprow.hiredate
     );
   end loop;
   
   close emp_list;
-- exception
end;

-- 테스트
exec up_emplist;

--up_emplist 프로시저 수정 : deptno 부서번호 매개변수
create or replace procedure up_emplist_dept
(
    pdeptno emp.deptno%type
)
is
  vemprow emp%rowtype;
  cursor emp_list 
     is select * from emp where deptno = pdeptno;
begin
   open emp_list;
   
   loop
     fetch emp_list into vemprow;
     exit when emp_list%notfound;  
     dbms_output.put_line( vemprow.empno || ' ' ||
      vemprow.ename || ' ' ||
      vemprow.sal || ' ' ||
      vemprow.hiredate
     );
   end loop;
   
   close emp_list;
-- exception
end;

--테스트
exec up_emplist_dept(30);

--> 커서의 파라미터를 이용하는 방법
create or replace procedure up_emplist_dept
(
    pdeptno emp.deptno%type
)
is
  vemprow emp%rowtype;
  cursor emp_list(p_pdeptno emp.deptno%type)
     is select * from emp where deptno = p_pdeptno;
begin
    --커서의 매개변수
   open emp_list(pdeptno);
   
   loop
     fetch emp_list into vemprow;
     exit when emp_list%notfound;  
     dbms_output.put_line( vemprow.empno || ' ' ||
      vemprow.ename || ' ' ||
      vemprow.sal || ' ' ||
      vemprow.hiredate
     );
   end loop;
   
   close emp_list;
-- exception
end;
