--20180620
--EMP���̺��� ������ ����̳� �޾Ҵ���? ���� �� �󸶳� ����? ������ � ������� ����?
--�����ġ�
--     expr IS [NOT] NULL 

--1) ������ ���� ����� ���� ���
SELECT ENAME, COMM
FROM EMP
--WHERE COMm is not NULL or comm!=0;
WHERE COMm is NULL;
--2) ������ �������� ����� ������ ���
select ename, comm
from emp
WHERE comm =0 or comm is null;
--3) insa ���̺��� ���� '��'�� ����� ��� ���...
--[like ������]

select *
from insa
where name not like '��%';

SELECT NAME, SSN
            , substr(ssn,0,2) year -- �ֹι�ȣ(ssn) �⵵ 2�ڸ�
            , substr(ssn,1,2) year -- �ֹι�ȣ(ssn) �⵵ 2�ڸ�
            , substr(ssn,3,2) month -- �ֹι�ȣ(ssn) �� 2�ڸ�
            , substr(ssn,5,2) as "date"  -- �ֹι�ȣ(ssn) �� 2�ڸ�
            , substr(ssn,8,1) gender -- �ֹι�ȣ(ssn) ���� 1�ڸ�
            , substr(ssn,8) ssn_last 
            , concat(substr(ssn,0,7),'*******')
FROM INSA;

--sysdata > ���� �ý��� ��¥/�ð� ����, �Լ�()
select sysdata from dual;
select substr('abcdefg', -3,2)  --m ����..? ���� ���� ��ġ�� �ؼ� ���ڿ� �߶�ö�.
        , SUBSTR('abcdefg', -1,2)
from dual; --dual ? sys�� ������ �ִ� dummy���̺�

--[����Ŭ ���ڸ� �ٷ�� �Լ�]
 SELECT ENAME, sal + nvl(comm,0) pay
                ,upper(ename)
                ,lower(ename)
                ,initcap(ename) --�չ��ڸ� �빮��
                ,length(ename) --���ڿ� ����
                , CONCAT(SUBSTR(ENAME,0,3),'***' )
 FROM EMP
 order by pay desc;
 --order by ename asc;
 --order by ename desc;
 
--[ ���� (SORT) ]: ��������(ASC), �������� (DESC) ����
select city, buseo, jikwi, name
from insa
order by 1, 2 desc;
order by city asc, buseo asc;

--ORA-00911: invalid character
select '�̸��� '|| ename || '�̰�, ������ ' || job || ' �̴�.' AS MESSAGE
from emp;


--[INSTR() ���� indexã��]
select instr('KOREA','E')
FROM dual;

select ename
        ,instr(ename,'J')
        ,INSTR(ENAME,'L')
        ,INSTR(ENAME,'L',3) --ã�� �����ϴ� ��ġ�� 3��° ���ڰ�
from emp;
--where instr(ename,'J') =1; --ENAME 'J'�� ù���ڷ� �����ϴ� ���
--WHERE INSTR(ENAME,'L')>0; --L�� ���Ե� �Լ�
select instr('corporate floor','or',-3,2)
       ,instr('corporate floor','or',3)  --'corporate floor'����'or'�̶� ���ڸ� 3���ڰ� �̻���� ã�ƶ�
       ,instr('corporate floor','or',3,2)-- ã�� ��ġ���� 2��° �ִ� or
       ,instr('corporate floor','or',-3,2) --�ڿ��� 3��° ���� 2��° �ִ� or
from dual;

SELECT *
FROM TEST;

--������ �߰� : DML (insert��) + commit, rollback
--INSERT INTO ���̺�� (�÷���..) VALUES ��;
INSERT INTO test (no, tel) VALUES (1,'02)235-1425'); 
INSERT INTO test (no, tel) VALUES (2,'031)268-2048');  
INSERT INTO test (no, tel) VALUES (3,'02)485-1777');
INSERT INTO test (no, tel) VALUES (4,'053)274-1523');  
commit;
-- ������ ���� : DML (update) --commut, rollback
--update ���̺��
--set ������ �÷��� ��
--where ����� ���� ����;

--instr() ����
--��. ���� ���
--��. �߰���ȣ ���
--��. ����ȣ ���

--select 
--   tel
--   , instr(tel, ')')
--   , instr(tel, '-')
--   , substr( tel, 1, instr(tel, ')')-1 ) ����
--   , substr( tel,instr(tel, ')')+1,instr(tel, '-')-instr(tel, ')')-1  ) �߰�����
--   , substr( tel, instr(tel, '-')+1 ) ����������4
--from test;

select SUBSTR(TEL,1,INSTR(TEL,')')) ����
        ,substr(tel,INSTR(TEL,')')+1,3) �߰���ȣ
        ,substr(tel,INSTR(TEL,'-')+1,4) ����ȣ
from test;

with temp
as(
select tel
        ,INSTR(TEL,')')a
        ,INSTR(TEL,'-')b
from test
)
select  tel
   , substr( tel, 1, a-1 ) ����
   , substr( tel, a+1,b-a-1  ) �߰�����
   , substr( tel, b+1 ) ����������
from temp;



--[RPAD()/LPAD()] �Լ����� >�ڸ��� Ȯ��, ���ϴ� ���ڿ�
SELECT ENAME
        ,SAL +NVL(COMM,0) pay
        , rpad(SAL +NVL(COMM,0),10,'*')rp
        ,lpad(SAL +NVL(COMM,0),10,'*')lp
from emp;

select no,tel
      ,rtrim(tel,'0')
      ,ltrim(tel,'0')
      ,ltrim('          hyangh       ',' ') || ']'
      ,rtrim('          hyangh       ',' ')|| ']'
      ,rtrim('******800*****','*')
      ,rtrim('BROWINGyxyxy','xy') a
from test;

--[ASCII]

select ename
        ,ascii(ename) --> ù��° ���ڰ� �ƽ�Ű �ڵ� 
from emp;

select ascii('ȫ�浿')
from dual;

SELECT ENAME
        ,ASCII(ENAME)
        ,CHR(ASCII(ename))
        ,chr(15571341) --3����Ʈ 
from emp;

SELECT GREATEST(10,50,30,20)
        ,LEAST(10,50,30,20)
        ,GREATEST('kbs','mbc','sbs')
        ,LEAST('kbs','mbc','sbs')
FROM DUAL;

select ename
    , replace(ename, 'LA') --> �ι�° ���ڰ��� ������ ����
    , replace(ename, 'LA','��') 
    , replace(ename, 'LA','<span>LA</span>') 
FROM EMP;


SELECT ENAME
    ,LENGTH(ENAME)
    ,VSIZE(ENAME) || 'bytes'--1byte
FROM EMP;
   
SELECT name
    ,LENGTH(NAME)
    ,VSIZE(NAME) || 'bytes'--3byte
FROM insa;


--�μ��� : �ѱ�_ �����ϴ� �μ����� ���
--like ������ : ���ϵ�ī��( % ,_ )
select *
from dept
where dname like '�ѱ�_%';

select *
from dept
where dname like '�ѱ�\_%';--\�� : �ڸ� ���ϵ� ī�忡�� ���� ��Ű�ڴ�. 
                            --> �ѱ�_ �� ���� dname�� ����϶�
                            
SELECT  *
FROM BOOKS
WHERE TITLE LIKE '%100\%%' escape '\';