--2018-07-09 (월)
--p306 예외 처리
--PL/SQL 코드 작성시 발생하는 오류 
-- 1) 문법 오류 
-- 2) 예외( EXCEPTION )
--         ㄱ. 시스템 예외
--         ㄴ. 사용자 정의 예외
-- 3) 예외 선언 형식(구문)
--DECLARE
--BEGIN
--    실행부분
--EXCEPTION
--    WHEN 예외객체 THEN
--    WHEN 예외객체 THEN
--            OTHERS 제일 마지막..
--END;
-- 4) 예외처리
DECLARE
    VN number :=0;
begin
    vn := 10/0;
    DBMS_OUTPUT.put_line('success!!');
end;
--ORA-01476: divisor is equal to zero

DECLARE
    VN number :=0;
begin
    vn := 10/0;
    DBMS_OUTPUT.put_line('success!!');
exception 
    WHEN ZERO_DIVIDE 
    THEN DBMS_OUTPUT.put_line('나눔 오류!!');  
        DBMS_OUTPUT.put_line(SQLCODE);     
        DBMS_OUTPUT.put_line(SQLERRM); 
        -- 몇버ㅗㄴ째 라인에 에러가 발생했는지..
         DBMS_OUTPUT.put_line(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); 
    when others then DBMS_OUTPUT.put_line('ERROR!!');
end;

create or replace procedure up_p313
(
 pdeptno dept.deptno%type
)
is 
    vcnt number :=0;
begin
 select count(*)
    into vcnt
 from emp
 where deptno = pdeptno;
 if vcnt = 0 then  DBMS_OUTPUT.put_line('사원이 존재하지 않습니다.');
 return;
 else DBMS_OUTPUT.put_line('> 사원명 : '|| vcnt);
 end if;
 DBMS_OUTPUT.put_line('---end---');
end;

-- p315 사용자 정의 예외

create or replace procedure up_p313
(
 pdeptno dept.deptno%type
)
is 
    vcnt number :=0;
    ex_no_deptno exception;
begin
 select count(*)
    into vcnt
 from emp
 where deptno = pdeptno;
 if vcnt = 0 
 --사용자 정의예외 발생
 then ex_no_deptno;
 return;
 else DBMS_OUTPUT.put_line('> 사원명 : '|| vcnt);
 end if;
 DBMS_OUTPUT.put_line('---end---');
exception
    when ex_no_deptno 
    then DBMS_OUTPUT.put_line('사원이 존재하지 않습니다.');
    when others 
    then DBMS_OUTPUT.put_line('기타예외발생!');
end;

---
CREATE OR REPLACE PROCEDURE up_test100
(psal IN emp.sal%TYPE)
IS
  vename  emp.ename%TYPE;
BEGIN
  SELECT ename 
    INTO vename 
  FROM emp 
  WHERE sal=psal;
  dbms_output.put_line('He id '|| vename ||'!!!!');
EXCEPTION
  WHEN no_data_found THEN
   raise_application_error(-20002,'Data not found....');

  WHEN too_many_rows THEN
   raise_application_error(-20003,'Too Many Rows....');

  WHEN others THEN
   raise_application_error(-20004,'Others Error....');

END;
--Procedure UP_TEST100이(가) 컴파일되었습니다.

execute up_test100(9000);

--
create or replace procedure hire_emp
(v_emp_name     IN emp.ename%type,
 v_emp_job      IN emp.job%type,
 v_mgr_no       IN emp.mgr%type,
 v_emp_hiredate IN emp.hiredate%TYPE,
 v_emp_sal      IN emp.sal%type,
 v_emp_comm     IN emp.comm%type,
 v_dept_no      IN emp.deptno%type)
IS
 e_invalid_mgr exception;

pragma exception_init (e_invalid_mgr, -02291);

BEGIN
  INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm,deptno)
   values(emp_id.nextval, v_emp_name, v_emp_job,v_mgr_no, v_emp_hiredate,
          v_emp_sal, v_emp_comm, v_dept_no);
  commit work;
  exception
   when e_invalid_mgr then
    raise_application_error(-20201, 'Deptno is not a valid department.');
end hire_emp;

-->
execute hire_emp('STONE','CLERK',9000, SYSDATE, 950, 300,44);
