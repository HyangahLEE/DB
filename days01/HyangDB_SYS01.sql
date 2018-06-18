--오라클 주석처리
SELECT *  FROM tabs;
select * from all_users; --Ctrl + Enter
select * from v$nls_parameters;
--일반 사용자 계정 생성...[identified by]
--계정: scott 비번: tiger  [테스트용도의 샘플계정]
--계정을 만들면 그 계정이 데이터를 사용할수 있는 데이터 객체 -> 스키마(scott 스키마)
CREATE USER scott IDENTIFIED by tiger;-- [externally] 첫번째 접속한 사람이 비밀번호 바꿔라
create USER ora_user IDENTIFIED by hong;
--스캇계정으로 새접속 - 오류 ? create session 권한이 부족해서 로그인x
--ORA-01045: user SCOTT lacks CREATE SESSION privilege; logon denied
--GRANT create session TO SCOTT public [with admin option]--내가 계정 부여받고 다른사람한테 그 계정을 또 다른데 부여할수 있는가?
--GRANT 권한을 부여함 REVOKE 권한을 뺏는다.
--생성 시스템권한 / 조작- 객체권한
--롤? EX) 신입이가지고 있는 권한(신입, 총무...) 을 영업부로 옮겼을때 총무권한을 하나하나 다 빼지말고 
--10가지의 권한들을 집합해 놓은 롤 하나만 빼고 영업롤을 다시 넣는다. [관리 수월, 자동수정] 
--GRANT 권한,또는 룰 TO 사용자
GRANT connect,resource to SCOTT;