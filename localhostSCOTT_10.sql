--2018-06-29 (��)
--����)åid, å ����,�Ǹż���, �ܰ�, ������, �Ǹűݾ�
SELECT b.B_ID,title, p_su||'(��)', price,g_name, to_char(p_su*price,'l999,999')sale_pay
from danga d, panmai p, book b, gogaek g
where b.b_id = d.b_id and b.b_id = p.b_id and g.g_id = p.g_id;

SELECT b.B_ID,title, p_su||'(��)', price,g_name, to_char(p_su*price,'l999,999')sale_pay
from book b join panmai p on b.b_id = p.B_ID
            join danga d on b.b_id = d.b_id
            join gogaek g on g.g_id = p.g_id;
            
SELECT B_ID,title, p_su||'(��)', price,g_name, to_char(p_su*price,'l999,999')
from book join danga using (b_id)
          join panmai using (b_id)
          join gogaek using (g_id);
        
        
--����) ������ å���� �Ǹŵ� �Ǽ� ��ȸ
        --åid,å ����, �ǸűǼ�

select title, sum(p_su)||'��'
from book b, panmai p
where b.b_id = p.b_id
group by title;

select b.b_id , sum(p_su)
from panmai p join book b on p.b_id = b.b_id
group by b.b_id
having sum(p_su) >=10
order by sum(p_su) desc;

select distinct title,
    sum(p_su) over(partition by title)
from  panmai p join book b on p.b_id = b.b_id;

select distinct b.b_id, title
            ,sum(p_su) over(partition by b.b_id order by b.b_id asc) qty
from  panmai p join book b on p.b_id = b.b_id
order by qty desc;

--[�������� (semi join)]: ���������� �̿��� �������� �����ϴ� �����͸� 
--                    ������������ �����ϴ� ���ι��
               --       in,exists SQL������
               
--[��Ƽ����( ANTI JOIN )]: ���������� �̿��� �������� �������� �ʴ� �����͸� 
--                     ������������ �����ϴ� ���ι��
               --       in,exists SQL������


--����) book���̺��� �ǸŰ� �� ���� ���� å ���� ������ ���...
            --panmai���̺�
-->in   
SELECT B_ID,TITLE
FROM BOOK 
WHERE B_ID NOT IN ( SELECT DISTINCT B_ID 
                FROM PANMAI);
-->exists
SELECT b.B_ID,TITLE, PRICE
FROM BOOK b JOIN DANGA D ON b.b_id =d.b_id
WHERE not exists ( SELECT  B_ID FROM PANMAI p where b.b_id = p.b_id);                

--[�������� ( SELF JOIN )]
select e.deptno, e.empno, e.ename
        ,m.deptno, m.empno, m.ename
from emp e join emp m on e.mgr = m.empno;

--> ����) ���� ���� �ȸ� å ���� ���

select rownum, b_id,title, qty
from
(select b.b_id ,title,sum(p_su) qty
from book b join panmai p on b.b_id = p.b_id
group by b.b_id,title
order by qty desc)
where rownum <=1;

select *
from
(select b.b_id ,title,sum(p_su)
    , rank() over(order by sum(p_su)desc)r
from book b join panmai p on b.b_id = p.b_id
group by b.b_id,title)
where r=1;

--> ����) �Ǹŷ� top-3 �� å ���� ���
select *
from
(select b.b_id ,title,sum(p_su)
    , rank() over(order by sum(p_su)desc)r
from book b join panmai p on b.b_id = p.b_id
group by b.b_id,title)
where r<=3;

-->����) �� �� �Ǹ� �ݾ� ���
--      ??���� , �� �Ǹűݾ�
select g_id, 
from panmai p join gogaek g on p.g_id = g.g_id
group by g_id;

select g.g_id, g_name,sum(p_su*price)
from book b join panmai p on b.b_id = p.B_ID
            join danga d on b.b_id = d.b_id
            join gogaek g on g.g_id = p.g_id
group by g.g_id,g_name
order by g.g_id;

--[�������� (inner join)/ �ܺ����� (outer join)]
--[�ܺ�����]?
select d.deptno, dname, count(empno)
from emp e join dept d on e.deptno(+)=d.deptno
group by d.deptno, dname
order by d.deptno;

--P191 [��������.......]

select count(*) 
from emp
where sal >= (select avg(sal) from emp); --��ø ��������, �������� ���� ��������

--> �� �μ��� ��� �̻��� ��� ���
select deptno, ename, sal
        ,( select avg(sal) from emp b where a.deptno = b.deptno ) --�Ϲ� ��������
from emp a
where sal >= ( select avg(sal) from emp b where a.deptno = b.deptno );

update emp
set sal = (select avg(sal) from emp);
rollback;

select * from emp;
update emp a 
set sal = (select avg(sal) from emp b where a.deptno = b.deptno);

--[������ ����]
--1. book, panmai, danga, gogaek �����Ͽ� ������ ��� �Ѵ�.
--  -- å�̸�(title) ����(g_name) �⵵(p_date) ����(p_su) �ܰ�(price) �ݾ�(p_su*price)
--  -- ��, �⵵ �������� ��� 
select title, g_name, p_date, p_su, price, p_su*price
from  book b join panmai p on b.b_id = p.B_ID
            join danga d on b.b_id = d.b_id
            join gogaek g on g.g_id = p.g_id
order by p_date desc;

--2. book ���̺�, panmai ���̺�, gogaek ���̺��� b_id �ʵ�� g_id �ʵ带 �������� �����Ͽ� ������ �ʵ� ��� �Ѵ�. ��, book ���̺��� ��� ���� ��� �ǵ��� �Ѵ�.(OUTER ����)
--  -- b_id, title, g_id, g_name, p_su �ʵ� ���
select b.b_id, title, p.g_id, g_name, p_su
from book b left outer join panmai p on b.b_id=p.b_id
            join gogaek g on p.g_id=g.g_id;


--3. �⵵, ���� �Ǹ� ��Ȳ ���ϱ�
--�⵵    ��    �Ǹűݾ�
--select title, p_date, p_su, p_su*price
--select title,to_char(p_date,'yyyy') y,p_su,p_su*price
select y,m
from 
(select  p_su*price,to_char(p_date,'yyyy') y
        ,to_char(p_date,'mm') m
from book b join panmai p on b.b_ID = P.B_ID
            JOIN danga d on b.b_id = d.b_id)
group by y,m
order by y,m;


--4. ������ �⵵�� �Ǹ���Ȳ ���ϱ�
--�⵵  �����ڵ�    ������   �Ǹűݾ� 
--select 
--
--5. ���� ���� �ǸŰ� ���� å(������ ��������)
--å�ڵ�    å�̸�    ����
--�� 

--6. ������ �Ǹ���Ȳ ���ϱ�
--�����ڵ�  ������  �Ǹűݾ���  ����(�Ҽ��� ��°�ݿø�)
--�� 
--G_ID	G_NAME		�Ǹűݾ�	����
--7	���ϼ���	15300		26%
--4	���Ｍ��	11551		19%
--2	���ü���	6000		10%
--6	��������	18060		30%
--1	�츮����	8850		15%
-----------------------------------------
--p73 [�� ( VIEW )]
--1)���̺� �Ǵ� �� --> �������̺�
--2) �Ϻθ� ������ �� �ֵ��� '����'�ϱ� ���� ���
--3) ��� '������ ��ųʸ�' ���̺� �信 ���� '����'�� ����
SELECT *
FROM tabs; --user_tables >������ ���� ����
--4) ���� ������ ��ü�� ���� ����.
--5) ������ : ���� + ����
--6) �������� ���� + SIUD(DML)�� ��밡��
--7) �÷����� 254��
--8) �������̺��� �������� -���
--9) ���� ���� : �ܼ� ��-�ϳ��� ���̺� ���ؼ���.., ���� �� (complex view)
SELECT *
FROM user_views;
from user_constraints;
from user_tables;

-->� å�� � ������ �� �� �ǸŵǾ����� ��ȸ�ϴ� ���� 
select b.b_id, title, price, g.g_id, g_name, p_date, p_su
from book b join danga d on b.b_id = d.b_id
            join panmai p on b.b_id = p.b_id
            join gogaek g on p.g_id = g.g_id
order by p_date asc;

--�����ġ�
--	CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW ���̸�
--		[(alias[,alias]...]
--	AS subquery
--	[WITH CHECK OPTION]
--	[WITH READ ONLY];
--
-->������ ����, ������ ������ ����;
create or replace view panView
as 
    select b.b_id, title, price, g_name, p_date, p_su
    from book b join danga d on b.b_id = d.b_id
            join panmai p on b.b_id = p.b_id
            join gogaek g on p.g_id = g.g_id
    order by p_date asc;
    
select *
from panview;

create or replace force view sampleView
as
    select seq,title content, regdate
    from board;
    
create view dno10_vw
    as select ename, job, sal, deptno
        from emp where deptno=10;

drop view dno10_vw;

-->����) g_id,g_name, ���Ǹűݾ�, ��ü�Ǹűݾ� �� %?
--create view gogaekView
--as


select g.g_id,g_name , sum(p_su*price) s
,(select sum(p_su*price) from  book b join panmai p on b.b_id = p.B_ID join danga d on b.b_id = d.b_id ) tot
,round((sum(p_su*price)/(select sum(p_su*price) from  book b join panmai p on b.b_id = p.B_ID join danga d on b.b_id = d.b_id ))*100,2) "%"

from  book b join panmai p on b.b_id = p.B_ID
            join danga d on b.b_id = d.b_id
            join gogaek g on g.g_id = p.g_id
group by g.g_id,g_name
order by g.g_id;


create or replace view gogaekView
as 
select g.g_id, g_name, sum( p_su * price ) ���Ǹűݾ�
from gogaek g join panmai p on g.g_id = p.g_id
            join danga d on p.b_id = d.b_id
group by g.g_id, g_name
order by ���Ǹűݾ� desc;

--> view����ؼ� dml�� ��� ( insert, update, delete )
create table testa
(
aid number primary key
,name varchar2(20) not null
,tel varchar2(20) not null
,memo varchar2(100)
);
--Table TESTA��(��) �����Ǿ����ϴ�.
insert into testa values (1,'a',1,null);
insert into testa values (2,'b',2,null);
insert into testa values (3,'c',3,null);
insert into testa values (4,'d',4,null);
commit;
select * from testa;

create table testb
(
bid number primary key
,aid number references testa(aid) on delete cascade
,score number(3)
);

insert into testb values (1,1,80);
insert into testb values (2,2,70);
insert into testb values (3,3,90);
insert into testb values (4,4,100);
commit;

-->���̺� 1�� -> �ܼ��� (simple view)
create or replace view aview
as
select aid, name, tel from testa;
--select aid, name, memo from testa;

select * from aview;
insert into aview values(5,'e',5);
--ORA-01400: cannot insert NULL into ("SCOTT"."TESTA"."TEL")

update aview
set tel =100
where aid = 1;

delete from aview where aid = 1; 

-->�������� 90�� �̻��� �� ������
create or replace view scoreview
as 
    select num, name,kor
    from score
    where kor>=90
    with check option constraint ck_scoreview;
-- 
select * from scoreview;
--ORA-01402: view WITH CHECK OPTION where-clause violation
update scoreview
set kor= 70
where num =1014;

select * from scoreview;


--������ �� (mertrialized view)

