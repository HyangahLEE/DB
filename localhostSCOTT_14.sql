--2018.07.05 (��)

select * from user_sequences;
create sequence seq_dept
increment by 10
start with 50;

--1.dept ���̺� deptno, dname, loc


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

execute up_insertDept('������','����');

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
   -- danme ���̸� ���� �߻�... ������ deptno ����..
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
execute up_updateDept(60,ploc=>'����');


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

-- ���ν��� Ȯ��
exec up_selectDept(10);
exec up_selectDept;

--
create or replace procedure up_test
(
   pa in number      -- �Է¿�
   , pb in number    -- �Է¿� �Ķ����
   , pc out number   -- ��¿� �Ķ����
)
is
begin
   pc   :=   pa + pb ;  -- c �Ķ���� 1234 ���� �Ҵ�(����)
-- exception
end;

-- variable / print Ű����?
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

 -- ȸ�� ������ ��
-- ���̵�   [ kenik ] [��뿩�ι�ư]
-- kenik -> �����̺�   id  

-- ���̵� �ߺ� üũ�ϴ� ���ν��� : up_idCheck
-- pempno    in   kenik
-- pempnoCheck out  1, 0
-- emp ���̺�        empno

var vempnoCheck number;
begin
    up_empnoCheck( 7369 , :vempnoCheck );
    
    if :vempnoCheck=1 then
        DBMS_OUTPUT.PUT_LINE('��� �Ұ��� �մϴ�.');
    else
        DBMS_OUTPUT.PUT_LINE('��� �����մϴ�.');
    end if;
end;
--exec up_empnoCheck( 7369 , :vempnoCheck );  -- 0
--exec up_empnoCheck( 7777 , :vempnoCheck );  -- 1
print empnoCheck;  

-- [ �α��� ] ����
--id
--password
--[�α���]
-- 1)id �������� ���� ���      
-- 2)id ���������� password�� ���� �������
-- 3)id/password ���� -> �α��μ���

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
 vid number(1); --�����ϸ� 1 �ƴϸ� 0
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
     dbms_output.put_line('ID(empno)�� �������� �ʽ��ϴ�.');
  elsif :vresult = 0  then
    dbms_output.put_line('PWD(ename)�� Ʋ�Ƚ��ϴ�.');
  elsif :vresult = 1  then
     dbms_output.put_line('�α��� ����.');
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

-- 2. ���� ���� �� �� �ִ� ����
variable phone_num varchar2(15);
begin 
    :phone_num := '1234-121212';
END;
print phone_num;
execute add_one(:phone_num);
-------------------------------
-->> ���̺� 2�� ����
--mem1<���̵�/��й�ȣ/�̸�>

CREATE TABLE mem1 (
	id VARCHAR2(20) 
    ,pwd VARCHAR2(20) NOT NULL
    ,name VARCHAR2(20) NOT NULL
    ,CONSTRAINT pk_mem1_id PRIMARY KEY(id)
);

--mem2<���̵�/����ó/����>
CREATE TABLE mem2 (
	id VARCHAR2(20)--�ĺ������� pfk
    ,tel VARCHAR2(20)
    ,birth DATE
    ,CONSTRAINT pk_mem2_id PRIMARY KEY(id)
    ,CONSTRAINT fk_mem2_id FOREIGN KEY (id) REFERENCES mem1(id)
);
----------
-->> ���ν��� ���� (insMem)
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

EXECUTE insMem('11', '11', 'ȫ�浿', '111-111-111', '2000-10-10');
EXECUTE insMem('22', '22', '��浿', '111-222-111', NULL);
EXECUTE insMem('33', '33', '�ڱ浿', NULL, '2000-08-08');
EXECUTE insMem('44', '44', '�ֱ浿', null, null);

SELECT * FROM mem1;
SELECT * FROM mem2;
--
select *
from user_procedures;


---------------
-- stored Function( ���� �Լ� )
-- ������ ? ���ϰ�
--create or replace function �Լ���
--(
--)
--return �ڷ���;
--is
--begin 
--    return(���ϰ�)
--end;

--insa ���̺� num, name, ssn
select num,name, ssn
        ,decode( mod( substr(ssn,8,1) ,2),0,'��','��') as gender
from insa;
--�ֹι�ȣ -> ���� ���� �����Լ� ���� ->���
-- �����Լ� : select ��, ���ν���
select num, name, ssn, getGender(ssn)
from insa;
--
create or replace function getGender
(
 pssn insa.ssn%type
)
return varchar2
is 
    vgender varchar2(6) :='����';
begin
    if mod( substr(pssn,8,1),2)=1 
    then vgender :='����';
    end if;
    return vgender;
end;

select getGender('950211-1111111')
from dual;

grant select on insa to hr;

-- Ŀ�� ( cursor )
-- 1)Ŀ�� ���� 2)Ŀ�� ��� 3)Ŀ�� ���� 4) Ŀ�� ��-�� ����


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

--> ����� Ŀ�� 

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
--up_emplist ���� ���ν���
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

-- �׽�Ʈ
exec up_emplist;

--up_emplist ���ν��� ���� : deptno �μ���ȣ �Ű�����
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

--�׽�Ʈ
exec up_emplist_dept(30);

--> Ŀ���� �Ķ���͸� �̿��ϴ� ���
create or replace procedure up_emplist_dept
(
    pdeptno emp.deptno%type
)
is
  vemprow emp%rowtype;
  cursor emp_list(p_pdeptno emp.deptno%type)
     is select * from emp where deptno = p_pdeptno;
begin
    --Ŀ���� �Ű�����
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
