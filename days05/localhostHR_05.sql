--20180622

update employees 
set salary = salary * to_number('100.00','9G999D99')
where last_name = 'Perkins';
commit;

--G�ǹ�?
select to_number('100.00','9G999D99') -- �� > �޷�
from dual;

SELECT salary
from employees
where last_name = 'Perkins';
--
rollback;

--Nullif(a,b) a=b �ΰ� , a!=b a�� ��ȯ







