--2018-07-06(��)
create table exam1
(
    id number primary key
    , name varchar2(20)
);

create table exam2
(
    memo varchar2(100)
    , ilja date default sysdate
);

-- Ʈ���� �ۼ� : ���( exam1 )���� � �̺�Ʈ( insert ) �۾� �Ŀ� 
--            exam2 ���̺� ���� �ڵ����� �޸�(memo)�� ����ϴ� Ʈ���� �ۼ� 
-- exam1 ������̺� � �̺�Ʈ �߻��Ҷ� exam2 �αױ�� update/delete
create or replace trigger trgInsertExam1
after insert or delete or update--� �̺�Ʈ��?
on exam1 -- � ��󿡰�?
begin
  if inserting 
  then  insert into exam2(memo) values ('> �߰� �۾� - �α�');
  elsif updating 
  then insert into exam2(memo) values ('> ���� �۾� - �α�');
  elsif deleting 
  then  insert into exam2(memo) values ('> ���� �۾� - �α�');
  end if;
   
    --****���� ���ν��� : commit!!
    --****Ʈ���� : commit xxxxx(dml��)
end;
--
insert into exam1 (id, name) values (1,'admin');

update exam1
set name = 'hong'
where id =1;

delete from exam1 where id=1;
commit;
select * from exam1;
select * from exam2;

--2. �۾� ���� �ڵ����� ����Ǵ� Ʈ���� ( before Ʈ���� )
-- ���� )  �ٹ��ð� �ܿ� �̺�Ʈ�� �߻��ϸ� ���ϰ� �ϰ� ���ܸ� �߻���Ű��������

create or replace trigger trgExam1_01
before insert or update or delete
on exam1
begin
    -- �ٹ��ð� x ���� �߻�
    --class �������� exception extends exception

    if (to_char(sysdate,'dy') in ('��','��')
        or to_char(sysdate, 'hh24') <9 or to_char(sysdate,'hh24')>18 ) 
    then RAISE_APPLICATION_ERROR(-20000,'������ �ٹ� �ð��� �ƴϱ⿡ �۾��� �� �����ϴ�.');
    end if;
end;

drop trigger trgExam1_01;
select * from user_procedures;

--[ �� Ʈ���� ] �� �ľ� �� �ۼ�...

create table test01
(
   hak varchar2(10) primary key
   , name varchar2(20)
   , kor number(3)
   , eng number(3)
   , mat number(3)
);
-- Table TEST01��(��) �����Ǿ����ϴ�.
create table test02
(
   hak varchar2(10) primary key
   , tot number(3)
   , ave number(5,2)
   , constraint fk_test02_hak foreign key(hak) 
       references test01(hak)
);
-- Table TEST02��(��) �����Ǿ����ϴ�. 

-- 1)Ʈ����
-- test01 ���̺� ������� �� �л� ��/��/��/�� insert
-- test02 ���̺� ��/��                   insert
create or replace trigger trgTest01
after insert 
ON TEST01
for each row -- ���̺� ���� Ʈ���ſ��� �� ���� Ʈ���� ����...
declare
    vtot number(3);
    vave number(5,2);
begin
   vtot :=  :new.kor + :new.eng + :new.mat;
    vave := vtot/3;
    -- test01 insert
    insert into test02 (hak,tot,ave)
        values(:new.hak, vtot,vave);
end;

--:old,:new�� ���鶧���� ���̺� ���� Ʈ���Ű� �ƴ� '��Ʈ����'�� �������Ѵ�! 
--���̺� ���� Ʈ���� �� 5���� ����(�̺�Ʈ)������ 1���α׹߻�
--�� ���� Ʈ���Ŵ� 5���� ����(�̺�Ʈ)�Ǹ� 5���α׹߻�

insert into test01 values(1,'hong',90,89,78);
commit;
select * from test01;
select * from test02;

update test01
set kor = 80, eng =70, mat=50
where hak =1;

--trgTest01 Ʈ���� ����
create or replace trigger trgTest02
after insert or update or delete
ON TEST01
for each row -- ���̺� ���� Ʈ���ſ��� �� ���� Ʈ���� ����...
declare
    vtot number(3);
    vave number(5,2);
begin
   vtot :=  :old.kor + :old.eng + :old.mat;
    vave := vtot/3;
    -- test01 insert
    if inserting 
    then insert into test02 (hak,tot,ave) values(:new.hak, vtot,vave);
    elsif updating 
    then 
    update test02 
    set tot= vtot, ave=vave
    where hak=:old.hak;
    end if;
    
end;

--test02 ��/�� ���� Ʈ���� ȣ�� trgTest01
--test01 delete ���� �θ�
--test02 delete ���� �ڽ�

---test02 hak = 1 ���� ����....
create or replace trigger trgTest03
before delete
on test01
for each ROW --�� ���� Ʈ����
begin 
    --:new :old 
    delete from test02
    where  hak = :old.hak;
end;

delete from test01
where hak =1;

-- ��ǰ ���̺� �ۼ�
CREATE TABLE ��ǰ (
   ��ǰ�ڵ�        VARCHAR2(6) NOT NULL PRIMARY KEY
  ,��ǰ��           VARCHAR2(30)  NOT NULL
  ,������        VARCHAR2(30)  NOT NULL
  ,�Һ��ڰ���  NUMBER
  ,������     NUMBER DEFAULT 0
);

-- �԰� ���̺� �ۼ�
CREATE TABLE �԰� (
   �԰��ȣ      NUMBER PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�԰�����     DATE
  ,�԰����      NUMBER
  ,�԰�ܰ�      NUMBER
);

-- �Ǹ� ���̺� �ۼ�
CREATE TABLE �Ǹ� (
   �ǸŹ�ȣ      NUMBER  PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�Ǹ�����      DATE
  ,�Ǹż���      NUMBER
  ,�ǸŴܰ�      NUMBER
);

-- ��ǰ ���̺� �ڷ� �߰�
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('AAAAAA', '��ī', '���', 100000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('BBBBBB', '��ǻ��', '����', 1500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('CCCCCC', '�����', '���', 600000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('DDDDDD', '�ڵ���', '�ٿ�', 500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
         ('EEEEEE', '������', '���', 200000);
COMMIT;
SELECT * FROM ��ǰ;

-- 3. Ʈ���� �ۼ� (����)
 -- 1) �԰� ���̺� INSERT Ʈ���Ÿ� �ۼ� �Ѵ�.
   -- [�԰�] ���̺� �ڷᰡ �߰� �Ǵ� ��� 
   --[��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.
CREATE OR REPLACE TRIGGER insIpgo
after insert or update
on �԰�
for each row
begin
   update ��ǰ
   set ������ = ������ + :new.�԰����
   where ��ǰ�ڵ� = :new.��ǰ�ڵ�;
end;
-- �԰� ���̺� ������ �Է�
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (1, 'AAAAAA', '2004-10-10', 5,   50000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (4, 'CCCCCC', '2004-10-14', 15,  250000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
COMMIT;

SELECT * FROM ��ǰ;
SELECT * FROM �԰�;

 -- 2) �԰� ���̺� UPDATE Ʈ���Ÿ� �ۼ� �Ѵ�. (����)
--  [�԰�] ���̺��� �ڷᰡ ���� �Ǵ� ��� 
-- [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.
CREATE OR REPLACE TRIGGER upIpgo
after insert or update
on �԰�
for each row
begin
   update ��ǰ
   set ������ = ������ + :new.�԰���� - :old.�԰����
   where ��ǰ�ڵ� = :new.��ǰ�ڵ�;
end;


-- UPDATE �׽�Ʈ
UPDATE �԰� SET �԰���� = 30 WHERE �԰��ȣ = 5;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �԰�;

 -- 3) �԰� ���̺� DELETE Ʈ���Ÿ� �ۼ� �Ѵ�.
 -- [�԰�] ���̺��� �ڷᰡ �����Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER delIpgo 
after delete
on �԰�
for each row
begin
    update ��ǰ
    set ������ = ������ - :old.�԰����
    where ��ǰ�ڵ� = :new.��ǰ�ڵ�;
end;
 
 -- DELETE �׽�Ʈ
DELETE FROM �԰� WHERE �԰��ȣ = 5;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �԰�;

-- �԰� ���̺��� ��� ���� ���� �� ������ ��ǰ ���̺��� ��� ������ ���ų� ������ �� �� �����Ƿ� UPDATE �� DELETE Ʈ���Ÿ� BEFORE Ʈ���ŷ� �����Ͼ� ��ǰ ���̺��� ��� ������ ���� ���� �Ǵ� ������ �Ҽ� ������ �����Ѵ�.

 -- 4) �Ǹ� ���̺� INSERT Ʈ���Ÿ� �ۼ��Ѵ�.(BEFORE Ʈ���ŷ� �ۼ�)
 -- [�Ǹ�] ���̺� �ڷᰡ �߰� �Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.


CREATE OR REPLACE TRIGGER insPan
before insert
on �Ǹ�
for each row
declare
  qty number;
begin
  select ������ into qty
  from  ��ǰ
  where ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
  
  if  :NEW.�Ǹż��� > qty then
    raise_application_error(-20007,' �Ǹ� ����~ ');
  else
    update ��ǰ
    set   ������ = ������ - :NEW.�Ǹż���
    where ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
  end if;
end;
 

-- �Ǹ� ���̺� ������ �Է�
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;
rollback;

INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (1, 'AAAAAA', '2004-11-10', 50, 1000000);
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;


 -- 5) �Ǹ� ���̺� UPDATE Ʈ���Ÿ� �ۼ��Ѵ�.(BEFORE Ʈ���ŷ� �ۼ�)
 -- [�Ǹ�] ���̺��� �ڷᰡ ���� �Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER upPan
before update
on �Ǹ�
for each row
declare
  qty number;
begin
  select ������ into qty
  from ��ǰ
  where ��ǰ�ڵ� = :new.��ǰ�ڵ�;  
  if :new.�Ǹż��� > ( qty + :OLD.�Ǹż��� ) then
    raise_application_error(-20008,'���� ����~');
  else
    update ��ǰ
    set ������ = ������ - :new.�Ǹż���  + :old.�Ǹż���
    where ��ǰ�ڵ� = :new.��ǰ�ڵ�;
  end if;
end;

-- UPDATE �׽�Ʈ
UPDATE �Ǹ� SET �Ǹż��� = 200 WHERE �ǸŹ�ȣ = 1;
UPDATE �Ǹ� SET �Ǹż��� = 10 WHERE �ǸŹ�ȣ = 1;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;

 -- 6) �Ǹ� ���̺� DELETE Ʈ���Ÿ� �ۼ� �Ѵ�.
 -- [�Ǹ�] ���̺� �ڷᰡ �����Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER delPan 
after delete
on �Ǹ�
for each row
begin
   update ��ǰ 
   set   ������ = ������  + :OLD.�Ǹż���
   where ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   --where ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
end;
 
-- DELETE �׽�Ʈ
DELETE �Ǹ� WHERE �ǸŹ�ȣ = 1;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;