-- 2018. 07. 11.(��) 18����

-- p432 ~ p452 ���� SQL

-- �͸� ���ν���
--1.
declare
    vsql varchar2(1000);
begin
    vsql := 'select deptno, empno, ename, job ';
    vsql := vsql ||' from emp ';
    vsql := vsql || ' where empno = 7369 ';
    
    execute immediate vsql; -- �������� ���� (NDS)
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
    
    execute immediate vsql -- �������� ���� (NDS)
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
    
    execute immediate vsql -- �������� ���� (NDS)
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
    
    execute immediate vsql -- �������� ���� (NDS)
    into vdeptno, vempno, vename, vjob;
    dbms_output.put_line( vdeptno || ' ' || vempno || ' ' || vename ||' ' || vjob) ;   
    
end;
--5. ���� sql�� dml��� 
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
    vsql :='insert into dept ';--���� ��!!!�ٿ��ֱ�
    vsql := vsql || ' values (:a, :b, :c)';
    
    execute immediate vsql
        using vdeptno,pdname, ploc;
end;

exec up_insert_dept('������','����');
select * from dept;
rollback;

--p 447 open for�� ****
--select ����sql�� ����� ��������...ó��?  open for�� ���

--Ŀ�������� ����ϴ� ��� 2����
--��. ref cursor
--��. sys_refcursor  
--open Ŀ������ for ����sql
--using �Ű����� ...;


--6.
declare
    --Ŀ������ 1) ref cursor ���
    --��. Ŀ�� Ÿ�� ����
    type query_physicist is ref cursor;
    --��. Ŀ�� ���� ����
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
    
    --���� sql ��� Ȯ��
    loop
    fetch vcursor into vrow;
    exit when vcursor%notfound;
    dbms_output.put_line( vrow.deptno || ' ' || vrow.empno || ' ' || vrow.ename ||' ' || vrow.job) ; 
    end loop;
    close vcursor;
end;

--7
declare
    --Ŀ������  sys_refcursor ���
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
-- �����ϰ� 5�� writer �÷� admin ���� ����.
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
-- �� where �������� �������� �ٲ�� ���
-- ( �̸�, ����, ����+���� ���� �˻� )
create or replace procedure up_search_cstvsboard
(
  psearchCondition number,
  psearchWord varchar2
)
is
-- ��. Ŀ�� ���� ���� 
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
  
  -- ������ ���⼭ ����ؼ� Ȯ��
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
-- �׽�Ʈ
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


-- ��Ű�� ��ü
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