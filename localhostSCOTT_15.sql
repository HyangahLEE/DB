--2018-07-06(금)
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

-- 트리거 작성 : 대상( exam1 )에게 어떤 이벤트( insert ) 작업 후에 
--            exam2 테이블 에게 자동으로 메모(memo)를 기록하는 트리거 작성 
-- exam1 대상테이블에 어떤 이벤트 발생할때 exam2 로그기록 update/delete
create or replace trigger trgInsertExam1
after insert or delete or update--어떤 이벤트를?
on exam1 -- 어떤 대상에게?
begin
  if inserting 
  then  insert into exam2(memo) values ('> 추가 작업 - 로그');
  elsif updating 
  then insert into exam2(memo) values ('> 수정 작업 - 로그');
  elsif deleting 
  then  insert into exam2(memo) values ('> 삭제 작업 - 로그');
  end if;
   
    --****저장 프로시저 : commit!!
    --****트리거 : commit xxxxx(dml문)
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

--2. 작업 전에 자동으로 수행되는 트리거 ( before 트리거 )
-- ㅇㅖ )  근무시간 외에 이벤트가 발생하면 못하게 하고 예외를 발생시키도록하자

create or replace trigger trgExam1_01
before insert or update or delete
on exam1
begin
    -- 근무시간 x 예외 발생
    --class 점수범위 exception extends exception

    if (to_char(sysdate,'dy') in ('토','일')
        or to_char(sysdate, 'hh24') <9 or to_char(sysdate,'hh24')>18 ) 
    then RAISE_APPLICATION_ERROR(-20000,'지금은 근무 시간이 아니기에 작업할 수 없습니다.');
    end if;
end;

drop trigger trgExam1_01;
select * from user_procedures;

--[ 행 트리거 ] 의 파악 및 작성...

create table test01
(
   hak varchar2(10) primary key
   , name varchar2(20)
   , kor number(3)
   , eng number(3)
   , mat number(3)
);
-- Table TEST01이(가) 생성되었습니다.
create table test02
(
   hak varchar2(10) primary key
   , tot number(3)
   , ave number(5,2)
   , constraint fk_test02_hak foreign key(hak) 
       references test01(hak)
);
-- Table TEST02이(가) 생성되었습니다. 

-- 1)트리거
-- test01 테이블 대상으로 한 학생 이/국/영/수 insert
-- test02 테이블에 총/평                   insert
create or replace trigger trgTest01
after insert 
ON TEST01
for each row -- 테이블 레벨 트리거에서 행 레벨 트리거 선언...
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

--:old,:new를 만들때에는 테이블 레벨 트리거가 아닌 '행트리거'로 만들어야한다! 
--테이블 레벨 트리거 는 5개가 변경(이벤트)되지만 1번로그발생
--행 레벨 트리거는 5개가 변경(이벤트)되면 5번로그발생

insert into test01 values(1,'hong',90,89,78);
commit;
select * from test01;
select * from test02;

update test01
set kor = 80, eng =70, mat=50
where hak =1;

--trgTest01 트리거 생성
create or replace trigger trgTest02
after insert or update or delete
ON TEST01
for each row -- 테이블 레벨 트리거에서 행 레벨 트리거 선언...
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

--test02 총/평 수정 트리거 호출 trgTest01
--test01 delete 삭제 부모
--test02 delete 삭제 자식

---test02 hak = 1 먼저 삭제....
create or replace trigger trgTest03
before delete
on test01
for each ROW --행 레벨 트리거
begin 
    --:new :old 
    delete from test02
    where  hak = :old.hak;
end;

delete from test01
where hak =1;

-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드        VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명           VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격  NUMBER
  ,재고수량     NUMBER DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;
SELECT * FROM 상품;

-- 3. 트리거 작성 (문제)
 -- 1) 입고 테이블에 INSERT 트리거를 작성 한다.
   -- [입고] 테이블에 자료가 추가 되는 경우 
   --[상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.
CREATE OR REPLACE TRIGGER insIpgo
after insert or update
on 입고
for each row
begin
   update 상품
   set 재고수량 = 재고수량 + :new.입고수량
   where 상품코드 = :new.상품코드;
end;
-- 입고 테이블에 데이터 입력
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2004-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2004-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
COMMIT;

SELECT * FROM 상품;
SELECT * FROM 입고;

 -- 2) 입고 테이블에 UPDATE 트리거를 작성 한다. (문제)
--  [입고] 테이블의 자료가 변경 되는 경우 
-- [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.
CREATE OR REPLACE TRIGGER upIpgo
after insert or update
on 입고
for each row
begin
   update 상품
   set 재고수량 = 재고수량 + :new.입고수량 - :old.입고수량
   where 상품코드 = :new.상품코드;
end;


-- UPDATE 테스트
UPDATE 입고 SET 입고수량 = 30 WHERE 입고번호 = 5;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 입고;

 -- 3) 입고 테이블에 DELETE 트리거를 작성 한다.
 -- [입고] 테이블의 자료가 삭제되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER delIpgo 
after delete
on 입고
for each row
begin
    update 상품
    set 재고수량 = 재고수량 - :old.입고수량
    where 상품코드 = :new.상품코드;
end;
 
 -- DELETE 테스트
DELETE FROM 입고 WHERE 입고번호 = 5;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 입고;

-- 입고 테이블의 재고 수량 수정 및 삭제는 상품 테이블의 재고 수량이 적거나 없으면 할 수 없으므로 UPDATE 및 DELETE 트리거를 BEFORE 트리거로 수정하야 상품 테이블의 재고 수량에 따라 수정 또는 삭제를 할수 없도록 수정한다.

 -- 4) 판매 테이블에 INSERT 트리거를 작성한다.(BEFORE 트리거로 작성)
 -- [판매] 테이블에 자료가 추가 되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.


CREATE OR REPLACE TRIGGER insPan
before insert
on 판매
for each row
declare
  qty number;
begin
  select 재고수량 into qty
  from  상품
  where 상품코드 = :NEW.상품코드;
  
  if  :NEW.판매수량 > qty then
    raise_application_error(-20007,' 판매 오류~ ');
  else
    update 상품
    set   재고수량 = 재고수량 - :NEW.판매수량
    where 상품코드 = :NEW.상품코드;
  end if;
end;
 

-- 판매 테이블에 데이터 입력
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;
rollback;

INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2004-11-10', 50, 1000000);
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;


 -- 5) 판매 테이블에 UPDATE 트리거를 작성한다.(BEFORE 트리거로 작성)
 -- [판매] 테이블의 자료가 변경 되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER upPan
before update
on 판매
for each row
declare
  qty number;
begin
  select 재고수량 into qty
  from 상품
  where 상품코드 = :new.상품코드;  
  if :new.판매수량 > ( qty + :OLD.판매수량 ) then
    raise_application_error(-20008,'수정 오류~');
  else
    update 상품
    set 재고수량 = 재고수량 - :new.판매수량  + :old.판매수량
    where 상품코드 = :new.상품코드;
  end if;
end;

-- UPDATE 테스트
UPDATE 판매 SET 판매수량 = 200 WHERE 판매번호 = 1;
UPDATE 판매 SET 판매수량 = 10 WHERE 판매번호 = 1;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;

 -- 6) 판매 테이블에 DELETE 트리거를 작성 한다.
 -- [판매] 테이블에 자료가 삭제되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER delPan 
after delete
on 판매
for each row
begin
   update 상품 
   set   재고수량 = 재고수량  + :OLD.판매수량
   where 상품코드 = :NEW.상품코드;
   --where 상품코드 = :OLD.상품코드;
end;
 
-- DELETE 테스트
DELETE 판매 WHERE 판매번호 = 1;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;