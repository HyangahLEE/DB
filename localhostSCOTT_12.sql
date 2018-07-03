--2017.07.03 (ȭ)
--PL/SQL : ���(3��) ���� ���
DECLARE
    -- 1. ����� : ���� , ���, Ŀ�� ���
    vmaxsal emp.sal%type;
    vemprow emp%rowtype;
BEGIN
    -- 2. �����
    --    :=  INTO select/fetch(cursor)��������
     SELECT MAX(SAL)
        into vmaxsal
     FROM EMP;
     
     select *
        into vemprow
     from emp
     where sal = vmaxsal;
     dbms_output.put_line('> deptno : ' || vemprow.deptno );
     dbms_output.put_line('> empno : ' || vemprow.empno );
     dbms_output.put_line('> ename : ' || vemprow.ename );
     dbms_output.put_line('> sal : ' || vemprow.sal );
  
    -- dbms_output.put_line('> max(sal) : '|| vmaxsal);
END;


declare
  vgrade salgrade.grade%type;
  vsal  emp.sal%type;
begin
   select (sal)   into vsal  
   from emp 
   where empno = 7369;
   
   case 
     when vsal  between 700 and 1200   then vgrade := 1;
     when (vsal between 1201 and 1400) then vgrade := 2;
     when (vsal between 1401 and 2000) then vgrade := 3;
     when (vsal between 2001 and 3000) then vgrade := 4;
   end case;
   
   /*
   if (vsal between 700 and 1200) then
     vgrade := 1;
   elsif (vsal between 1201 and 1400) then
     vgrade := 2;
   elsif (vsal between 1401 and 2000) then
     vgrade := 3;
   elsif (vsal between 2001 and 3000) then
     vgrade := 4;
   end if;
   */
  dbms_output.put_line('> 7369�� sal : ' || vsal );
  dbms_output.put_line('> 7369�� grade : ' || vgrade );
-- exception
end;

--> ������ �Է¹޾Ƽ� Ȧ/¦�� ���.
DECLARE
    vn number(3,0);
    vresult varchar(6) :='Ȧ��';
BEGIN
    vn := :n;
    if mod(vn,2)=0 then vresult := '¦��';
    end if;
    dbms_output.put_line( vn|| ' : ' || vresult );
END;

--p277 case��
-- select ������ case ǥ������ ����ߵ��� pl/sql �ȿ��� case���� ��� �� �� �ִ�. 
-->dbms_random ��Ű��
        
select  dbms_random.string('u',5) --a>���ĺ� ��ҹ��ڱ��� ����, u >�빮�ڷ��� , ��> �ҹ��ڷ��� 
        , dbms_random.value --0.0 <= �Ǽ� < 1
        , dbms_random.value(1,45) --1.0 <= �Ǽ� < 45
from dual;

declare
    vn_sal number :=0;
    vn_deptno number :=0;
begin 
    vn_deptno := round(dbms_random.value (10,120),-1);
    
    select rownum,sal
        into vn_sal
    from emp
    where deptno= vn_deptno and rownum=1 ;
    dbms_output.put_line(vn_sal);
    
    case when vn_sal between 1 and 3000 then  dbms_output.put_line('����');
        when vn_sal between 3001 and 6000 then  dbms_output.put_line('�߰�');
        when vn_sal between 6001 and 10000 then  dbms_output.put_line('����');
        else dbms_output.put_line('�ֻ���');
    end case;
end;

--[�ݺ���] : Loop, While, For
--loop
--    --�ݺ� ó�� ����
--    exit [when ����];
--end loop;
----
--while ���ǽ�
--loop
--    --�ݺ� ó�� ����
--end loop
--for i�ݺ����� in [reversre] �ʱ��..������
--loop
    --ó����
--end loop;

-------------------

DEClare
vn_base_num number := :num;
vn_cnt number :=1;
begin 
loop 
    dbms_output.put_line(vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt +1;
    
    exit when vn_cnt >9;
end loop;
end;
-- 
DEClare
vn_base_num number := :num;
vn_cnt number :=1;
begin 
while  vn_cnt <=9
loop 
    dbms_output.put_line(vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt +1;
    
end loop;
end;

--> ��) 1~n������ �� ���
DEClare
vsum number := 0;
vi number :=1;
vn number := :num;
begin 
loop 
    if vi != vn then 
    dbms_output.put( vi || ' + ' );
    else
    dbms_output.put( vi || ' = ' );
    end if;
    vsum := vsum +vi;
    vi := vi+1;
    exit when vi>vn;
end loop;
 dbms_output.put_line(  vsum );
end;
--
DEClare
    vsum number := 0;
    vi number :=1;
    vn number := :num;
begin 
while vi<vn
loop 
    if vi != vn then 
    dbms_output.put( vi || ' + ' );
    else
    dbms_output.put( vi || ' = ' );
    end if;
    vsum := vsum +vi;
    vi := vi+1;
    exit when vi>vn;
   end loop;
    dbms_output.put_line(  vsum );
end;
--
DEClare
    vsum number := 0;
    vi number :=1;
    vn number := :num;
begin
for vi in 1.. vn
loop
if vi != vn then 
    dbms_output.put( vi || ' + ' );
    else
    dbms_output.put( vi || ' = ' );
    end if;
    vsum := vsum +vi;
   
end loop;
dbms_output.put_line(  vsum );
end;
--
DEClare
vn_base_num number := :num;
vn_cnt number :=1;
begin
for vn_cnt in 1.. 9
loop
dbms_output.put_line(vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
end loop;
end;

--���� 2�ܿ��� 9�ܱ��� ���
declare
 --   vi number :=2;
  --  vj number :=1;
begin
    for vi in 2..9
    loop
        for vj in 1..9
         loop
            dbms_output.put(vi || '*' ||vj || '= ' || rpad(vi * vj,3,' '));
         end loop;
         dbms_output.put_line(' ');
    end loop;
end;
--***for���� ���Ǵ� �ݺ������� ���������ʾƵ� �ȴ�.

begin
    for vj in 1..9
    loop
        for vi in 2..9
         loop
            dbms_output.put(vi || '*' ||vj || '= ' || rpad(vi * vj,3,' '));
         end loop;
         dbms_output.put_line(' ');
    end loop;
end;

--> emp���̺��� deptno= 10����� ������ ��ȸ(���)
declare
   -- vemprow emp%rowtype;
begin
    --1. �ڵ�(�Ͻ���)���� Ŀ�� ���� 
    --2. �ڵ� open 
    for vemprow in (select *  from emp  where deptno =10)
    loop
        --3. �ݺ������� FETCH
     DBMS_OUTPUT.PUT_LINE(vemprow.empno || vemprow.ename);
     end loop;  
     
     --4. �ڵ� close
end;


declare
 --   vi number :=2;
  --  vj number :=1;
begin
    for vi in 2..9
    loop
        for vj in 1..9
         loop
         if i=2 then goto xxx; end if;
            dbms_output.put(vi || '*' ||vj || '= ' || rpad(vi * vj,3,' '));
         end loop;
         <<xxx>>
         dbms_output.put_line(' ');
    end loop;
end;


select *
from cstvsboard;
--���� �׽�Ʈ 100������ ���ڵ�(�Խñ�) �߰�..
declare
begin
  for i in 1.. 1000
  loop
    insert into cstVSBoard
      (seq, writer, pwd,email,title
      ,ismode,content) 
    values
      (seq_cstVSBoard.nextval
      , dbms_random.string('U',5) 
      ,'1234',null
      , '�ݺ� -' || i || ' ��° �Խñ�','y','pl/sql �ݺ�ó��'); 
  end loop;
  commit;
-- exception
end;

--[���ڵ庯��]
--�����ġ� 
--    TYPE [type��] IS RECORD 
--      ( field_name1  datatype [[NOT NULL] { := ? DEFAULT} expr] 
--        field_name2  datatype [[NOT NULL] { := ? DEFAULT} expr] 
--       .................. 
--      );
--    record��   type��;
 
--�����á�
  DECLARE 
  --��������
  --recode �ڷ��� ����
   type empdept_type IS RECORD
   (empno emp.empno%type,
   ename emp.ename%type,
   hiredate emp.hiredate%type,
    dname	VARCHAR2(13),
    loc		VARCHAR2(14));
    --���� ���ο� ���ڵ��� �ڷ������� ��������
   vedRow  empdept_type;
  BEGIN
   select empno,ename, hiredate, dname, loc
        into vedRow
   from emp e join dept d on e.deptno = d.deptno
   where e.empno =7369;
   
  dbms_output.put_line(' ');
  

  END;


--p342 Ŀ��(cursor)
--1. Ŀ�� ? sql������ ó���� ����� ��� �ִ� �޸� ������ ����Ű�� ������ �������̴�.
--2. Ŀ�� ���� : ������(�Ͻ���,�ڵ�) Ŀ��, �����(����)Ŀ��
--3. Ŀ�� ó�� ���� : Ŀ�� ���� > open > �ݺ��� fetch > close
--4. Ŀ�� ��� ��) insert, update, delete �Ͻ��� Ŀ��..
begin
    update emp
    set ename= 'admin';
    
    DBMS_OUTPUT.PUT_LINE(sql%rowcount);
end;

--��� : 12

--������ Ŀ��
begin
 for vrec in (select deptno, ename, sal, hiredate from emp)
    loop
    DBMS_OUTPUT.PUT_LINE( vrec.deptno ||' '|| vrec.ename||' ' || vrec.hiredate);
    end loop;
end;
--����� Ŀ��
declare
    --1.Ŀ�� ����
    cursor emp_cursor is (select deptno, ename, sal, hiredate from emp);
begin
    --2. open
   -- open emp_cursor;
    --3. �ݺ���fetch --for���� ���� open $ close �ڵ�
    for vrec in emp_cursor
    loop
    DBMS_OUTPUT.PUT_LINE( vrec.deptno ||' '|| vrec.ename||' ' || vrec.hiredate);
    end loop; 
    --4. close
   -- close emp_cursor;
end;
--
--����� Ŀ�� ���� 2
declare
    vdeptno emp.deptno%type; 
    vename emp.ename%type; 
    vsal emp.sal%type;
    vhiredate emp.hiredate%type;
    cursor emp_cursor is (select deptno, ename, sal, hiredate from emp);
begin
    open emp_cursor;
    loop
    fetch emp_cursor into vdeptno, vename, vsal, vhiredate;
    DBMS_OUTPUT.PUT_LINE( vdeptno ||' '|| vename||' ' || vhiredate);
   -- exit when emp_cursor%notfound;
    exit when emp_cursor%rowcount >= 5;
    end loop;
    close emp_cursor;
end;
--
-- ����� Ŀ�� + ���ڵ�Ÿ�� 
declare
    type empxxx is record
    (
    deptno emp.deptno%type; 
    ename emp.ename%type; 
    sal emp.sal%type;
    hiredate emp.hiredate%type;
    );
    
    vrec empxxx;
begin
    open emp_cursor;
    loop
    fetch emp_cursor into vrec;
    exit when emp_cursor%notfound;
    DBMS_OUTPUT.PUT_LINE(  vrec.deptno ||' '|| vrec.vename||' ' || vrec.vhiredate);
    end loop;
    close emp_cursor;
end;



-- ***** �𵨸� ***** --
1. DB ( DATABASE ) ? ���õ� ������ ����.
2. DBMS ? Oracle
3. ��Ű�� ( Schema ) : scott ���� scott��Ű��.DB��ü
    DB�� ���� ( ��ü, �Ӽ�, ���� )�� ���� ���ǿ� ���� ���� ��� �� ��.
    1)�ܺ� 2)���� 3)���ν�Ű��
4. DBA : DB������ SYS> SYSTEM
5. DB �ý��� = DB + DBMS(oracle)+ �������α׷�
6. DB �𵨸�( MODELING ) ?
    -> ���� ���迡 �����ϴ� �������� ���μ����� �ľ��ؼ� 
       ���������� �����ͺ��̽�ȭ ��Ű�� ����.
       EX) ���θ� ���� : ���� ���μ��� �ľ� 
       1) DB Modeling ����(����)
       ��. ���� �ľ� ( �䱸�м� )
        -> �䱸���� ���� ����
       ��. ������ DB�𵨸� : ��ü(��ü)+ �Ӽ� �ľ� > ERD 
       ��. ���� DB�𵨸� : 
            ERD > ���η� ( mapping rule )�� ���� ��Ű�� ����
                  ����ȭ ( �� 1����ȭ~�� 5����ȭ )
                  -- DBMS ���� --
       ��. ������ DB�𵨸�
            - �÷� datatype, sizs���� ( number int )
            - ���� ����� ���� �ε���, ������ȭ ...�۾�
            
-- ER -Win
1. ���� ���μ��� �ľ� ( �䱸, �м� ) -> [ �䱸 �м� ���� �ۼ� ]
    ��. ���� ���� �о߿� ���� ���İ� ���
    ��. ���� ��� ���� + ���� ���μ��� �ľ�. �м�
    ��. ����, ��ǥ, ���� ��� ���� ������ �̿��ؼ� �����ľ�.
    ��. �ǹ��� ����
    ��. ��׶��� ���μ��� �ľ�.
    ��. ����� �䱸 �м�.
       
2. ������ DB �𵨸�
    -- ���� ���� ������ �� �� ��Ȯ�� ǥ���ϴ� ���. ( ������ )
    -- [E]ntity - [R]elation - [D]iagram