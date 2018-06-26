--20180626(화)
--1
select name, buseo, city, basicpay, basicpay+sudang "총급여"
        , case 
            when 2500000<=basicpay+sudang then '2%'
            when 2000000<=basicpay+sudang then '1%'
            else '0'
            end "세금"
        , case
            when 2500000<=basicpay+sudang then(basicpay+sudang)-(basicpay+sudang)*0.02 
            when 2000000<=basicpay+sudang then(basicpay+sudang)-(basicpay+sudang)*0.01
            else(basicpay+sudang)
            end "실수령액"
from insa;

--2
select name, decode(mod(substr(ssn,8,1),2),0,'여자','남자') 
        
from insa;

--18
select ename, job, sal
from emp a
where sal = all (
select max(sal)
from emp
where a.DEPTNO= deptno);

--19
select count(*) "총사원수", count( decode(deptno,10,1)) "10번부서사원수"
        , count( decode(deptno,20,1)) "20번부서사원수"
        , count( decode(deptno,30,1)) "30번부서사원수"
        , count( decode(deptno,40,1)) "40번부서사원수"
from emp;

--20
--1)
select deptno , max(sal)
from emp
group by deptno;
--2)
select*
from(
select ename, sal
        ,rank() over(partition by deptno order by sal) rank
from emp)
where rank =1;

--21
select to_char(hiredate,'yyyy') y,  count(*) "각 년도별 총 입사원수" 
       
from emp
group by  to_char(hiredate,'yyyy')
order by y;

--22
--1)
select rownum ,ename, sal
from 
(select ename, sal
from emp
order by sal desc
)
where rownum<=3;
--2)
select *
from
(select ename, sal 
        ,rank() over(order by sal) r
from emp)
where r<=3;

--23)
select *
from
(
select name, trunc(cume_dist() over(ORDER BY basicpay),3) c
from insa)
where c<=0.1;

--24)
select *
from (select deptno from emp)
pivot( count(deptno) for deptno in (10,20,30,40) );

--25)
select deptno, ename, sal,
        ntile(4) over(order by sal)
from emp;
