--20180626 (ȭ)

--ORA-01788: CONNECT BY clause required in this query block
select nvl(min(decode(to_char(dates,'d'),1,to_char(dates,'dd'))),' ') ��
        ,nvl(min(decode(to_char(dates,'d'),2,to_char(dates,'dd'))),' ') ��
        ,nvl(min(decode(to_char(dates,'d'),3,to_char(dates,'dd'))),' ') ȭ
        ,nvl(min(decode(to_char(dates,'d'),4,to_char(dates,'dd'))),' ') ��
        ,nvl(min(decode(to_char(dates,'d'),5,to_char(dates,'dd'))),' ') ��
        ,nvl(min(decode(to_char(dates,'d'),6,to_char(dates,'dd'))),' ') ��
        ,nvl(min(decode(to_char(dates,'d'),7,to_char(dates,'dd'))),' ') ��
from
(select to_date(:ym,'yyyy/mm') + level-1   dates    
from dual
connect by level <= extract(day from last_day(to_date(:ym,'yyyy/mm')))
)t
group by decode(to_char(dates, 'D'),1,to_char(dates,'IW')+1,to_char(dates,'IW'))
order by decode(to_char(dates, 'D'),1,to_char(dates,'IW')+1,to_char(dates,'IW'));


-----
select to_date(:ym,'yyyy/mm') + level-1
        , last_day(to_date(:ym,'yyyy/mm'))
        ,to_char(last_day(to_date(:ym,'yyyy/mm')),'dd')
        ,extract(day from last_day(to_date(:ym,'yyyy/mm')))
FROM DUAL
connect by level <=30;

--�ǻ��÷�(Pseudo Colum) : level 
--���� ��ȯ ���� emp
select empno, ename, mgr
from scott.emp;

