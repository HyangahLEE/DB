--20180622

update employees 
set salary = salary * to_number('100.00','9G999D99')
where last_name = 'Perkins';
commit;

--G의미?
select to_number('100.00','9G999D99') -- 월 > 달러
from dual;

SELECT salary
from employees
where last_name = 'Perkins';
--
rollback;

--Nullif(a,b) a=b 널값 , a!=b a값 반환







