--2018.06.19(ȭ) days02
--��� ����� ������ Ȯ���ϴ� �۾�
-- SQL ( Structured Query Language )? Ŭ��� ������ ����ȭ�� ���Ǹ� �ϱ����� ���Ǿ�� + ������ ��ü�� ���� ó��
--DML�� �ݵ�� COMMIT,ROLLBACK������Ѵ�.
select * from all_users;
--DROP USER SCOTT CASCADE;
-->User SCOTT��(��) �����Ǿ����ϴ�.
--CASCADE? ����
CREATE USER SCOTT IDENTIFIED BY tiger;
-->User SCOTT��(��) �����Ǿ����ϴ�.
grant resource,connect to scott;

--������ �۾����� Ȯ��
CREATE TABLESPACE myts datafile 'C:\oraclexe\app\oracle\oradata\XE\myts.dbf' size 100M AUTOEXTEND ON NEXT 5M;

--����ڻ���
create user ora_user identified by hong
default tablespace myts
temporary tablespace temp;

--�� �ο��ϱ�
grant dba to ora_user;

--��� ����� ���� ��ȸ
select * from all_users;

--HR ���� ������ ��й�ȣ�� lion���� ����..
alter user HR identified by lion
account unlock;
--unlock

SELECT *
from ALL_users;
from DBA_users;
--from USER_users;
