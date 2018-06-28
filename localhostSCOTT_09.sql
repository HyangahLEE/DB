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

