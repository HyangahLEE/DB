--����Ŭ �ּ�ó��
SELECT *  FROM tabs;
select * from all_users; --Ctrl + Enter
select * from v$nls_parameters;
--�Ϲ� ����� ���� ����...[identified by]
--����: scott ���: tiger  [�׽�Ʈ�뵵�� ���ð���]
--������ ����� �� ������ �����͸� ����Ҽ� �ִ� ������ ��ü -> ��Ű��(scott ��Ű��)
CREATE USER scott IDENTIFIED by tiger;-- [externally] ù��° ������ ����� ��й�ȣ �ٲ��
create USER ora_user IDENTIFIED by hong;
--��ı�������� ������ - ���� ? create session ������ �����ؼ� �α���x
--ORA-01045: user SCOTT lacks CREATE SESSION privilege; logon denied
--GRANT create session TO SCOTT public [with admin option]--���� ���� �ο��ް� �ٸ�������� �� ������ �� �ٸ��� �ο��Ҽ� �ִ°�?
--GRANT ������ �ο��� REVOKE ������ ���´�.
--���� �ý��۱��� / ����- ��ü����
--��? EX) �����̰����� �ִ� ����(����, �ѹ�...) �� �����η� �Ű����� �ѹ������� �ϳ��ϳ� �� �������� 
--10������ ���ѵ��� ������ ���� �� �ϳ��� ���� �������� �ٽ� �ִ´�. [���� ����, �ڵ�����] 
--GRANT ����,�Ǵ� �� TO �����
GRANT connect,resource to SCOTT;