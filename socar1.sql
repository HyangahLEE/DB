
--[�α���]

create or replace procedure up_socar_login
(
    pmemail in members.memail%type,
    pmpwd in members.mpwd%type,
    results out number
)
is
    v_cnt number;
    v_mpwd members.mpwd%type;
begin
    select count(*)
        into v_cnt
    from members
    where pmemail = memail;
    
    if v_cnt = 1 then
        select mpwd
            into v_mpwd
        from members
        where memail = pmemail;
        if v_mpwd = pmpwd then results := 1;
        else results := 0;
        end if;
    else results := -1;
    end if;
-- exception
commit;
end;

variable vresults number
begin
    up_socar_login( 'ymkim0505@korea.com', '563gdfh', :vresults );
    if :vresults = -1 then
        dbms_output.put_line('���̵� �����ϴ�.');
    elsif :vresults = 0 then
        dbms_output.put_line('��й�ȣ�� Ʋ�Ƚ��ϴ�.');
    elsif :vresults = 1 then
        dbms_output.put_line('�α��� �Ǿ����ϴ�.');
    end if;
end;
---------------------------------------------------------------------------->>�α��� �Ϸ�
create sequence SEQ_join        
increment by 1
start with 6;
--*ȸ������ ������ 1*


--[1.soȸ������ : �̸�] --�Ϸ�
create or replace procedure up_sjoin_name
(  
     pmname members.mname%type
)
is 
begin
     insert into members (memberid, mname) values(seq_join.nextval, pmname);
   commit;
end;

-->
exec up_sjoin_name('�ż���');
--
--[2. soȸ������ : �̸���] --�Ϸ�
create or replace procedure up_sjoin_email
(  
    pmemail members.memail%type
)
is 
    vemailck number;
begin

    select count(*)
        into  vemailck
    from members
    where memail = pmemail;
    
     if vemailck = 1 then 
        dbms_output.put_line('�ߺ��� ���̵��Դϴ�.');
    else
    update members
    set memail =  pmemail
    where memail is null;
    commit;
    end if;
    
end;
-->
execute up_sjoin_email('gywn888@gmail.com');



--[3. soȸ������ : ��й�ȣ] --�Ϸ�  > ��ȣȭ ����
create or replace procedure up_sjoin_pwd
(  
    ppwd members.mpwd%type
)
is 
begin
    update members
    set mpwd = CryptIT.encrypt(ppwd, 'test')
    where mpwd is null;
    commit;
end;
-->
exec up_sjoin_pwd('42523424');



--[4. soȸ������ : �޴�����ȣ] -- �ϼ�
create or replace procedure up_sjoin_tel
(  
    pmtel members.mtel%type
)
is 
begin

    update members
    set mtel =  pmtel
    where mtel is null;
     commit;
end;
-->
execute up_sjoin_tel(01039278162);

--[5. soȸ������ : �ּ��Է�] -�ϼ�
create or replace procedure up_sjoin_address
(  
    pmaddress members.maddress%type
)
is 
begin

    update members
    set maddress =  pmaddress
    where maddress is null;
     commit;
end;
-->
execute up_sjoin_address('��⵵ ������ ��ź��');

--[6. soȸ������& ���α����� : �����ּҼ���] - �ϼ�
CREATE OR REPLACE VIEW MAINADDR_VIEW
( mid, mainaddr)
AS SELECT memberid , museaddress FROM members where museaddress is not null;

--select  distinct(mainaddr) from MAINADDR_VIEW;

begin
    DBMS_OUTPUT.PUT_LINE('�� �������');
    DBMS_OUTPUT.PUT_LINE('----------');
    for  vmainaddr in (select  distinct( mainaddr ) from mainaddr_view)
    loop
     DBMS_OUTPUT.PUT_LINE(vmainaddr.MAINADDR);
     end loop;           
end;

create or replace procedure up_sjoin_mainaddr
(  
    pmainaddr members.museaddress%type
)
is 
begin   
   
    update members
    set MUSEADDRESS =  pmainaddr
    where MUSEADDRESS is null;
end;
-->
exec up_sjoin_mainaddr('��õ�����');

--[soȸ������ : ���������� ] 
declare
  type rsomypage is record
  (
   mname members.mname%type
    , memail members.memail%type
    , mpwd members.mpwd%type
    , mtel members.mtel%type
    , maddress members.maddress%type
    ,museaddress members.museaddress%type 
  );
  vrec rsomypage;
  cursor spage_cursor 
      is (select mname,memail,mpwd,mtel,maddress,museaddress from members where memberid ='7');
begin
     open spage_cursor;
     loop
        fetch spage_cursor into vrec;
        dbms_output.put_line( '-----------����������----------' );
        dbms_output.put_line( '�̸� : '|| vrec.mname );
        dbms_output.put_line( '�̸��� : '|| vrec.memail );
        dbms_output.put_line( '��й�ȣ : '|| vrec.mpwd );
        dbms_output.put_line( '�޴�����ȣ : '|| vrec.mtel );
        dbms_output.put_line( '�ּ� : '|| vrec.maddress );
        dbms_output.put_line( '�ֻ������ : '|| vrec.museaddress );
     exit when spage_cursor%rowcount = 1;
     end loop;
     close spage_cursor;
end; 




---------------------------*******���α�����*****************------------------------------
--[���α����� :������ �ߺ�üũ ]-�Ϸ�
create or replace procedure up_bnameck
(  
     pbname members.bname%type
     ,pbnameck out varchar2
)
is 
begin
    select count(*)
        into pbnameck
    from bmanager
    where bmbname = pbname;
end;

var bnameck varchar2;
begin
     up_bnameck('�ѱ�����������',:bnameck );
    
    if :bnameck = 1  then 
        dbms_output.put_line('���� ��ȸ �Ϸ�');
    elsif :bnameck = 0 then
        dbms_output.put_line('�ش�����ڰ� �������� �����Ƿ� ������ �Ұ����մϴ�.');
    end if;
end;


--[���α����� : ȸ������] -�Ϸ�
create or replace procedure up_bjoin
(   pmid members.memberid%type
    ,pbname members.bname%type 
    , pmname members.mname%type
    , pmemail members.memail%type
    , pmpwd members.mpwd%type
    , prempwd members.mpwd%type
    , pmtel members.mtel%type
    , pmaddress members.maddress%type
   -- , pmuseaddress members.museaddress%type 
)
is  
    vpwd varchar2(50);
begin
     if pmpwd = prempwd then  vpwd := pmpwd;
     else 
     dbms_output.put_line('��й�ȣ�� ���� �ʽ��ϴ�.');
     end if; 
     
     insert into members(memberid,bname,mname,memail,mpwd,mtel,maddress) 
     values(pmid,pbname, pmname,pmemail,vpwd,pmtel, pmaddress);
end;
-->
exec up_bjoin(seq_join.nextval,'�ѱ�����������','����','by23156@naver.com','123456','123456',01029771931,'��⵵ ������ ���뱸');


--[ȸ������ Ʈ���Ż���]
create or replace trigger trg_mdiv
after insert 
ON members
declare
begin
 
    update members
    set mdiv = 'soȸ��'
    where bname is null;
end;
---------------------------------************���ΰ�����********-----------------------

--[���ΰ����� : member ���̺��� ȸ������] Ʈ���� 
create or replace trigger trg_memdiv
after insert 
ON bmanager
declare
    vbmbn bmanager.bmbname%type;
    vbname members.bname%type;
    vmdiv members.mdiv%type;
begin
     select m.memberid, b.bmbname, m.bname
       into vmdiv,vbmbn,vbname 
    from members m join bmanager b on b.memberid = m.memberid
    where b.bmbname = m.bname;
    
    if vbmbn = vbname then
    update members
    set mdiv = '���ΰ�����' 
    where bname is not null and (vbmbn = vbname) ;
    
    update bmanager
    set memberid = vmdiv
    where vbmbn = vbname;
    end if;
end;

--[���ΰ����� : ����� ��Ϲ�ȣ �ߺ���ȸ & ȸ�� ȸ������]
create or replace procedure up_bjoin_manager
(  
    pbid bmanager.businessid%type
    ,pbnum bmanager.bnumber%type
    ,pceoname bmanager.ceoname%type
    ,pbcon bmanager.bcon%type
    ,pbtype bmanager.btype%type
    ,pbmbname bmanager.bmbname%type    
)
is 
 vbnumck number;
 vmemdiv varchar2(20):= 'n/y';
begin
    select count(*)
        into  vbnumck
    from bmanager
    where bnumber = pbnum;
        
  if vbnumck = 1 then 
        dbms_output.put_line('�ߺ��� ����ڵ�Ϲ�ȣ�Դϴ�.');
    else
    insert into bmanager (businessid,bnumber,ceoname,bcon,btype,bmbname) values (pbid,pbnum,pceoname,pbcon,pbtype,pbmbname);
    end if;
end;

execute up_bjoin_manager(seq_bmanager.nextval, 2315122214,'�����','�Ϲ�������','������','��������');


create sequence seq_bmanager
increment by 1
start with 2;
-->����
begin
    if vnameck = pbname  then
    insert into members values(membersid.seq_join.nextval, pmname,pmemail,pmpwd,pmtel
                                ,pmaddress,pmuseaddress,pbname,pmdiv);
                                commit;
    else  dbms_output.put_line('�ش�����ڰ� �����Ƿ� ������ �� �����ϴ�.');
    end if;
end;




--[����ī�� : ����ī�� �ߺ�Ȯ�� & �߰�]
create or replace procedure up_add_bcard
(   pcid in card.cardid%type
     ,pcnumber in card.cnumber%type := :CNUM
    , pcardexpiry_mm  in card.cardexpiry%type 
    , pcardexpiry_yy in card.cardexpiry%type
    , pcpwd in card.cpwd%type
    ,pCCORPNUMBER card.CCORPNUMBER%type
)
is
    vnumber number(1); 
    vcardexpiry card.cardexpiry%type;
begin
   select count(*) into vnumber  
   from card
   where cnumber = pcnumber;
   
   vcardexpiry := pcardexpiry_mm || '/' || pcardexpiry_yy;
    if vnumber = 1 then  
        dbms_output.put_line('�̹� ��ϵ� ī���ȣ �Դϴ�.');
    elsif vnumber = 0 then
        insert into card(cardid, cnumber, cardexpiry, cpwd, CCORPNUMBER)
        values (pcid, pcnumber, vcardexpiry, pcpwd, pCCORPNUMBER);
        commit;
   dbms_output.put_line('ī������ �Ϸ� �Ǿ����ϴ�.');
   end if;
 
end;
-->
exec up_add_percard( seq_card.nextval,'8759-7422-9721-2341', '2020','01', 35,'532-97-46212');
--
-- [����ī�� : ����ī�� �ߺ�Ȯ�� & �߰�]
create or replace procedure up_add_percard
(   pcid in card.cardid%type
     ,pcnumber in card.cnumber%type
    , pcardexpiry_mm  in card.cardexpiry%type
    , pcardexpiry_yy in card.cardexpiry%type
    , pcpwd in card.cpwd%type
    , pcbirth in card.cbirth%type
    , pcnickname in card.cnickname%type
)
is
    vnumber number(1); 
    vcardexpiry card.cardexpiry%type;
begin
   select count(*) into vnumber  
   from card
   where cnumber = pcnumber;
   
   vcardexpiry := pcardexpiry_mm || '/' || pcardexpiry_yy;
    if vnumber = 1 then  
        dbms_output.put_line('�̹� ��ϵ� ī���ȣ �Դϴ�.');
    elsif vnumber = 0 then
        insert into card(cardid, cnumber, cardexpiry, cpwd, cbirth, cnickname)
        values (pcid, pcnumber, vcardexpiry, pcpwd, pcbirth, pcnickname);
        commit;
   dbms_output.put_line('ī������ �Ϸ� �Ǿ����ϴ�.');
   end if;
 
end;
-->
exec up_add_percard( seq_card.nextval,'1234-5678-9012-3456', '2020','01', 35,'791021', '��������');

--ī������� ����
create sequence seq_card
increment by 1
start with 6;







-------------------------------------******��������******-----------------------------
create sequence seq_dl
increment by 1
start with 6;


--[1. ����������:  Ÿ����� & insert] -�ϼ�
CREATE OR REPLACE VIEW dltype_VIEW
( dltype )
AS SELECT dltype FROM dlicense;

begin
    DBMS_OUTPUT.PUT_LINE('�����ϼ���');
    DBMS_OUTPUT.PUT_LINE('----------');
    for  vdltype in (select  distinct( dltype ) from dltype_view)
    loop
     DBMS_OUTPUT.PUT_LINE(vdltype.dltype);
     end loop;           
exception
 when others 
 then  dbms_output.put_line('���� ��ȣ�׸��� �ʼ� �����Դϴ�.');  
end;

-->����Ÿ��
create or replace procedure up_dltype_insert
(
    pdlid dlicense.dlid%type
  ,pdltype dlicense.dltype%type
)
is 
begin
     insert into dlicense (dlid , dltype) values (pdlid,pdltype);
     commit;
exception
    when others 
    then  dbms_output.put_line('���� ��ȣ�׸��� �ʼ� �����Դϴ�.');  

end;
-->
exec up_dltype_insert(seq_dl.nextval,'1�� ����');

---
-- [2. ���������� ������� & insert] -�ϼ�
CREATE OR REPLACE VIEW localnum_VIEW
AS SELECT localnum FROM dlicense;

--select distinct(localnum) from localnum_VIEW order by localnum ;
begin
    DBMS_OUTPUT.PUT_LINE('����');
    DBMS_OUTPUT.PUT_LINE('----------');
    for vlocalnum in (select  distinct( localnum ) from localnum_view order by localnum)
    loop
     DBMS_OUTPUT.PUT_LINE(vlocalnum.localnum);
     end loop;           
end;
--��
create or replace procedure up_dllocal_insert
(
  plocalnum dlicense.localnum%type
)
is 
begin
      update dlicense
    set localnum =  plocalnum
    where localnum is null;
     commit;
exception
    when others then DBMS_OUTPUT.PUT_LINE('�ݵ�� �Է�!!');
end;
-->��
exec  up_dllocal_insert(13);
---
--[3. ���������ȣ �Է�] -�ϼ�

create or replace procedure up_dlnum_insert
(
    pdlnum dlicense.dlnum%type
)
is
    vlocalnum dlicense.localnum%type;
begin
   select localnum
         into vlocalnum
   from dlicense
   where dlnum is null;
   
     update dlicense
    set dlnum =  pdlnum
    where dlnum is null;
   commit;
   
    dbms_output.put_line(vlocalnum ||' ' || pdlnum);  
exception
 when others then 
  dbms_output.put_line('���� ��ȣ�׸��� �ʼ� �����Դϴ�.');  
    dbms_output.put_line('���� ��ȣ�� �����ּ���.');  

end;
-->
exec up_dlnum_insert(3708378912);

--
-- [4. �������� ��� : ������� �Է�] -�ϼ�
create or replace procedure up_dlbirth_insert
(
    pdssn dlicense.dssn%type
)
is
begin
  
     update dlicense
    set dssn =  pdssn
    where dssn is null;
   commit;
exception 
    when others then 
    dbms_output.put_line('�ֹε�Ϲ�ȣ �� 6�ڸ��׸��� �ʼ� �����Դϴ�.');  
     dbms_output.put_line('�ֹε�Ϲ�ȣ �� 1�ڸ��׸��� �ʼ� �����Դϴ�.');  
      dbms_output.put_line('�ֹε�Ϲ�ȣ �� 6�ڸ��� 1�ڸ��� �Է����ּ���.');  
end;
-->
exec up_dlbirth_insert(93122122);





-- [4. �������� ��� : ������ ����] -�Ϸ�

--���(�⵵)
declare 
    issue number(4) := 2018;
    expiry number(4);
begin 
--> ������
    DBMS_OUTPUT.PUT_LINE('��');
    for vy in (select y from y where y<=issue)
    loop
    DBMS_OUTPUT.PUT_LINE(vy.y);
    end loop;
end;

--���(��)
declare
  vmonth y%rowtype;
  cursor m_list 
     is select * from y;
begin
   open m_list;
    dbms_output.put_line( '��'  );
   loop
     fetch m_list into vmonth;
     exit when m_list%notfound;  
     dbms_output.put_line( vmonth.m  );
   end loop;

   close m_list ;
end;


--���(��)
create or replace procedure up_day
( 
    pmonth number
)
is
   vend number :=30;
begin 
    DBMS_OUTPUT.PUT_LINE('��');
   if pmonth = 2 then vend :=28;
   elsif pmonth  in (1,3,5,7,8,10,12) then vend :=31;
   end if;

  for d in 1..vend  
  loop
  DBMS_OUTPUT.PUT_LINE(d);
  end loop;

end;


exec up_day(2);

-- ��
create or replace procedure up_dls_issue
(
    issuedate_y dlicense.issuedate%type
    ,issuedate_m dlicense.issuedate%type
    ,issuedate_d dlicense.issuedate%type
)
is
 vissue varchar2(20);
begin
    if issuedate_y  between 2009 and 2018 then
    vissue := issuedate_y || '/' || issuedate_m || '/' ||issuedate_d;
    update dlicense
    set issuedate = vissue
    where issuedate is null;
    else 
    DBMS_OUTPUT.PUT_LINE('�߸��� �����Դϴ�.');
    end if;
exception  
    when others
    then DBMS_OUTPUT.PUT_LINE('�߱� �����׸��� �ʼ������Դϴ�.');
    DBMS_OUTPUT.PUT_LINE('�߱� ���׸��� �ʼ������Դϴ�.');
    DBMS_OUTPUT.PUT_LINE('�߱� ���׸��� �ʼ������Դϴ�.');
    DBMS_OUTPUT.PUT_LINE('�߱� ���� �������ּ���.');
end;

exec up_dls_issue('2018','02','21');



--[5. �������� ������] -�Ϸ�
create or replace procedure up_dls_expiry
(
    expiry_y dlicense.issuedate%type
    ,expiry_m dlicense.issuedate%type
    ,expiry_d dlicense.issuedate%type
)
is
 vexpiry varchar2(20);
begin
    if expiry_y  between 2018 and 2028 then
    vexpiry := expiry_y || '/' || expiry_m || '/' ||expiry_d;
    update dlicense
    set expirydate = vexpiry
    where expirydate is null;
    else 
    DBMS_OUTPUT.PUT_LINE('�߸��� �����Դϴ�.');
    end if;
exception  
    when others
    then DBMS_OUTPUT.PUT_LINE('�߱� �����׸��� �ʼ������Դϴ�.');
    DBMS_OUTPUT.PUT_LINE('�߱� ���׸��� �ʼ������Դϴ�.');
    DBMS_OUTPUT.PUT_LINE('�߱� ���׸��� �ʼ������Դϴ�.');
    DBMS_OUTPUT.PUT_LINE('�߱� ���� �������ּ���.');
end;

exec up_dls_issue('2020','02','21');


--[6. �������� ���� ���] -�Ϸ�
declare
  type dllicense is record
  (
    dltype dlicense.dltype%type
    , localnum dlicense.localnum%type
    ,dlnum dlicense.dlnum%type
    , dssn  dlicense.dssn%type
    , issuedate  dlicense.issuedate%type
    , expirydate  dlicense.expirydate%type 
  );
  vrec dllicense;
  cursor dlinfo_cursor 
      is (select dltype, localnum,dlnum,dssn,issuedate, expirydate from dlicense where memberid ='members-1');
begin
     open dlinfo_cursor;
     loop
        fetch dlinfo_cursor  into vrec;
        dbms_output.put_line( '----------�������� �Է�----------' );
        dbms_output.put_line( '�������� : '|| vrec.dltype );
        dbms_output.put_line( '�������� : '|| vrec.localnum );
        dbms_output.put_line( '�����ȣ : '|| vrec.dlnum );
        dbms_output.put_line( '�ֹι�ȣ : '|| vrec.dssn );
        dbms_output.put_line( '������ : '|| vrec.issuedate );
        dbms_output.put_line( '�߱��� : '|| vrec.expirydate );
     exit when dlinfo_cursor%rowcount = 1;
     end loop;
     close dlinfo_cursor;
end; 

-----------------------------------*********����������*************-----------------------------

-- ���� ����������
declare
  type brsomypage is record
  (
    bnumber bmanager.bnumber%type
    , ceoname bmanager.ceoname%type
    , bcon bmanager.bcon%type
    , btype bmanager.btype%type
    , bmbname bmanager.bmbname%type 
  );
  vrec brsomypage;
  cursor spage_cursor 
      is (select bnumber,ceoname,bcon,btype,bmbname from bmanager where businessid ='bm-1');
begin
     open spage_cursor;
     loop
        fetch spage_cursor into vrec;
        dbms_output.put_line( '-----------����������----------' );
        dbms_output.put_line( '����ڵ�Ϲ�ȣ : '|| vrec.bnumber );
        dbms_output.put_line( '���ΰ������̸� : '|| vrec.ceoname );
        dbms_output.put_line( '���� : '|| vrec.bcon );
        dbms_output.put_line( '���� : '|| vrec.btype );
        dbms_output.put_line( '���θ� : '|| vrec.bmbname );
     exit when spage_cursor%rowcount = 1;
     end loop;
     close spage_cursor;
end; 

---

-- ���α����� ����������
declare
  type rsomypage is record
  (
   mname members.mname%type
    , memail members.memail%type
    , mpwd members.mpwd%type
    , mtel members.mtel%type
    , maddress members.maddress%type
    , museaddress members.museaddress%type 
    , bname members.bname%type
  );
  vrec rsomypage;
  cursor spage_cursor 
      is (select mname,memail,mpwd,mtel,maddress,museaddress, bname from members where memberid ='members-1');
begin
     open spage_cursor;
     loop
        fetch spage_cursor into vrec;
        dbms_output.put_line( '-----------����������----------' );
        dbms_output.put_line( '�̸� : '|| vrec.mname );
        dbms_output.put_line( '�̸��� : '|| vrec.memail );
        dbms_output.put_line( '��й�ȣ : '|| vrec.mpwd );
        dbms_output.put_line( '�޴�����ȣ : '|| vrec.mtel );
        dbms_output.put_line( '�ּ� : '|| vrec.maddress );
        dbms_output.put_line( '�ֻ������ : '|| vrec.museaddress );
        dbms_output.put_line( '���θ� : '|| vrec.bname );
     exit when spage_cursor%rowcount = 1;
     end loop;
     close spage_cursor;
end; 

----���̰����� ����������

-- ���� ����������
declare
  type brsomypage is record
  (
    bnumber bmanager.bnumber%type
    , ceoname bmanager.ceoname%type
    , memail members.memail%type
    , mpwd members.mpwd%type
    , mtel members.mtel%type
    , maddress members.maddress%type
    , bcon bmanager.bcon%type
    , btype bmanager.btype%type
    , bmbname bmanager.bmbname%type
  );
  vrec brsomypage;
  cursor bpage_cursor 
    is 
     (
     select bnumber, ceoname, memail, mpwd, mtel, maddress, bcon, btype, bmbname 
     from bmanager join members
     using (memberid)
     where memberid = 'members-37'
     );
begin
     open bpage_cursor;
     loop
        fetch bpage_cursor into vrec;
        dbms_output.put_line( '-----------����������----------' );
        dbms_output.put_line( '����ڵ�Ϲ�ȣ : '|| vrec.bnumber );
        dbms_output.put_line( '���ΰ������̸� : '|| vrec.ceoname );
        dbms_output.put_line( '�̸��� : '|| vrec.memail );
        dbms_output.put_line( '��й�ȣ : '|| vrec.mpwd );
        dbms_output.put_line( '�޴�����ȣ : '|| vrec.mtel );
        dbms_output.put_line( '�ּ� : '|| vrec.maddress );
        dbms_output.put_line( '���� : '|| vrec.bcon );
        dbms_output.put_line( '���� : '|| vrec.btype );
        dbms_output.put_line( '���θ� : '|| vrec.bmbname );
     exit when bpage_cursor%rowcount = 1;
     end loop;
     close bpage_cursor;
end; 





--[��] �� �뿩�� ��� -�ϼ�
create or replace procedure up_booking_oneway
(
    pzaddress zone.zaddress%type
)
is
begin
    for zone_cur in
    (
    select zname,zaddress
    from zone
    where zaddress like '%����%'
    )
    loop
    dbms_output.put_line(zone_cur.zname);
    end loop;
end;
-->
exec up_booking_oneway('����');


-------- [��]
-- �뿩���� ���￪ 2���ⱸ�� ���� ������ �ݳ��� �� ����Ʈ 11�� �߰��ϴ� ����

create or replace procedure up_list_returnzonezname
(
    pzname zone.zname%type
)
is  
begin
    for vzcur in (
    select ZONE.zname as z1, RETURNZONE.returnzone as z2, ZONE.zoneid as z3, RETURNZONE.zoneid as z4
    from ZONE,RETURNZONE
    where ZONE.zoneid  = RETURNZONE.returnzone  
    and RETURNZONE.zoneid = ( select ZONE.zoneid
    from ZONE
    where ZONE.zname = '���￪ 2���ⱸ')
    )
    loop
    dbms_output.put_line(vzcur.z1);
    end loop;
end;

exec up_list_returnzonezname('���￪ 2���ⱸ');


--[��ȣȭ ******] �Ϸ�

--------------------------*************����************--------------


--[1. ���� : ����] 
create or replace procedure up_socar_plan
(
    ds in number,
    dl in number,
    hs in number,
    hl in number,
    ms in number,
    ml in number,
    stime out date,
    ltime out date
)
is
    ntime date := sysdate;
begin
            stime := ntime + (ms + (hs*60) + (ds*1440))/24/60;
            ltime := stime + (ml + (hl*60) + (dl*1440))/24/60;
--exception
commit;
end;


declare
    sel varchar2(10);
    ds number := :sday;
    dl number := :lday;
    hs number := :shour;
    hl number := :lhour;
    ms number := :sminit;
    ml number := :lminit;
    stime date;
    ltime date;
begin  
    
    dbms_output.put_line( '[ �պ�����' || ' ' || '������ ]' );
    sel := :a;
    dbms_output.put_line ( sel );
    dbms_output.put_line( '[ '|| to_char( sysdate, 'hh24:mi day MM/DD') ||'   '|| to_char( sysdate+1, 'hh24:mi day MM/DD') || ' ]');
    -- dbms_output.put_line ( vs || '  ' ||  vl );
    up_socar_plan( ds, dl, hs, hl, ms, ml, stime, ltime );
    -- dbms_output.put_line( round((stime-ltime)*1440) );
    dbms_output.put_line( to_char( stime, 'hh24:mi day MM/DD') || '   ' || to_char( ltime, 'hh24:mi day MM/DD') );
    dbms_output.put_line( ' �� ' || '  ' || round(((ltime-stime)*1440)/60/24) || '��' || '  ' || 
                                                round((((ltime-stime)*1440)/60/24-round(((ltime-stime)*1440)/60/24))*24) || '�ð�' || '  ' ||
                                                round((((((ltime-stime)*1440)/60/24-round(((ltime-stime)*1440)/60/24))*24)-round((((ltime-stime)*1440)/60/24-round(((ltime-stime)*1440)/60/24))*24))*60) || '��'
                                                || ' ��� ');
                                                
end;


--[2. ���� : �뿩��� & ����� ]

-- 
create or replace procedure up_socar_pay
(
   pacartype in cartype.acartype%type,
   pmodelname in carmodel.modelname%type,
   pfuelname in fueltype.fuelname%type,
   pinsuran in varchar,
   pinsurfee out insurance.five%type,
   pweekdays out fee.weekdays%type,
   pdistance out fee.distance%type
)
is
   vsdiv season.sdiv%type;
begin
    if( 5 < to_char(sysdate, 'MM') and to_char(sysdate, 'MM') < 9 ) then
        select sdiv
            into vsdiv
        from season
        where sdiv = '������';
    else vsdiv := '�����';
    end if;
    
    if ( pinsuran = '5����' ) then 
        select i.five
            into pinsurfee
        from insurance i join cartype c on c.ctid = i.ctid
        where c.acartype = pacartype;
    elsif (  pinsuran = '30����' ) then
        select i.thirty
            into pinsurfee
        from insurance i join cartype c on c.ctid = i.ctid
        where c.acartype = pacartype;
    elsif  (  pinsuran = '70����' ) then
        select i.seventy
            into pinsurfee
        from insurance i join cartype c on c.ctid = i.ctid
        where c.acartype = pacartype;
    end if;
    
    select f.weekdays, f.distance
        into pweekdays, pdistance
    from fee f join carmodel m on f.cmid = m.cmid
               join fueltype l on m.fuelid = l.fuelid
               join cartype c on c.ctid = l.ctid
               join season s on s.seasonid = f.seasonid
    where c.acartype = pacartype and m.modelname = pmodelname and l.fuelname = pfuelname and s.sdiv = vsdiv;
--exception
commit;
end;






declare
    vinsurancefee number;
    vrentalfee number;
    vdistance fee.distance%type;
    vacartype cartype.acartype%type:= :cartype;
    vmodelname carmodel.modelname%type:= :modelname;
    vfuelname fueltype.fuelname%type:= :fuelname;
    vinsur varchar2(10) := :insurance;
    vtotMony number;
begin
    up_socar_pay ( vacartype, vmodelname, vfuelname, vinsur, vinsurancefee, vrentalfee, vdistance ); 
    dbms_output.put_line( '�뿩���' || to_char(vrentalfee, '9g999g999') || '��' );
    dbms_output.put_line( '�ڱ�δ��  70����  30����  5����' );
    dbms_output.put_line( '�����' || '     ' || vinsurancefee || '��' );
    dbms_output.put_line( '����       ����  T�����  ������' );
    vtotMony := vrentalfee + vinsurancefee;
    dbms_output.put_line( '�������' || to_char(vtotMony, '9g999g999') || '��' );
    dbms_output.put_line( '������' || '   ' || vdistance || '��/km' || '.�ݳ� �� ��������' );
    --dbms_output.put_line( '����ī��' || ī���|| 'ī��' || '(' || to_date(sysdate, 'RRRR.MM.DD') || ')' );
end;













-----------------***********-������-***************---------------


-- ������ ���ֹ������� ���������� Ÿ��Ʋ 7�� �ߴ°�
create or replace procedure up_list_CSCUSUALLYASK
(
    pCDNAME CSCENTERDIV.cdname%type
)
is
begin
for vCScur in(
   select ctitle    
    from CSCENTER
    where CSCENTER.cdid = 
    (   select cdid
        from CSCENTERDIV
        where cdname = '���ֹ�������' 
    )
    )
    loop
    dbms_output.put_line(vCScur.ctitle);
    end loop;
end;

exec up_list_CSCUSUALLYASK('���ֹ�������');


---


CREATE OR REPLACE PACKAGE CryptIT AS 
   FUNCTION encrypt( str VARCHAR2,  
                     hash VARCHAR2 ) RETURN VARCHAR2;
   FUNCTION decrypt( xCrypt VARCHAR2,
                     hash VARCHAR2 ) RETURN VARCHAR2;
END CryptIT;
/

-- ��Ű�� ��ü
CREATE OR REPLACE PACKAGE BODY CryptIT IS 
   crypted_string VARCHAR2(2000);
 
   FUNCTION encrypt(str VARCHAR2, hash VARCHAR2)
   RETURN VARCHAR2
   IS
       pieces_of_eight NUMBER := ((FLOOR(LENGTH(str)/8 + .9)) * 8);
    BEGIN
       dbms_obfuscation_toolkit.DESEncrypt(
               input_string     => RPAD(str, pieces_of_eight ),
               key_string       => RPAD(hash,8,'#'), 
               encrypted_string => crypted_string );

      RETURN crypted_string;
   END;
 
   FUNCTION decrypt( xCrypt VARCHAR2, hash VARCHAR2 )
   RETURN VARCHAR2 IS
   BEGIN
      dbms_obfuscation_toolkit.DESDecrypt(
               input_string     => xCrypt, 
               key_string       => RPAD(hash,8,'#'), 
               decrypted_string => crypted_string );

      RETURN TRIM(crypted_string);
   END;
END CryptIT;