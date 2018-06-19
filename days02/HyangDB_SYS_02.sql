--2018.06.19(화) days02
--모든 사용자 계정을 확인하는 작업
-- SQL ( Structured Query Language )? 클라와 서버와 구조화된 질의를 하기위한 질의언어 + 데이터 객체를 위한 처리
--DML은 반드시 COMMIT,ROLLBACK해줘야한다.
select * from all_users;
--DROP USER SCOTT CASCADE;
-->User SCOTT이(가) 생성되었습니다.
--CASCADE? 종속
CREATE USER SCOTT IDENTIFIED BY tiger;
-->User SCOTT이(가) 생성되었습니다.
grant resource,connect to scott;

--물리적 작업공간 확보
CREATE TABLESPACE myts datafile 'C:\oraclexe\app\oracle\oradata\XE\myts.dbf' size 100M AUTOEXTEND ON NEXT 5M;

--사용자생성
create user ora_user identified by hong
default tablespace myts
temporary tablespace temp;

--롤 부여하기
grant dba to ora_user;

--모든 사용자 계정 조회
select * from all_users;

--HR 샘플 계정의 비밀번호를 lion으로 설정..
alter user HR identified by lion
account unlock;
--unlock

SELECT *
from ALL_users;
from DBA_users;
--from USER_users;
