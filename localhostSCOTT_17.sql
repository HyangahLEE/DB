--2018-07-10 (ȭ)
--p328 Ʈ����� ( Transaction )
--Ʈ�����(Transaction)�̶� ���� ó���� �Ϸ���� ���� �߰� ������ ����Ͽ� 
--���� ���� �� �ܰ�� �ǵ����� ����̴�. 
--��, ����� ����Ǳ������ �߰� �ܰ迡�� ������ �߻��Ͽ��� ��� 
--��� �߰� ������ ��ȿȭ�Ͽ� �۾��� ó�� ���� �� �ܰ�� �ǵ����� ���̶� �� �� �ִ�. 
--���� �ϷḦ �˸��� commit�� ���� ��Ҹ� �˸��� rollback�� ���δ�.
--DML���� �����ϸ� �ش� Ʈ�����ǿ� ���� �߻��� �����Ͱ� �ٸ� ����ڿ� ����
--������ �߻����� �ʵ��� LOCK(�������)�� �߻��Ѵ�. 
--�� lock�� commit �Ǵ� rollback���� ����Ǹ� �����ȴ�.

-- : '�ŷ�', ���࿡�� �Ա�+����ϴ� �ŷ�
-- ��ü = A ���� ��� -> B ���� �Ա�
--          UPDATE     UPDATE
--                                          [TCL]
--          ���� �� �۾��� ��� ���������� ���� : COMMIT
--                                           ROLLBACK
--                                          SAVEPOINT
--DML( INSERT, UPDATE, DELETE ) COMMIT/ROLLBACK
UPDATE emp
set ename = 'hong'
where empno = 7369;
--*****dml�� ���� ������!!!!!commit or rollback ����� �ٸ� ��Ű�������� ��밡��****
--***���ν����� commmit ���!! but  Ʈ���Ŵ� commit��� XXX
--commit work; --������ ���̱����� work����.
--rollback to savepoint ����������Ʈ��;

create or replace procedure ����_��ü
(
    ����1,
    ����2,
    ��ü�ݾ�
)
is 
begin
    --��ü�ݾ� ��ŭ ����1 ���
    update 
    --��ü�ݾ� ��ŭ ����2 �Ա�
    update
    --
    commit;
exception
    WHEN others then 
    ROLLBACK;
end;

--
BEGIN
    A INSERT  ����
    SAVEPOINT SP_XXX
    B UPDATE  ����
    C DELETE ����
EXCEPTION
    WHEN THEN
        ROLLBACK -- A,B��� �ѹ�
        ROLLBACK TO SAVEPOINT SP_XXX; --
        COMMIT;
END;

--
--[���� ( SESSION )]
-- ����Ŭ���� session�̶� 
--   �����ͺ��̽��� �����Ͽ� �Ϸ��� SQL���� ������ ��
--   �����ͺ��̽��κ��� �����ϴ� ���������� ���Ѵ�.

---
SELECT USERENV('SESSIONID')
FROM DUAL;
---
SELECT ENAME, JOB
FROM EMP
WHERE ENAME = 'MILLER';
---
UPDATE EMP
SET JOB = 'MANAGER'
WHERE ENAME = 'MILLER'
FOR UPDATE OF [JOB NOWAIT]; -- COMMIT���ϸ� SELECT�ϴ� ��� �������� ���� �ɾ�� 
ROLLBACK;