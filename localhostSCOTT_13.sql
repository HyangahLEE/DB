-- 2018.07.04(��) : SCOTT
-- ���̹� �˻� : ���� �̻�
-- "���� �̻� �����ͺ��̽� ���� ���/���� > ��ǻ��/���/IT"  - Ŭ��
-- ������ ��ũ�� �� "����ȭ�� ����" Ŭ��
select *
from tabs
where table_name like 'SA%';
select * from sample;
-- ���    �μ�
select *
from emp, dept
where emp.deptno = dept.deptno;
--
update emp
set dname = 'sales'
where empno=7369;

-- ���� �𵨸�..
-- ���� PL/SQL ���ν���...
create or replace procedure up_���ν�����
(
   argument [(in) �Է¿�,out ��¿�,in out����¿�] datatype,  
   argument [(in) �Է¿�,out ��¿�,in out����¿�] datatype,
   argument [(in) �Է¿�,out ��¿�,in out����¿�] datatype
)
is[as]  -- declare �͸� ���ν���
  -- ����,���,Ŀ�� �� �����    ;
begin
exception
end;
--
drop procedure �������ν�����;

-- num, name, kor, eng, mat, tot, savg, res
desc score;
--
select * from score;
-- insert into score �˻�...
create or replace procedure up_insertScore
is
begin
  insert into score (num, name, kor, eng, mat, tot, savg, res)
  values (1007,'�����',98,78,66, 242,80.67, '�հ�' );
  commit;
-- exception
end;
-- Procedure UP_INSERTSCORE��(��) �����ϵǾ����ϴ�.
-- Procedure UP_INSERTSCORE ���� ���ν��� ����..
--  1) execute ������ ����.
execute UP_INSERTSCORE;
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

--  2) �͸����ν��� �ȿ��� ����
begin
  UP_INSERTSCORE;
end;

select *
from user_constraints
where table_name like 'SCO%';
-- 1007 num �л� ���� ����
delete from score where num = 1007; 
commit;
-- pk_score_num pk ���� ���� �߰�..
alter table score
   add ( constraint pk_score_num primary key(num) );
--
--  3) �ٸ� ���� ���ν��� �ȿ��� ����
select * 
from score;
-- �Է� ������ ��,��,��,��,�� �Է�.....
create or replace procedure up_insertScore
(
   pnum in number   -- ���μ����� ���� datatype ����  size X
   , pname in varchar2 
   , pkor in score.kor%type :=0
   , peng in number :=0 
   , pmat in number :=0
)
is
  -- ����,���,Ŀ�� ��� �����
  vtot number(3) := 0;  -- �����ݷ�
  vsavg number(5,2);
  vres varchar2(20) := '�հ�';
begin
  vtot := pkor + peng + pmat;
  vsavg := vtot / 3 ;
  -- vres ��,��,����
  -- if �� / case ��
  case
      when (vsavg < 60) then  vres :='���հ�'; 
      when (pkor <40 or peng < 40 or (pmat) < 40 ) then  vres :='����'; 
      else vres :='�հ�'; 
  end case ;

  insert into score (num, name, kor, eng, mat, tot, savg, res)
  values (pnum,pname,pkor,peng,pmat, vtot,vsavg, vres );
  commit;
-- exception
end;
-- Procedure UP_INSERTSCORE��(��) �����ϵǾ����ϴ�
desc score;
--
execute UP_INSERTSCORE(1008,'�赿��',89,77,94);
exec    UP_INSERTSCORE(1009,'���ʱ�',23,98,76);
exec    UP_INSERTSCORE(1010,'���ʱ�');
exec    UP_INSERTSCORE(1011,'������',pmat=>50);
--
select * from score;
-- score ���̺� rk �÷� �߰�
alter table score
add ( rk number );
--
select * from score;
-- execute up_makeRank;
create or replace procedure up_makeRank
is
  vrank number;
begin
   -- for Ŀ��
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
-- ���ν��� ����
exec up_makeRank;
--
select * 
from score
order by rk asc
;
-- up_updateScore ���ν���
-- num , X
-- name/kor/eng/mat ����
select * from score;
exec up_updateScore(1009,'���ʱ�',1,2,3);
create or replace procedure up_updateScore
(
   pnum in number   -- ���μ����� ���� datatype ����  size X
   , pname in varchar2 
   , pkor in score.kor%type 
   , peng in number 
   , pmat in number 
)
is
  -- ����,���,Ŀ�� ��� �����
  vtot number(3) := 0;  -- �����ݷ�
  vsavg number(5,2);
  vres varchar2(20) := '�հ�';
begin
  vtot := pkor + peng + pmat;
  vsavg := vtot / 3 ;
  -- vres ��,��,����
  -- if �� / case ��
  case
      when (vsavg < 60) then  vres :='���հ�'; 
      when (pkor <40 or peng < 40 or (pmat) < 40 ) then  vres :='����'; 
      else vres :='�հ�'; 
  end case ;
  
  update score
  set  name = pname, kor=pkor, eng=peng, mat =pmat
  , tot = vtot, savg = vsavg, res = vres
  where num = pnum;
  commit;

   -- up_updateScore ���ν��� �ȿ��� �� �ٸ� ���ν��� ȣ��
   up_makeRank;
-- exception
end;