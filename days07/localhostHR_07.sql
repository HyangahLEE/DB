--20180626 (화)

--ORA-01788: CONNECT BY clause required in this query block
select nvl(min(decode(to_char(dates,'d'),1,to_char(dates,'dd'))),' ') 일
        ,nvl(min(decode(to_char(dates,'d'),2,to_char(dates,'dd'))),' ') 월
        ,nvl(min(decode(to_char(dates,'d'),3,to_char(dates,'dd'))),' ') 화
        ,nvl(min(decode(to_char(dates,'d'),4,to_char(dates,'dd'))),' ') 수
        ,nvl(min(decode(to_char(dates,'d'),5,to_char(dates,'dd'))),' ') 목
        ,nvl(min(decode(to_char(dates,'d'),6,to_char(dates,'dd'))),' ') 금
        ,nvl(min(decode(to_char(dates,'d'),7,to_char(dates,'dd'))),' ') 토
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

--의사컬럼(Pseudo Colum) : level 
--계층 순환 구조 emp
select empno, ename, mgr
from scott.emp;

