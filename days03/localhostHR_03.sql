--20180620
--%: 뒤에 문자열 개수가 몇개든 상관 ㄴㄴ 
--*******검색하는 값은 대소문자 구별*********
select last_name, salary 
from employees
-- 주의 * where last_name = '_R%'; 은 안된당 무조건 LIKE!!
where last_name LIKE '_r'; -- 두번째 문자가 r이어야한다.
where last_name LIKE 'r%'; --R로 시작하는 last_name
where last_name LIKE '%r%'--r을 포함한 last_name
order by salary;



--ORA-01722: invalid number
-- 연결 연산자 || ,concat()
--【형식】
--      CONCAT( char1, char2 )


select first_name, last_name 
                , first_name ||' '|| last_name as name
                , concat(concat(first_name,' '),last_name) as name
from employees;



select last_name ,salary
         ,RPAD(' ',salary/1000/1, '*')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 , RPAD(' ',salary/1000, '*') "Salary"
from employees
where department_id = 80
order by last_name;