--20180620
--%: �ڿ� ���ڿ� ������ ��� ��� ���� 
--*******�˻��ϴ� ���� ��ҹ��� ����*********
select last_name, salary 
from employees
-- ���� * where last_name = '_R%'; �� �ȵȴ� ������ LIKE!!
where last_name LIKE '_r'; -- �ι�° ���ڰ� r�̾���Ѵ�.
where last_name LIKE 'r%'; --R�� �����ϴ� last_name
where last_name LIKE '%r%'--r�� ������ last_name
order by salary;



--ORA-01722: invalid number
-- ���� ������ || ,concat()
--�����ġ�
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