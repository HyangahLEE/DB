--2018-07-02 (��)

--������ ( SEQUENCE )
--�����ġ�
--	CREATE SEQUENCE ��������
--	[ INCREMENT BY ����] --����ġ 1
--	[ START WITH ����] --�󸶺��� �����ҰŴ�
--	[ MAXVALUE n ? NOMAXVALUE] --������ �ִ밪
--	[ MINVALUE n ? NOMINVALUE] --������ �ּҰ�
--	[ CYCLE ? NOCYCLE] --
--	[ CACHE n ? NOCACHE]; --ĳ�� �������� �̹� 20 �� ������ ���� (��ٸ��� �ʰ� ������ ó�� )

CREATE SEQUENCE seq1;
CREATE SEQUENCE seq2
increment by 1
start with 1;

select * from dept;
create sequence seq_deptno
increment by 10
start with 50;

--������ ��� Ȯ��
select * from seq; --user_sequence

--*�̹� ����� �������� �ǵ����� ���� (��ȣ �ǵ����� ����)
--seq_deptno.nextval ��������� ���⶧���� ���� (�ּ��� �ѹ��� ����� nextval�� �����ȴ�.)
--(����)ORA-08002: sequence SEQ_DEPTNO.CURRVAL is not yet defined in this session
select seq_deptno.currval
from dual;
--dept ���̺� seq_Deptno ������ ��� �μ� insert
insert into dept (deptno, dname, loc) values (seq_deptno.nextval,'�����','����');
insert into dept (deptno, dname, loc) values (seq_deptno.nextval,'������','����');
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
  
  --[�۾��� ����]
  insert into cstVSBoard  (seq,writer,pwd,email,title,ismode,content) 
  values (SEQ_CSTVSBOARD.NEXTVAL,'�����','1234',null,'ù �Խñ�','y','���� ����!!');
   insert into cstVSBoard  (seq,writer,pwd,email,title,ismode,content) 
  values (SEQ_CSTVSBOARD.NEXTVAL,'�����','1234',null,'10 �Խñ�','y','���� ����!!');
    commit;
  select *
  from cstVSBoard;

 --[�۸��]
 select seq,writer, email,title, writedate, readed
 from cstVSBoard
 order by seq desc;

--��. �� ������ �� � �Խñ�? 3
--��. �� ������ �� ? 11/3


--��. [1],2,3,4
--��. ������ ������ ��ȣ ���
select seq,writer,email,title, writedate,readed
from(
 select rank() over(order by seq desc) no,seq,writer, email,title, writedate, readed
 from cstVSBoard
 )
 where no between 3*(:pn-1)+1 and 3*(:pn-1)+3;

--[�ۺ���]
--> Ʈ����� ó�� �ʿ� 1)2)
--1)��ȸ�� ����
update CSTVSBOARD
set readed = readed +1
where seq = :seq;
commit;

--2) seq �ش� �Խñ� select
select seq,readed, writer, title, content, writedate
from CSTVSBOARD
where seq = :seq;

--�۸�� -> �ۺ��� ( ���, ����, ���� )
-- 1) ���� ���� Ȯ��?
select pwd
from cstvsboard
where seq=:seq;
--pwd=:pwd
select count(*)
from cstvsboard
where seq = 4 and pwd = :pwd;
-- 2) ���� �Խñ� ���� 
delete from cstvsboard
where seq= :seq;
commit;

-- ����
--1) ������ ������ �ִ��� Ȯ��
--2) ������ seq �Խñ� select  -> ȭ�����
Update  cstvsboard
set title = :title, content = :content, email = :email
where seq = :seq;
commit;

-- �˻�
select seq,writer,email,title, writedate,readed
from(
 select rank() over(order by seq desc) no,seq,writer, email,title, writedate, readed
 from cstVSBoard
 --where writer like '%:writer%' 
 --where title like '%:title%'
 
 -- where title like '%��%' and content like '%��%'
 )
 where no between 3*(:pn-1)+1 and 3*(:pn-1)+3;
 
--PL/SQL
--SQL + PL = PL/SQL ( ����Ŭ )

--[declare]
--    1 block ���� �κ� ( ����, ��� , Ŀ��(cursor) ����)
--      a ����;
--      b ���;
--      c Ŀ��;
--begin
--    2 block ���� �κ� ( sql���� - s,i,u,d �� )
--      insert~;
--      update~;
--
--[exception]
--    3 block - ����ó���κ�
--end
--; ���ݺ��� pl/sql ������ ���� �κ� �����ؼ� ����

declare
    --����
    vnum number;
    vname varchar2(20);
    --���
    pi constant number(5,3) := 3.14;
begin
    --����Ŭ �� ���Կ����� ? :=  =
    --�ڹ�                =   ==
    vnum := 100;
    vname := 'ȫ�浿';
    -- ���� ���
    dbms_output.put_line( '> num =' || vnum);
--exception
end;
--�͸� ���ν���
declare
    --vename varchar2(10);
    --vsal number(7,2); --�ڷ��� ���ų� Ŀ���Ѵ�.!!!!
    
    --%type ���� ����
    -->���̺��� ������ ���� ����Ǵ���� pl/sql ���� xx
    vename emp.ename%type;
    vsal emp.sal%type;
begin
    select ename, sal
        into vename, vsal
       -- into ���� : select, fetch���� ���Ǵ� ��
    from emp
    where empno = 7369;
    
    dbms_output.put_line('> ename : '|| vename ||' , '|| '> sal : ' || vsal);
--exception
end;

--ORA-01422: exact fetch returns more than requested number of rows
--pl/sql �ȿ��� ���� ���� ���� ó���� ���� Ŀ�� ���.
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

--> [%rowtype�� ���� ����]
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

--[PL/SQL ���]

--IF [(���ǽ�)] THEN
--END IF;

DECLARe
    vkor number(3):=0;
    vRESULT varchar2(10):='��';
begin 
    --�����
    select kor 
        into vkor
    from score
    where num =1002;
    --
    if(vkor>=90) then DBMS_OUTPUT.PUT_LINE('��');
    elsif (vkor>=80 and vkor<90) then DBMS_OUTPUT.PUT_LINE('��');
    elsif (vkor>=70 and vkor<80) then DBMS_OUTPUT.PUT_LINE('��');
    elsif (vkor>=60 and vkor<70) then DBMS_OUTPUT.PUT_LINE('��');
    else DBMS_OUTPUT.PUT_LINE('��');
    
    end if;
end;