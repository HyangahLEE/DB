-- 2018.07.05(목) : SCOTT
select *
from dept;
-- 시퀀스 조회
select * from user_sequences;
-- 시퀀스 생성 seq_dept   s50  i10 
drop sequence seq_Dept;
create sequence seq_dept
increment by 10
start with 50;
-- 1. dept 테이블    deptno ( 시퀀스 ) , dname  ( 부서명 ) , loc( 지역 ))
exec up_insertDept( '영업부','서울');
exec up_insertDept( pdname => '영업부');
exec up_insertDept( ploc => '서울');
exec up_insertDept ;
--
create or replace procedure up_insertDept
(
    pdname varchar2 := null,
    ploc dept.loc%type default null
)
is  
begin
    insert into dept values ( seq_dept.nextval , pdname, ploc );
    commit;
--exception
end;
--
desc dept;
select * from user_constraints
where table_name like 'DEPT%';
--
rollback;

-- 부서번호를 입력받아서 삭제 프로시저 만들어서 테스트
-- up_deleteDept
-- pdeptno
create or replace procedure up_deleteDept
(
  pdeptno dept.deptno%type
)
is
begin
  delete from dept
  where deptno = pdeptno;
  commit; -- 프로시저 DML 사용 후 commit/rollback
-- exception
end;

-- exec up_deleteDept(50);
exec up_deleteDept(60);
exec up_deleteDept(70);
--
select * from dept;
-- 조회 up_selectDept

-- 수정 up_updateDept
-- pdeptno
-- pdname, ploc  null
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
--
exec up_updateDept ( 50 );
exec up_updateDept ( 50 , pdname => 'XXX');  -- loc  서울
exec up_updateDept ( 50 , ploc => 'YYY');  -- 영업부
--
select * from dept;
--
exec up_deleteDept(50);


-- 10 XXX YYY
-- select * from dept;
create or replace procedure up_selectDept
(
  pdeptno in dept.deptno%type := null
)
is
  vrec dept%rowtype; -- %rowtype형 변수 
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

-- parameter 선언 mode     :  [in]    out     in out
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
--
variable c number;
exec  up_test(100,200, :c );
print c;


-- variable / print 키워드 ? 

--
variable aa number;
begin 
   :aa :=  55;
end;
print aa;

-- 회원 가입할 때
-- 아이디   [ kenik ] [사용여부버튼]
-- kenik -> 고객테이블   id  

-- 아이디 중복 체크하는 프로시저 : up_idCheck
-- pempno    in   kenik
-- pempnoCheck out  1, 0
-- emp 테이블        empno 
--
create or replace procedure up_empnoCheck
(
  pempno      in  emp.empno%type
  , pempnoCheck out number 
)
is
begin
   select count(*)
       into pempnoCheck
   from emp
   where empno = pempno;
     
-- exception
end;

-- 테스트
var empnoCheck number; 
begin
   up_empnoCheck( 7369 , :empnoCheck );  -- 1
  --up_empnoCheck( 7777 , :empnoCheck );  -- 0
  if :empnoCheck = 1 then
      dbms_output.put_line('empno 사용 중입니다.');
  else
      dbms_output.put_line('empno 사용 가능합니다.');
  end if; 
end;
print empnoCheck;  
-- [ 로그인 ]  인증
-- id
-- password
-- [로그인]
1) id 존재하지 않을 경우                 ( 로그인 실패 )  empno
2) id 존재하는 데 password 틀린 경우                     ename
3) id/password 맞고      ( 로그인 성공 )
emp
empno    -1
ename     0
empno/ename 1
-- up_logon
create or replace procedure up_logon
(
    pid        in emp.empno%type
    , ppwd     in emp.ename%type
    , presult out number
)
is
  vid number(1); -- 1   0
  vpwd emp.ename%type;
begin
   select count(*) into vid   -- 1
   from emp
   where empno = pid;
   
   if vid = 1 then  -- id 존재한다면
     select ename into vpwd
     from emp
     where empno = pid;
     
     if vpwd = ppwd  then
       presult := 1;
     else
       presult := 0;
     end if;
   else
     presult := -1;
   end if;
-- exception
end;
--
var vresult number;

begin
  up_logon(7369,'XXX',:vresult);
  if( :vresult = -1 ) then
     dbms_output.put_line('ID(empno)가 존재하지 않습니다.');
  elsif :vresult = 0  then
    dbms_output.put_line('PWD(ename)가 틀렸습니다.');
  elsif :vresult = 1  then
     dbms_output.put_line('로그인 성공.');
  end if;
end; 
--
CREATE OR REPLACE PROCEDURE hire_emp
(
 v_emp_name     IN emp.ename%type,
 v_emp_job      IN emp.job%type,
 v_mgr_no       IN emp.mgr%type,
 v_emp_sal      IN emp.sal%type
 )
IS
 v_emp_comm        emp.comm%type;
 v_dept_no         emp.deptno%type;
BEGIN
 IF v_emp_job = 'SALESMAN' THEN
    v_emp_comm := 0;     /* 0 for salesperson */
 ELSE
    v_emp_comm := NULL;  /* NULL for non-salesperson */
 END IF;
 
SELECT deptno INTO v_dept_no
FROM emp 
WHERE empno = v_mgr_no;

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
  values(s_emp_id.NEXTVAL, v_emp_name, v_emp_job,
        v_mgr_no, SYSDATE, v_emp_sal, v_emp_comm, v_dept_no);
COMMIT WORK;
END hire_emp;
--
--class Car{
--} // Car

create or replace procedure query_emp
 (
  v_emp_no      IN   emp.empno%type,
        v_emp_name    OUT  emp.ename%type,
        v_emp_sal     OUT  emp.sal%type,
        v_emp_comm    OUT  emp.comm%type
  )
IS
BEGIN
select ename, sal, comm
     INTO v_emp_name, v_emp_sal, v_emp_comm
FROM emp
WHERE empno=v_emp_no;
END query_emp;
/

-- IN OUT 입출력용 매개변수 사용
-- 1. 
create or replace procedure add_one
(
  p_phone_no    IN OUT  varchar2   -- '1123'
)
IS
BEGIN
  p_phone_no := SUBSTR(p_phone_no, 1,1) ||  1  ||
  SUBSTR(p_phone_no, 2, length(p_phone_no));
END add_one;
-- 2. 세션 유지할 수 있는 변수 
variable phone_num varchar2(15);
-- 3. PL/SQL 문에서만 사용...
begin 
  :phone_num := '1234-121212';
END;
-- 4. 
execute add_one(:phone_num); 
-- 6.
print phone_num;

-- 아이디/ 비밀번호/ 이름
CREATE TABLE mem1 (
	  id VARCHAR2(20) 
    ,pwd VARCHAR2(20) NOT NULL
    ,name VARCHAR2(20) NOT NULL
    ,CONSTRAINT pk_mem1_id PRIMARY KEY(id)
);

-- 아이디, 연락처, 생일 
CREATE TABLE mem2 (
	id VARCHAR2(20) -- 식별관계  PK, FK
    ,tel VARCHAR2(20)
    ,birth DATE
    ,CONSTRAINT pk_mem2_id PRIMARY KEY(id)
    ,CONSTRAINT fk_mem2_id FOREIGN KEY (id) REFERENCES mem1(id)
);
--             id     pwd   name     tel              bith
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

-- 오후 stored function ( 저장 함수 )
-- 한가지 차이점 : 리턴값
create or replace [function] 함수명
(
   p           ,
   p           ,
   p           
)
return 자료형;                  public static int hap(int a, int b)
is
  v~~~ 변수,상수, 커서 선언
begin
  --
  --
  --
  return (리턴값);
exception
end;
-- insa 테이블  num, name, ssn
select num, name, ssn
    , decode(  mod( substr(ssn,8,1) , 2 ) , 1, '남자', '여자') gender_1
    , case mod( substr(ssn,8,1) , 2)
         when 1 then '남자'
         else        '여자'
      end gender_2
from insa;
-- 주민번호 -> '남자' '여자'  저장 함수 선언-> 사용
-- 저장 함수 : select 절 , 프로시저 안에서 사용 가능..
select num, name, ssn
   , getGender(ssn)
from insa;
--
create or replace function getGender
(
   pssn insa.ssn%type
)
return varchar2 
is
  vgender varchar2(6) := '여자';
begin
   if mod( substr( pssn, 8, 1), 2 ) = 1 then
      vgender := '남자';
   end if;
   return vgender;
--exception
end;
-- Function GETGENDER이(가) 컴파일되었습니다.
select getGender('123456-1234567')
from dual;

-- 소유자 : SCOTT    -> HR 저장함수 권한 부여..
grant select  on emp to hr;
grant  execute on getGender  to hr;

--
-- stored function 
-- 1) 1~n 합을 구해서 반환하는 getSum(10)
create or replace function getSum
(
   pn number
)
return number
is
  vi number ;
  vsum number := 0;
begin
   -- loop
   vi := 1;
   /*
   loop
     vsum := vsum + vi;
     vi := vi+1;
   exit when  vi > pn;
   end loop;
   */
   
   -- while
   /*
   while pn>=vi
   loop
     vsum := vsum + vi;
     vi := vi+1;
   end loop;
   */
   -- for
   for vi in 1.. pn 
   loop
     vsum := vsum + vi;
   end loop;
   return vsum;
-- exception
end;

-- 테스트
select getSum(10)
from dual;

-- 주민번호를 매개변수로 입력받아서 나이 계산해서 반환하는 getAge 함수

-- months_between 함수
--  올해년도 - 생일년도+1
create or replace function getAge
(
   pssn insa.ssn%type
)
return number
is
  vgender varchar2(2); -- 8,1
  vcentury number(4);  -- 91
  vage number(3) := 0;
  vcurryear number(4);
  vbirthyear number(4);
begin
   vcurryear := to_char( sysdate, 'YYYY'); -- 2018
   vgender := substr(pssn,8,1);  -- 1
   
   case 
     when vgender in (1,2,5,6) then vcentury := 1900;
     when vgender in (3,4,7,8) then vcentury := 2000;
     when vgender in (0,9) then vcentury := 1800;
   end case;
   
   vbirthyear := vcentury + substr(pssn, 1,2); -- 1991
   vage := vcurryear - vbirthyear + 1;
   -- 만 나이는 2018(올해년도)- 1990(생일년도)  -1( 생일안지남)  수정
   return vage;
-- exception
end;

-- 테스트
select name, ssn, getAge(ssn) 
from insa;
-- ssn -> '1991년 12월 31일' getBirth , 'YYYY/MM/DD'
create or replace function getBirth
(
   pssn varchar2
)
return date
is
  vbirth varchar2(8); -- '19' || '911009'
  vgender varchar2(2); -- 8,1
  vcentury varchar2(2);  -- 91
  
  vresult date;
begin
   vgender := substr(pssn,8,1);  -- [1]
   
   case 
     when vgender in (1,2,5,6) then vcentury := '19';
     when vgender in (3,4,7,8) then vcentury := '20';
     when vgender in (0,9) then vcentury := '18';
   end case;
   -- '19911009'
   vbirth := vcentury || substr( pssn, 1, 6);
   vresult := to_date( vbirth, 'YYYYMMDD');
   
   return vresult;
-- exception  
end;
--
select name, ssn, getBirth( ssn )
    , to_char( getBirth( ssn ), 'YYYY"년"MM"월"DD"일"' )  a
    , to_char( getBirth( ssn ), 'YYYY-MM-DD' )  b
from insa;

-- 커서( cursor ) p 342
-- 1) 커서 정의 2) 커서 사용 3) 커서 종류 4) 커서 생-사 형식
declare
  vemprow emp%rowtype;
begin
  select *
        into vemprow
     -- into vemprow.empno, vemprow.ename
  from emp
  where empno = 7369;
  
  dbms_output.put_line( vemprow.empno || ' ' ||
  vemprow.ename || ' ' ||
  vemprow.sal || ' ' ||
  vemprow.hiredate
   );
-- exception
end;


-- 
declare
  vemprow emp%rowtype;
begin
  select *
        into vemprow 
  from emp;
  
  dbms_output.put_line( vemprow.empno || ' ' ||
  vemprow.ename || ' ' ||
  vemprow.sal || ' ' ||
  vemprow.hiredate
   );
-- exception
end;

-- 위의 여러 행(rows) 처리하기 위해 커서... ( 묵시적커서 )
declare
  -- vemprow emp%rowtype;
begin
  for vemprow in (select * from emp)
  loop
    dbms_output.put_line( vemprow.empno || ' ' ||
    vemprow.ename || ' ' ||
    vemprow.sal || ' ' ||
    vemprow.hiredate
     );
  end loop;
-- exception
end;

-- 명시적 커서 사용.. 
declare
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
-- up_emplist 저장 프로시저
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

-- up_emplist 프로시저 수정 : deptno 부서번호 매개변수
create or replace procedure up_emplist_deptno
(
   pdeptno emp.deptno%type
)
is
  vemprow emp%rowtype;
  cursor emp_list  is
                    select * from emp
                     where deptno = pdeptno;
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
exec up_emplist_deptno( 30 );

-- [ 커서 파라미터를 이용하는 방법 ]
create or replace procedure up_emplist_deptno
(
   pdeptno emp.deptno%type
)
is
  vemprow emp%rowtype;
  cursor emp_list(p_pdeptno emp.deptno%type)
  is
     select * from emp   where deptno = p_pdeptno;
begin
  -- 커서의 매개변수 
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


-- *** SYS_REFCURSOR / REF CURSORS ***
-- 트리거( trigger )
-- 패키지( package )
-- 암호화( )



  
