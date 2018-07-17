--2018-07-10 (화)
--p328 트랜잭션 ( Transaction )
--트랜잭션(Transaction)이란 일의 처리가 완료되지 않은 중간 과정을 취소하여 
--일의 시작 전 단계로 되돌리는 기능이다. 
--즉, 결과가 도출되기까지의 중간 단계에서 문제가 발생하였을 경우 
--모든 중간 과정을 무효화하여 작업의 처음 시작 전 단계로 되돌리는 것이라 할 수 있다. 
--일의 완료를 알리는 commit과 일의 취소를 알리는 rollback이 쓰인다.
--DML문을 실행하면 해당 트랜젝션에 의해 발생한 데이터가 다른 사용자에 의해
--변경이 발생하지 않도록 LOCK(잠김현상)을 발생한다. 
--이 lock은 commit 또는 rollback문이 실행되면 해제된다.

-- : '거래', 은행에서 입금+출금하는 거래
-- 이체 = A 통장 출금 -> B 통장 입금
--          UPDATE     UPDATE
--                                          [TCL]
--          위의 두 작업이 모두 최종적으로 성공 : COMMIT
--                                           ROLLBACK
--                                          SAVEPOINT
--DML( INSERT, UPDATE, DELETE ) COMMIT/ROLLBACK
UPDATE emp
set ename = 'hong'
where empno = 7369;
--*****dml문 사용시 무조건!!!!!commit or rollback 해줘야 다른 스키마에서도 사용가능****
--***프로시져는 commmit 사용!! but  트리거는 commit사용 XXX
--commit work; --가독성 높이기위해 work붙임.
--rollback to savepoint 세이프포인트명;

create or replace procedure 은행_이체
(
    계좌1,
    계좌2,
    이체금액
)
is 
begin
    --이체금액 만큼 계좌1 출금
    update 
    --이체금액 만큼 계좌2 입금
    update
    --
    commit;
exception
    WHEN others then 
    ROLLBACK;
end;

--
BEGIN
    A INSERT  성공
    SAVEPOINT SP_XXX
    B UPDATE  성공
    C DELETE 실패
EXCEPTION
    WHEN THEN
        ROLLBACK -- A,B모두 롤백
        ROLLBACK TO SAVEPOINT SP_XXX; --
        COMMIT;
END;

--
--[세션 ( SESSION )]
-- 오라클에서 session이란 
--   데이터베이스에 접속하여 일련의 SQL문을 실행한 후
--   데이터베이스로부터 종료하는 시점까지를 말한다.

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
FOR UPDATE OF [JOB NOWAIT]; -- COMMIT안하면 SELECT하는 모든 조건절에 락을 걸어라 
ROLLBACK;