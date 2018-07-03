--2017.07.03 (화)
--PL/SQL : 블록(3개) 구조 언어
DECLARE
    -- 1. 선언부 : 변수 , 상수, 커서 등등
    vmaxsal emp.sal%type;
    vemprow emp%rowtype;
BEGIN
    -- 2. 실행부
    --    :=  INTO select/fetch(cursor)가져오기
     SELECT MAX(SAL)
        into vmaxsal
     FROM EMP;
     
     select *
        into vemprow
     from emp
     where sal = vmaxsal;
     dbms_output.put_line('> deptno : ' || vemprow.deptno );
     dbms_output.put_line('> empno : ' || vemprow.empno );
     dbms_output.put_line('> ename : ' || vemprow.ename );
     dbms_output.put_line('> sal : ' || vemprow.sal );
  
    -- dbms_output.put_line('> max(sal) : '|| vmaxsal);
END;


declare
  vgrade salgrade.grade%type;
  vsal  emp.sal%type;
begin
   select (sal)   into vsal  
   from emp 
   where empno = 7369;
   
   case 
     when vsal  between 700 and 1200   then vgrade := 1;
     when (vsal between 1201 and 1400) then vgrade := 2;
     when (vsal between 1401 and 2000) then vgrade := 3;
     when (vsal between 2001 and 3000) then vgrade := 4;
   end case;
   
   /*
   if (vsal between 700 and 1200) then
     vgrade := 1;
   elsif (vsal between 1201 and 1400) then
     vgrade := 2;
   elsif (vsal between 1401 and 2000) then
     vgrade := 3;
   elsif (vsal between 2001 and 3000) then
     vgrade := 4;
   end if;
   */
  dbms_output.put_line('> 7369의 sal : ' || vsal );
  dbms_output.put_line('> 7369의 grade : ' || vgrade );
-- exception
end;

--> 정수를 입력받아서 홀/짝수 출력.
DECLARE
    vn number(3,0);
    vresult varchar(6) :='홀수';
BEGIN
    vn := :n;
    if mod(vn,2)=0 then vresult := '짝수';
    end if;
    dbms_output.put_line( vn|| ' : ' || vresult );
END;

--p277 case문
-- select 절에서 case 표현식을 사용했듯이 pl/sql 안에서 case문을 사용 할 수 있다. 
-->dbms_random 패키지
        
select  dbms_random.string('u',5) --a>알파벳 대소문자구분 ㄴㄴ, u >대문자랜덤 , ㅣ> 소문자랜덤 
        , dbms_random.value --0.0 <= 실수 < 1
        , dbms_random.value(1,45) --1.0 <= 실수 < 45
from dual;

declare
    vn_sal number :=0;
    vn_deptno number :=0;
begin 
    vn_deptno := round(dbms_random.value (10,120),-1);
    
    select rownum,sal
        into vn_sal
    from emp
    where deptno= vn_deptno and rownum=1 ;
    dbms_output.put_line(vn_sal);
    
    case when vn_sal between 1 and 3000 then  dbms_output.put_line('낮음');
        when vn_sal between 3001 and 6000 then  dbms_output.put_line('중간');
        when vn_sal between 6001 and 10000 then  dbms_output.put_line('높음');
        else dbms_output.put_line('최상위');
    end case;
end;

--[반복문] : Loop, While, For
--loop
--    --반복 처리 구문
--    exit [when 조건];
--end loop;
----
--while 조건식
--loop
--    --반복 처리 구문
--end loop
--for i반복변수 in [reversre] 초기밗..최종값
--loop
    --처리문
--end loop;

-------------------

DEClare
vn_base_num number := :num;
vn_cnt number :=1;
begin 
loop 
    dbms_output.put_line(vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt +1;
    
    exit when vn_cnt >9;
end loop;
end;
-- 
DEClare
vn_base_num number := :num;
vn_cnt number :=1;
begin 
while  vn_cnt <=9
loop 
    dbms_output.put_line(vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt +1;
    
end loop;
end;

--> 문) 1~n까지의 합 출력
DEClare
vsum number := 0;
vi number :=1;
vn number := :num;
begin 
loop 
    if vi != vn then 
    dbms_output.put( vi || ' + ' );
    else
    dbms_output.put( vi || ' = ' );
    end if;
    vsum := vsum +vi;
    vi := vi+1;
    exit when vi>vn;
end loop;
 dbms_output.put_line(  vsum );
end;
--
DEClare
    vsum number := 0;
    vi number :=1;
    vn number := :num;
begin 
while vi<vn
loop 
    if vi != vn then 
    dbms_output.put( vi || ' + ' );
    else
    dbms_output.put( vi || ' = ' );
    end if;
    vsum := vsum +vi;
    vi := vi+1;
    exit when vi>vn;
   end loop;
    dbms_output.put_line(  vsum );
end;
--
DEClare
    vsum number := 0;
    vi number :=1;
    vn number := :num;
begin
for vi in 1.. vn
loop
if vi != vn then 
    dbms_output.put( vi || ' + ' );
    else
    dbms_output.put( vi || ' = ' );
    end if;
    vsum := vsum +vi;
   
end loop;
dbms_output.put_line(  vsum );
end;
--
DEClare
vn_base_num number := :num;
vn_cnt number :=1;
begin
for vn_cnt in 1.. 9
loop
dbms_output.put_line(vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
end loop;
end;

--문제 2단에서 9단까지 출력
declare
 --   vi number :=2;
  --  vj number :=1;
begin
    for vi in 2..9
    loop
        for vj in 1..9
         loop
            dbms_output.put(vi || '*' ||vj || '= ' || rpad(vi * vj,3,' '));
         end loop;
         dbms_output.put_line(' ');
    end loop;
end;
--***for문에 사용되는 반복변수는 선언하지않아도 된다.

begin
    for vj in 1..9
    loop
        for vi in 2..9
         loop
            dbms_output.put(vi || '*' ||vj || '= ' || rpad(vi * vj,3,' '));
         end loop;
         dbms_output.put_line(' ');
    end loop;
end;

--> emp테이블에서 deptno= 10사원의 정보를 조회(출력)
declare
   -- vemprow emp%rowtype;
begin
    --1. 자동(암시적)으로 커서 생성 
    --2. 자동 open 
    for vemprow in (select *  from emp  where deptno =10)
    loop
        --3. 반복적으로 FETCH
     DBMS_OUTPUT.PUT_LINE(vemprow.empno || vemprow.ename);
     end loop;  
     
     --4. 자동 close
end;


declare
 --   vi number :=2;
  --  vj number :=1;
begin
    for vi in 2..9
    loop
        for vj in 1..9
         loop
         if i=2 then goto xxx; end if;
            dbms_output.put(vi || '*' ||vj || '= ' || rpad(vi * vj,3,' '));
         end loop;
         <<xxx>>
         dbms_output.put_line(' ');
    end loop;
end;


select *
from cstvsboard;
--성능 테스트 100만개의 레코드(게시글) 추가..
declare
begin
  for i in 1.. 1000
  loop
    insert into cstVSBoard
      (seq, writer, pwd,email,title
      ,ismode,content) 
    values
      (seq_cstVSBoard.nextval
      , dbms_random.string('U',5) 
      ,'1234',null
      , '반복 -' || i || ' 번째 게시글','y','pl/sql 반복처리'); 
  end loop;
  commit;
-- exception
end;

--[레코드변수]
--【형식】 
--    TYPE [type명] IS RECORD 
--      ( field_name1  datatype [[NOT NULL] { := ? DEFAULT} expr] 
--        field_name2  datatype [[NOT NULL] { := ? DEFAULT} expr] 
--       .................. 
--      );
--    record명   type명;
 
--【예시】
  DECLARE 
  --변수선언
  --recode 자료형 선언
   type empdept_type IS RECORD
   (empno emp.empno%type,
   ename emp.ename%type,
   hiredate emp.hiredate%type,
    dname	VARCHAR2(13),
    loc		VARCHAR2(14));
    --위의 새로운 레코드형 자료형으로 변수선언
   vedRow  empdept_type;
  BEGIN
   select empno,ename, hiredate, dname, loc
        into vedRow
   from emp e join dept d on e.deptno = d.deptno
   where e.empno =7369;
   
  dbms_output.put_line(' ');
  

  END;


--p342 커서(cursor)
--1. 커서 ? sql문장을 처리한 결과를 담고 있는 메모리 영역을 가리키는 일종의 포인터이다.
--2. 커서 종류 : 묵시적(암시적,자동) 커서, 명시적(강제)커서
--3. 커서 처리 순서 : 커서 선언 > open > 반복적 fetch > close
--4. 커서 사용 예) insert, update, delete 암시적 커서..
begin
    update emp
    set ename= 'admin';
    
    DBMS_OUTPUT.PUT_LINE(sql%rowcount);
end;

--결과 : 12

--묵시적 커서
begin
 for vrec in (select deptno, ename, sal, hiredate from emp)
    loop
    DBMS_OUTPUT.PUT_LINE( vrec.deptno ||' '|| vrec.ename||' ' || vrec.hiredate);
    end loop;
end;
--명시적 커서
declare
    --1.커서 선언
    cursor emp_cursor is (select deptno, ename, sal, hiredate from emp);
begin
    --2. open
   -- open emp_cursor;
    --3. 반복적fetch --for문을 쓰면 open $ close 자동
    for vrec in emp_cursor
    loop
    DBMS_OUTPUT.PUT_LINE( vrec.deptno ||' '|| vrec.ename||' ' || vrec.hiredate);
    end loop; 
    --4. close
   -- close emp_cursor;
end;
--
--명시적 커서 선언 2
declare
    vdeptno emp.deptno%type; 
    vename emp.ename%type; 
    vsal emp.sal%type;
    vhiredate emp.hiredate%type;
    cursor emp_cursor is (select deptno, ename, sal, hiredate from emp);
begin
    open emp_cursor;
    loop
    fetch emp_cursor into vdeptno, vename, vsal, vhiredate;
    DBMS_OUTPUT.PUT_LINE( vdeptno ||' '|| vename||' ' || vhiredate);
   -- exit when emp_cursor%notfound;
    exit when emp_cursor%rowcount >= 5;
    end loop;
    close emp_cursor;
end;
--
-- 명시적 커서 + 레코드타입 
declare
    type empxxx is record
    (
    deptno emp.deptno%type; 
    ename emp.ename%type; 
    sal emp.sal%type;
    hiredate emp.hiredate%type;
    );
    
    vrec empxxx;
begin
    open emp_cursor;
    loop
    fetch emp_cursor into vrec;
    exit when emp_cursor%notfound;
    DBMS_OUTPUT.PUT_LINE(  vrec.deptno ||' '|| vrec.vename||' ' || vrec.vhiredate);
    end loop;
    close emp_cursor;
end;



-- ***** 모델링 ***** --
1. DB ( DATABASE ) ? 관련된 데이터 집합.
2. DBMS ? Oracle
3. 스키마 ( Schema ) : scott 계정 scott스키마.DB객체
    DB의 구조 ( 객체, 속성, 관계 )와 제약 조건에 대한 명세를 기술 한 것.
    1)외부 2)개념 3)내부스키마
4. DBA : DB관리자 SYS> SYSTEM
5. DB 시스템 = DB + DBMS(oracle)+ 응용프로그램
6. DB 모델링( MODELING ) ?
    -> 현실 세계에 존재하는 업무적인 프로세스를 파악해서 
       물리적으로 데이터베이스화 시키는 과정.
       EX) 쇼핑몰 구매 : 업무 프로세스 파악 
       1) DB Modeling 절차(순서)
       ㄱ. 업무 파악 ( 요구분석 )
        -> 요구조건 명세서 서류
       ㄴ. 개념적 DB모델링 : 실체(개체)+ 속성 파악 > ERD 
       ㄷ. 논리적 DB모델링 : 
            ERD > 매핑룰 ( mapping rule )에 따라 스키마 설계
                  정규화 ( 제 1정규화~제 5정규화 )
                  -- DBMS 결정 --
       ㄹ. 물리적 DB모델링
            - 컬럼 datatype, sizs정의 ( number int )
            - 성능 향상을 위한 인덱스, 역정규화 ...작업
            
-- ER -Win
1. 업무 프로세스 파악 ( 요구, 분석 ) -> [ 요구 분석 명세서 작성 ]
    ㄱ. 업무 관련 분야에 대한 지식과 상식
    ㄴ. 신입 사원 입장 + 업무 프로세스 파악. 분석
    ㄷ. 서류, 장표, 보고서 등등 각종 문서를 이용해서 업무파악.
    ㄹ. 실무자 미팅
    ㅁ. 백그라운드 프로세스 파악.
    ㅂ. 사용자 요구 분석.
       
2. 개념적 DB 모델링
    -- 현실 세계 업무를 좀 더 명확히 표현하는 방법. ( 순서도 )
    -- [E]ntity - [R]elation - [D]iagram