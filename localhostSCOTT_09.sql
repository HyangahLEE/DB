--2018.06.28 (목)

--1. 제약 조건 확인
SELECT *
FROM user_constraints; 

--2. 제약조건 - data 
--    ㄱ.개체무결성 
--    ㄴ.참조무결설
--    ㄷ.도메인무결성

select * from emp;
insert into emp values(9999,'SMITH','CLERK',7902,'80/12/17',800,null,90);
--ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found 

--1. 제약 조건 생성
--    ㄱ.column level 방식
--    ㄴ.Table level 방식



create table test01(
-- 제약 조건 명을 설정하지 않으면 sys_???
id varchar2(20) constraint PK_TEST01_ID primary key --제약조건 설정 [column level]
,name varchar2(20)
);

create table test01(
id varchar2(20) 
,name varchar2(20)
, CONSTRAINT pk_test01_id primary key(id)
);

---
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('test02');


--FOREIGN KEY (외래키/참조키) 생성
--TEST01 id(pk) name
--test02  seq(pk)/id(test01.id fk)/content
--
--dept( deptno(pk)
--emp (....,depno(dept.deptno fk))

--FK 컬럼레벨
create table test02(
seq number constraint pk_test02_seq primary key
,id varchar2(20) constraint fk_test02_id
                    references test01(id)
,content varchar2(100)
,constraint fk_test02_id foreign key(id) references test01(id)
);
--FK 테이블레벨
create table test02(
seq number 
,id varchar2(20) 
,content varchar2(100)
,CONSTRAINT pk_test02_seq primary key(seq)
,constraint fk_test02_id foreign key(id) references test01(id)
);

select *
from user_constraints
where table_name like 'TEST0 _';

INSERT INTO test01 values('aaa','홍길동');
INSERT INTO test01 values('bbb','이향아');
INSERT INTO test01 values('ccc','김향아');

INSERT INTO test02 values(1,'ccc','향아 졸림');
INSERT INTO test02 values(2,'bbb','향아 배고픔');
INSERT INTO test02 values(3,'ccc','오늘 뭐먹지');
INSERT INTO test02 values(4,'ccc','가벼운거!');
INSERT INTO test02 values(5,null,'강남역 ㄱㄱ'); --부모꺼 꼭 참조해야한다.
commit;

select * from test01; --부모 테이블
select * from test02; -- 자식 테이블
delete from test01 where id= 'aaa'; -- 참조 안하면 삭제가능
delete from test01 where id= 'ccc'; --참조하고 있어서 오류!!

create table test02(
seq number 
,id varchar2(20) 
,content varchar2(100)
,CONSTRAINT pk_test02_seq primary key(seq)
,constraint fk_test02_id foreign key(id) references test01(id)
                        on delete cascade --연쇄적으로 삭제
);

create table test02(
seq number 
,id varchar2(20) 
,content varchar2(100)
,CONSTRAINT pk_test02_seq primary key(seq)
,constraint fk_test02_id foreign key(id) references test01(id)
                        on delete set null --test02만 null로 바뀜  
);

create table test01(

id varchar2(20) 
,name varchar2(20)
);
--Table TEST01이(가) 생성되었습니다.
--제약조건 pk추가
alter table test01
add(constraint pk_test01_id primary key(id));
--Table TEST01이(가) 변경되었습니다.
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'TEST01';
--제약조건 삭제
ALTER TABLE TEST01
DROP CONSTRAINT pk_test01_id;

--test02테이블 생성  > alter table문 > table에 pk,fk제약조건생성
create table test02(
id varchar2(2)
,content varchar2(100)
);

drop table test02;


alter table test02
add(
      -- PK
      constraint pk_test02_seq primary key(seq)
      -- FK
      , constraint fk_test02_id foreign key(id) 
        references test01(id)
        -- on delete cascade 
);

--emp테이블 select (empno,ename, hiredate, mgr)
create table emp_copy as(
select empno,ename, hiredate, mgr
from emp
);

select * from emp_copy;
--where 1=0 구조만 복사 데이터(행)x
--각 컬럼의 자료형
desc emp_copy;
--***제약조건 복사 x(not null제약조건 oo)
select *
from user_constraints
where table_name like 'EMP%';
--EMP pk/fk -> emp_copy 제약조건 복사x(기억하세욥!!)

alter table emp_copy
add(
constraint pk_empcopy_empno primary key (empno)
,constraint fk_empcopy_mgr foreign key(mgr)
        references emp_copy(empno)
);

create table test03(

empno number(4)
, dd date

--,constraint fk_test03_empno foreign key(empno) references ()
);

alter table test03
add(
constraint pk_test03_empno_dd primary key(empno,dd)
,constraint fk_test03_empno foreign key(empno) references emp(empno)
);

create table a (
id varchar2(10)
, name varchar2(20)
);
--***pk설정후에 notnull + unique 제약조건 자동으로 설정 + 인덱스!

--[UNIQUE]제약 조건 ( 유일성 )
--1. pk 아니라도 중복 허용하지 않는 컬럼이 존재.
-----------------------------
--[student 테이블]
--학번(pk) 학생명 주민번호(uk) 이메일(uk) 연락처(uk) 
-------------------------------
--INSA테이블에 제약조건 확인
select *
from user_constraints
where table_name = 'INSA';

ALTER TABLE INSA
ADD(
CONSTRAINT uk_insa_ssn unique(ssn)
);

--[check 제약조건...]
alter table score
add(
constraint ck_score_kor check(kor between 0 and 100)
--constraint ck_score_kor check(kor>=0 and kor<=100)
);

select *
from user_constraints
where table_name = 'score';

-- insa테이블에 city 컬럼 check 제약조건
select distinct city
from insa;

--alter table insa
--add(constraint ck_insa_city check(city in ('서울','인천'...)));


--[NOT NULL] **테이블 레벨로만 제약조건 가능
create table test05
(
   id varchar2(20) not null primary key
   , name varchar2(20) not null  -- 컬럼 레벨 NN 제약 설정
   , addr varchar2(100)  -- 디폴트 null
   -- , addr NOT NULL 테이블... X
);
-->ADDR컬럼을 NOTNULL로
--1)
ALTER TABLE TEST05
MODIFY addr notnull;
--2)
ALTER TABLE TEST05
ADD(
constraint nn_test05_addr CHECK(ADDR IS NOT NULL)
);
-->제약조건 삭제
alter table test05
drop constraint ck_test05_addr;

--[제약조건 활성화&비활성화]
--【형식】--활성화
--	ALTER TABLE 테이블명
--	ENABLE CONSTRAINT constraint명;
--
--【형식】--비활성화
--	ALTER TABLE 테이블명
--	DISABLE CONSTRAINT constraint명 [CASCADE];

--[제약조건 삭제]
--방법1)
--ALTER TABLE 테이블명 
--DROP [CONSTRAINT constraint명 | PRIMARY KEY | UNIQUE(컬럼명)]
--[CASCADE];
--
--CASCADE옵션은 참조하는 FOREIGN KEY가 있을 때 사용한다.
--
--방법2)
--DROP TABLE 테이블명 CASCADE CONSTRAINTS;
--
--테이블과 그 테이블을 참조하는 foreign key를 동시에 삭제할 수 있다.
--
--방법3)
--DROP TABLESPACE 테이블스페이스명 
--INCLUDING CONTENTS
--CASCADE CONSTRAINTS;
--
--이 방법은 테이블이 다른 테이블스페이스에 있는 테이블의 FOREIGN KEY에 의하여 참조되는 경우 TABLESPACE까지 함께 삭제하는 경우이다.

CREATE TABLE book(
       b_id     VARCHAR2(10)  NOT NULL PRIMARY KEY
      ,title      VARCHAR2(100) NOT NULL
      ,c_name  VARCHAR2(100) NOT NULL
);

CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL
      ,price  NUMBER(7) NOT NULL
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);

CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);
INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * FROM book;
SELECT * FROM danga;
SELECT * FROM gogaek;
SELECT * FROM panmai;
SELECT * FROM au_book;

--[동등조인( equi join )]
-- where 조건절 and 조인조건 = 연산자

select e.empno,  ename, d.deptno, dname
from emp e, dept d
where d.deptno = e.DEPTNO;

select b.b_id, title, c_name , price
from book b , danga d
where b.b_id= d.b_id;

-->각 책 종류별로 가격 가장 높은 것 조회?
select b.b_id, title, c_name , price
from book b , danga d 
where b.b_id = d.b_id ;

select *
from 
(
select b.b_id, title, c_name , price 
        ,rank() over(partition by title order by price desc) r
from book b , danga d 
where b.b_id = d.b_id )
where r = 1;

--[ANSI JOIN]
--where 조인 조건 
--1> from join on

select b.b_id, title, c_name , price
from book b join danga d 
on b.b_id = d.b_id ;

--2>      using  -별칭사용 XX

select b_id, title, c_name , price
from book join danga 
using( b_id );

-->동등 조인 = [오라클] NATURAL JOIN
select b_id, title, c_name , price
from book NATURAL join danga ; --객체명 사용XXX

--[NON-EQUI]
SELECT EMPNO, ENAME,SAL, GRADE
FROM EMP e , SALGRADE s
WHERE sal between losal and hisal ;

-->ANSI JOIN
SELECT EMPNO, ENAME,SAL, GRADE
FROM EMP JOIN SALGRADE ON sal between losal and hisal ;
