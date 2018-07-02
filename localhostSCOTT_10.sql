--2018-06-29 (금)
--문제)책id, 책 제목,판매수량, 단가, 서점명, 판매금액
SELECT b.B_ID,title, p_su||'(개)', price,g_name, to_char(p_su*price,'l999,999')sale_pay
from danga d, panmai p, book b, gogaek g
where b.b_id = d.b_id and b.b_id = p.b_id and g.g_id = p.g_id;

SELECT b.B_ID,title, p_su||'(개)', price,g_name, to_char(p_su*price,'l999,999')sale_pay
from book b join panmai p on b.b_id = p.B_ID
            join danga d on b.b_id = d.b_id
            join gogaek g on g.g_id = p.g_id;
            
SELECT B_ID,title, p_su||'(개)', price,g_name, to_char(p_su*price,'l999,999')
from book join danga using (b_id)
          join panmai using (b_id)
          join gogaek using (g_id);
        
        
--문제) 각각의 책들이 판매된 권수 조회
        --책id,책 제목, 판매권수

select title, sum(p_su)||'권'
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

--[세미조인 (semi join)]: 서브쿼리를 이용해 서브퀄에 존재하는 데이터만 
--                    메인쿼리에서 추출하는 조인방법
               --       in,exists SQL연산자
               
--[안티조인( ANTI JOIN )]: 서브쿼리를 이용해 서브퀄에 존재하지 않는 데이터만 
--                     메인쿼리에서 추출하는 조인방법
               --       in,exists SQL연산자


--문제) book테이블에서 판매가 된 적이 없는 책 들의 정보를 출력...
            --panmai테이블
-->in   
SELECT B_ID,TITLE
FROM BOOK 
WHERE B_ID NOT IN ( SELECT DISTINCT B_ID 
                FROM PANMAI);
-->exists
SELECT b.B_ID,TITLE, PRICE
FROM BOOK b JOIN DANGA D ON b.b_id =d.b_id
WHERE not exists ( SELECT  B_ID FROM PANMAI p where b.b_id = p.b_id);                

--[셀프조인 ( SELF JOIN )]
select e.deptno, e.empno, e.ename
        ,m.deptno, m.empno, m.ename
from emp e join emp m on e.mgr = m.empno;

--> 문제) 가장 많이 팔린 책 정보 출력

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

--> 문제) 판매량 top-3 인 책 정보 출력
select *
from
(select b.b_id ,title,sum(p_su)
    , rank() over(order by sum(p_su)desc)r
from book b join panmai p on b.b_id = p.b_id
group by b.b_id,title)
where r<=3;

-->문제) 고객 별 판매 금액 출력
--      ??서점 , 총 판매금액
select g_id, 
from panmai p join gogaek g on p.g_id = g.g_id
group by g_id;

select g.g_id, g_name,sum(p_su*price)
from book b join panmai p on b.b_id = p.B_ID
            join danga d on b.b_id = d.b_id
            join gogaek g on g.g_id = p.g_id
group by g.g_id,g_name
order by g.g_id;

--[내부조인 (inner join)/ 외부조인 (outer join)]
--[외부조인]?
select d.deptno, dname, count(empno)
from emp e join dept d on e.deptno(+)=d.deptno
group by d.deptno, dname
order by d.deptno;

--P191 [서브쿼리.......]

select count(*) 
from emp
where sal >= (select avg(sal) from emp); --중첩 서브쿼리, 연관성이 없는 서브쿼리

--> 각 부서별 평균 이상인 사원 출력
select deptno, ename, sal
        ,( select avg(sal) from emp b where a.deptno = b.deptno ) --일반 서브쿼리
from emp a
where sal >= ( select avg(sal) from emp b where a.deptno = b.deptno );

update emp
set sal = (select avg(sal) from emp);
rollback;

select * from emp;
update emp a 
set sal = (select avg(sal) from emp b where a.deptno = b.deptno);

--[오늘의 문제]
--1. book, panmai, danga, gogaek 조인하여 다음을 출력 한다.
--  -- 책이름(title) 고객명(g_name) 년도(p_date) 수량(p_su) 단가(price) 금액(p_su*price)
--  -- 단, 년도 내림차순 출력 
select title, g_name, p_date, p_su, price, p_su*price
from  book b join panmai p on b.b_id = p.B_ID
            join danga d on b.b_id = d.b_id
            join gogaek g on g.g_id = p.g_id
order by p_date desc;

--2. book 테이블, panmai 테이블, gogaek 테이블을 b_id 필드와 g_id 필드를 기준으로 조인하여 다음의 필드 출력 한다. 단, book 테이블의 모든 행은 출력 되도록 한다.(OUTER 조인)
--  -- b_id, title, g_id, g_name, p_su 필드 출력
select b.b_id, title, p.g_id, g_name, p_su
from book b left outer join panmai p on b.b_id=p.b_id
            join gogaek g on p.g_id=g.g_id;


--3. 년도, 월별 판매 현황 구하기
--년도    월    판매금액
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


--4. 서점별 년도별 판매현황 구하기
--년도  서점코드    서점명   판매금액 
--select 
--
--5. 올해 가장 판매가 많은 책(수량을 기준으로)
--책코드    책이름    수량
--■ 

--6. 서점별 판매현황 구하기
--서점코드  서점명  판매금액합  비율(소수점 둘째반올림)
--■ 
--G_ID	G_NAME		판매금액	비율
--7	강북서점	15300		26%
--4	서울서점	11551		19%
--2	도시서점	6000		10%
--6	강남서점	18060		30%
--1	우리서점	8850		15%
-----------------------------------------
--p73 [뷰 ( VIEW )]
--1)테이블 또는 뷰 --> 가상테이블
--2) 일부만 접근할 수 있도록 '제한'하기 위한 기법
--3) 뷰는 '데이터 딕셔너리' 테이블에 뷰에 대한 '정의'만 저장
SELECT *
FROM tabs; --user_tables >데이터 사전 정의
--4) 실제 물리적 객체는 따로 없다.
--5) 사용목적 : 보안 + 편리성
--6) 제약조건 설정 + SIUD(DML)문 사용가능
--7) 컬럼갯수 254개
--8) 기초테이블의 제약조건 -상속
--9) 뷰의 종류 : 단순 뷰-하나의 테이블에 대해서만.., 복합 뷰 (complex view)
SELECT *
FROM user_views;
from user_constraints;
from user_tables;

-->어떤 책이 어떤 고객에게 몇 개 판매되었는지 조회하는 질의 
select b.b_id, title, price, g.g_id, g_name, p_date, p_su
from book b join danga d on b.b_id = d.b_id
            join panmai p on b.b_id = p.b_id
            join gogaek g on p.g_id = g.g_id
order by p_date asc;

--【형식】
--	CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름
--		[(alias[,alias]...]
--	AS subquery
--	[WITH CHECK OPTION]
--	[WITH READ ONLY];
--
-->없으면 생성, 기존에 있으면 수정;
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

-->문제) g_id,g_name, 총판매금액, 전체판매금액 몇 %?
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
select g.g_id, g_name, sum( p_su * price ) 총판매금액
from gogaek g join panmai p on g.g_id = p.g_id
            join danga d on p.b_id = d.b_id
group by g.g_id, g_name
order by 총판매금액 desc;

--> view사용해서 dml문 사용 ( insert, update, delete )
create table testa
(
aid number primary key
,name varchar2(20) not null
,tel varchar2(20) not null
,memo varchar2(100)
);
--Table TESTA이(가) 생성되었습니다.
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

-->테이블 1개 -> 단순뷰 (simple view)
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

-->국점수가 90점 이상인 뷰 만들자
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


--물리적 뷰 (mertrialized view)

