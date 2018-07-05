----2018-07-05
-- hr ����ڰ� scott.getGender() ��ü�� ����� ����x
select scott.getGender('950211-1234567')
from dual;
--> scott��Ű������ grant select on insa to hr;

--stored function
-->��) 1~n ���� ���ؼ� ��ȯ�ϴ� getSum
create or replace function getSum
(
    pn number := 10
)
return number
is

    vi number :=1;
    vsum number :=0;
begin
    while vi<= pn
    loop
    vsum := vsum + vi;
    vi := vi +1;
    exit when vi>pn;
    end loop;
    
    return vsum;

end;

select getsum(10)
from dual;

-->�ֹι�ȣ�� �Ű������� �Է¹޾Ƽ� ���� ����ؼ� ��ȯ�ϴ� getAge�Լ�
create or replace function getAge
(
    pssn scott.insa.ssn%type
)
return number
is
    vage number;
begin
    vage := round(months_between(sysdate,to_date(substr(pssn,0,6)))/12)+1;
    return vage;
end;


select name, ssn,getAge(ssn), to_char(substr(ssn,0,6),'yyyy')
from scott.insa;

select to_char(to_date(substr(ssn,0,6),'rr/mm/dd'),'yy�� mm�� dd��')
from scott.insa;

--��)ssn -> '1991�� 12�� 31��' getBirth,'yyyy/mm/dd'
-- ssn -> '1991�� 12�� 31��' getBirth , 'YYYY/MM/DD'
create or replace function getBirth
(
   pssn varchar2
)
return date
is
  vbirth varchar2(8); -- '19' || '911009'
  vgender varchar2(2); -- 8,1
  vcentury varchar2(2);  -- 91
  
  vresult date;
begin
   vgender := substr(pssn,8,1);  -- [1]
   
   case 
     when vgender in (1,2,5,6) then vcentury := '19';
     when vgender in (3,4,7,8) then vcentury := '20';
     when vgender in (0,9) then vcentury := '18';
   end case;
   -- '19911009'
   vbirth := vcentury || substr( pssn, 1, 6);
   vresult := to_date( vbirth, 'YYYYMMDD');
   
   return vresult;
-- exception  
end;
--
select name, ssn, getBirth( ssn )
    , to_char( getBirth( ssn ), 'YYYY"��"MM"��"DD"��"' )  a
    , to_char( getBirth( ssn ), 'YYYY-MM-DD' )  b
from scott.insa;


