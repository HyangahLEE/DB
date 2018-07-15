
--[로그인]

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
        dbms_output.put_line('아이디가 없습니다.');
    elsif :vresults = 0 then
        dbms_output.put_line('비밀번호가 틀렸습니다.');
    elsif :vresults = 1 then
        dbms_output.put_line('로그인 되었습니다.');
    end if;
end;
---------------------------------------------------------------------------->>로그인 완료
create sequence SEQ_join        
increment by 1
start with 6;
--*회원가입 시퀀스 1*


--[1.so회원가입 : 이름] --완료
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
exec up_sjoin_name('신세계');
--
--[2. so회원가입 : 이메일] --완료
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
        dbms_output.put_line('중복된 아이디입니다.');
    else
    update members
    set memail =  pmemail
    where memail is null;
    commit;
    end if;
    
end;
-->
execute up_sjoin_email('gywn888@gmail.com');



--[3. so회원가입 : 비밀번호] --완료  > 암호화 했음
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



--[4. so회원가입 : 휴대폰번호] -- 완성
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

--[5. so회원가입 : 주소입력] -완성
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
execute up_sjoin_address('경기도 수원시 매탄동');

--[6. so회원가입& 법인구성원 : 메인주소선택] - 완성
CREATE OR REPLACE VIEW MAINADDR_VIEW
( mid, mainaddr)
AS SELECT memberid , museaddress FROM members where museaddress is not null;

--select  distinct(mainaddr) from MAINADDR_VIEW;

begin
    DBMS_OUTPUT.PUT_LINE('주 사용지역');
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
exec up_sjoin_mainaddr('인천·경기');

--[so회원가입 : 마이페이지 ] 
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
        dbms_output.put_line( '-----------마이페이지----------' );
        dbms_output.put_line( '이름 : '|| vrec.mname );
        dbms_output.put_line( '이메일 : '|| vrec.memail );
        dbms_output.put_line( '비밀번호 : '|| vrec.mpwd );
        dbms_output.put_line( '휴대폰번호 : '|| vrec.mtel );
        dbms_output.put_line( '주소 : '|| vrec.maddress );
        dbms_output.put_line( '주사용지역 : '|| vrec.museaddress );
     exit when spage_cursor%rowcount = 1;
     end loop;
     close spage_cursor;
end; 




---------------------------*******법인구성원*****************------------------------------
--[법인구성원 :관리자 중복체크 ]-완료
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
     up_bnameck('한국가정음식점',:bnameck );
    
    if :bnameck = 1  then 
        dbms_output.put_line('법인 조회 완료');
    elsif :bnameck = 0 then
        dbms_output.put_line('해당관리자가 존재하지 않으므로 가입이 불가능합니다.');
    end if;
end;


--[법인구성원 : 회원가입] -완료
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
     dbms_output.put_line('비밀번호가 맞지 않습니다.');
     end if; 
     
     insert into members(memberid,bname,mname,memail,mpwd,mtel,maddress) 
     values(pmid,pbname, pmname,pmemail,vpwd,pmtel, pmaddress);
end;
-->
exec up_bjoin(seq_join.nextval,'한국가정음식점','김사랑','by23156@naver.com','123456','123456',01029771931,'경기도 수원시 영통구');


--[회원구분 트리거생성]
create or replace trigger trg_mdiv
after insert 
ON members
declare
begin
 
    update members
    set mdiv = 'so회원'
    where bname is null;
end;
---------------------------------************법인관리자********-----------------------

--[법인관리자 : member 테이블의 회원구분] 트리거 
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
    set mdiv = '법인관리자' 
    where bname is not null and (vbmbn = vbname) ;
    
    update bmanager
    set memberid = vmdiv
    where vbmbn = vbname;
    end if;
end;

--[법인관리자 : 사업자 등록번호 중복조회 & 회사 회원가입]
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
        dbms_output.put_line('중복된 사업자등록번호입니다.');
    else
    insert into bmanager (businessid,bnumber,ceoname,bcon,btype,bmbname) values (pbid,pbnum,pceoname,pbcon,pbtype,pbmbname);
    end if;
end;

execute up_bjoin_manager(seq_bmanager.nextval, 2315122214,'김수라','일반음식점','음식점','쿠쿠코코');


create sequence seq_bmanager
increment by 1
start with 2;
-->실행
begin
    if vnameck = pbname  then
    insert into members values(membersid.seq_join.nextval, pmname,pmemail,pmpwd,pmtel
                                ,pmaddress,pmuseaddress,pbname,pmdiv);
                                commit;
    else  dbms_output.put_line('해당관리자가 없으므로 가입할 수 없습니다.');
    end if;
end;




--[결제카드 : 법인카드 중복확인 & 추가]
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
        dbms_output.put_line('이미 등록된 카드번호 입니다.');
    elsif vnumber = 0 then
        insert into card(cardid, cnumber, cardexpiry, cpwd, CCORPNUMBER)
        values (pcid, pcnumber, vcardexpiry, pcpwd, pCCORPNUMBER);
        commit;
   dbms_output.put_line('카드등록이 완료 되었습니다.');
   end if;
 
end;
-->
exec up_add_percard( seq_card.nextval,'8759-7422-9721-2341', '2020','01', 35,'532-97-46212');
--
-- [결제카드 : 개인카드 중복확인 & 추가]
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
        dbms_output.put_line('이미 등록된 카드번호 입니다.');
    elsif vnumber = 0 then
        insert into card(cardid, cnumber, cardexpiry, cpwd, cbirth, cnickname)
        values (pcid, pcnumber, vcardexpiry, pcpwd, pcbirth, pcnickname);
        commit;
   dbms_output.put_line('카드등록이 완료 되었습니다.');
   end if;
 
end;
-->
exec up_add_percard( seq_card.nextval,'1234-5678-9012-3456', '2020','01', 35,'791021', '하하하하');

--카드시퀀스 생성
create sequence seq_card
increment by 1
start with 6;







-------------------------------------******운전면허******-----------------------------
create sequence seq_dl
increment by 1
start with 6;


--[1. 운전면허증:  타입출력 & insert] -완성
CREATE OR REPLACE VIEW dltype_VIEW
( dltype )
AS SELECT dltype FROM dlicense;

begin
    DBMS_OUTPUT.PUT_LINE('선택하세요');
    DBMS_OUTPUT.PUT_LINE('----------');
    for  vdltype in (select  distinct( dltype ) from dltype_view)
    loop
     DBMS_OUTPUT.PUT_LINE(vdltype.dltype);
     end loop;           
exception
 when others 
 then  dbms_output.put_line('면허 번호항목은 필수 정보입니다.');  
end;

-->면허타입
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
    then  dbms_output.put_line('면허 번호항목은 필수 정보입니다.');  

end;
-->
exec up_dltype_insert(seq_dl.nextval,'1종 대형');

---
-- [2. 운전면허증 숫자출력 & insert] -완성
CREATE OR REPLACE VIEW localnum_VIEW
AS SELECT localnum FROM dlicense;

--select distinct(localnum) from localnum_VIEW order by localnum ;
begin
    DBMS_OUTPUT.PUT_LINE('숫자');
    DBMS_OUTPUT.PUT_LINE('----------');
    for vlocalnum in (select  distinct( localnum ) from localnum_view order by localnum)
    loop
     DBMS_OUTPUT.PUT_LINE(vlocalnum.localnum);
     end loop;           
end;
--ㅍ
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
    when others then DBMS_OUTPUT.PUT_LINE('반드시 입력!!');
end;
-->ㅅ
exec  up_dllocal_insert(13);
---
--[3. 운전면허번호 입력] -완성

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
  dbms_output.put_line('면허 번호항목은 필수 정보입니다.');  
    dbms_output.put_line('면허 번호를 적어주세요.');  

end;
-->
exec up_dlnum_insert(3708378912);

--
-- [4. 운전면허 등록 : 생년월일 입력] -완성
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
    dbms_output.put_line('주민등록번호 앞 6자리항목은 필수 정보입니다.');  
     dbms_output.put_line('주민등록번호 뒤 1자리항목은 필수 정보입니다.');  
      dbms_output.put_line('주민등록번호 앞 6자리와 1자리를 입력해주세요.');  
end;
-->
exec up_dlbirth_insert(93122122);





-- [4. 운전면허 등록 : 갱신일 선택] -완료

--출력(년도)
declare 
    issue number(4) := 2018;
    expiry number(4);
begin 
--> 발행일
    DBMS_OUTPUT.PUT_LINE('년');
    for vy in (select y from y where y<=issue)
    loop
    DBMS_OUTPUT.PUT_LINE(vy.y);
    end loop;
end;

--출력(월)
declare
  vmonth y%rowtype;
  cursor m_list 
     is select * from y;
begin
   open m_list;
    dbms_output.put_line( '월'  );
   loop
     fetch m_list into vmonth;
     exit when m_list%notfound;  
     dbms_output.put_line( vmonth.m  );
   end loop;

   close m_list ;
end;


--출력(일)
create or replace procedure up_day
( 
    pmonth number
)
is
   vend number :=30;
begin 
    DBMS_OUTPUT.PUT_LINE('월');
   if pmonth = 2 then vend :=28;
   elsif pmonth  in (1,3,5,7,8,10,12) then vend :=31;
   end if;

  for d in 1..vend  
  loop
  DBMS_OUTPUT.PUT_LINE(d);
  end loop;

end;


exec up_day(2);

-- ㅍ
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
    DBMS_OUTPUT.PUT_LINE('잘못된 정보입니다.');
    end if;
exception  
    when others
    then DBMS_OUTPUT.PUT_LINE('발급 연도항목은 필수정보입니다.');
    DBMS_OUTPUT.PUT_LINE('발급 월항목은 필수정보입니다.');
    DBMS_OUTPUT.PUT_LINE('발급 일항목은 필수정보입니다.');
    DBMS_OUTPUT.PUT_LINE('발급 일을 선택해주세요.');
end;

exec up_dls_issue('2018','02','21');



--[5. 운전면허 갱신일] -완료
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
    DBMS_OUTPUT.PUT_LINE('잘못된 정보입니다.');
    end if;
exception  
    when others
    then DBMS_OUTPUT.PUT_LINE('발급 연도항목은 필수정보입니다.');
    DBMS_OUTPUT.PUT_LINE('발급 월항목은 필수정보입니다.');
    DBMS_OUTPUT.PUT_LINE('발급 일항목은 필수정보입니다.');
    DBMS_OUTPUT.PUT_LINE('발급 일을 선택해주세요.');
end;

exec up_dls_issue('2020','02','21');


--[6. 운전면허 정보 출력] -완료
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
        dbms_output.put_line( '----------면허정보 입력----------' );
        dbms_output.put_line( '면허종류 : '|| vrec.dltype );
        dbms_output.put_line( '지역숫자 : '|| vrec.localnum );
        dbms_output.put_line( '면허번호 : '|| vrec.dlnum );
        dbms_output.put_line( '주민번호 : '|| vrec.dssn );
        dbms_output.put_line( '갱신일 : '|| vrec.issuedate );
        dbms_output.put_line( '발급일 : '|| vrec.expirydate );
     exit when dlinfo_cursor%rowcount = 1;
     end loop;
     close dlinfo_cursor;
end; 

-----------------------------------*********마이페이지*************-----------------------------

-- 법인 마이페이지
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
        dbms_output.put_line( '-----------마이페이지----------' );
        dbms_output.put_line( '사업자등록번호 : '|| vrec.bnumber );
        dbms_output.put_line( '법인관리자이름 : '|| vrec.ceoname );
        dbms_output.put_line( '업태 : '|| vrec.bcon );
        dbms_output.put_line( '업종 : '|| vrec.btype );
        dbms_output.put_line( '법인명 : '|| vrec.bmbname );
     exit when spage_cursor%rowcount = 1;
     end loop;
     close spage_cursor;
end; 

---

-- 법인구성원 마이페이지
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
        dbms_output.put_line( '-----------마이페이지----------' );
        dbms_output.put_line( '이름 : '|| vrec.mname );
        dbms_output.put_line( '이메일 : '|| vrec.memail );
        dbms_output.put_line( '비밀번호 : '|| vrec.mpwd );
        dbms_output.put_line( '휴대폰번호 : '|| vrec.mtel );
        dbms_output.put_line( '주소 : '|| vrec.maddress );
        dbms_output.put_line( '주사용지역 : '|| vrec.museaddress );
        dbms_output.put_line( '법인명 : '|| vrec.bname );
     exit when spage_cursor%rowcount = 1;
     end loop;
     close spage_cursor;
end; 

----법이관리자 마이페이지

-- 법인 마이페이지
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
        dbms_output.put_line( '-----------마이페이지----------' );
        dbms_output.put_line( '사업자등록번호 : '|| vrec.bnumber );
        dbms_output.put_line( '법인관리자이름 : '|| vrec.ceoname );
        dbms_output.put_line( '이메일 : '|| vrec.memail );
        dbms_output.put_line( '비밀번호 : '|| vrec.mpwd );
        dbms_output.put_line( '휴대폰번호 : '|| vrec.mtel );
        dbms_output.put_line( '주소 : '|| vrec.maddress );
        dbms_output.put_line( '업태 : '|| vrec.bcon );
        dbms_output.put_line( '업종 : '|| vrec.btype );
        dbms_output.put_line( '법인명 : '|| vrec.bmbname );
     exit when bpage_cursor%rowcount = 1;
     end loop;
     close bpage_cursor;
end; 





--[편도] 편도 대여존 출력 -완성
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
    where zaddress like '%역삼%'
    )
    loop
    dbms_output.put_line(zone_cur.zname);
    end loop;
end;
-->
exec up_booking_oneway('역삼');


-------- [편도]
-- 대여존에 역삼역 2번출구를 선택 했을때 반납존 에 리스트 11개 뜨게하는 쿼리

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
    where ZONE.zname = '역삼역 2번출구')
    )
    loop
    dbms_output.put_line(vzcur.z1);
    end loop;
end;

exec up_list_returnzonezname('역삼역 2번출구');


--[암호화 ******] 완료

--------------------------*************예약************--------------


--[1. 예약 : 여정] 
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
    
    dbms_output.put_line( '[ 왕복예약' || ' ' || '편도예약 ]' );
    sel := :a;
    dbms_output.put_line ( sel );
    dbms_output.put_line( '[ '|| to_char( sysdate, 'hh24:mi day MM/DD') ||'   '|| to_char( sysdate+1, 'hh24:mi day MM/DD') || ' ]');
    -- dbms_output.put_line ( vs || '  ' ||  vl );
    up_socar_plan( ds, dl, hs, hl, ms, ml, stime, ltime );
    -- dbms_output.put_line( round((stime-ltime)*1440) );
    dbms_output.put_line( to_char( stime, 'hh24:mi day MM/DD') || '   ' || to_char( ltime, 'hh24:mi day MM/DD') );
    dbms_output.put_line( ' 총 ' || '  ' || round(((ltime-stime)*1440)/60/24) || '일' || '  ' || 
                                                round((((ltime-stime)*1440)/60/24-round(((ltime-stime)*1440)/60/24))*24) || '시간' || '  ' ||
                                                round((((((ltime-stime)*1440)/60/24-round(((ltime-stime)*1440)/60/24))*24)-round((((ltime-stime)*1440)/60/24-round(((ltime-stime)*1440)/60/24))*24))*60) || '분'
                                                || ' 사용 ');
                                                
end;


--[2. 예약 : 대여요금 & 보험료 ]

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
        where sdiv = '성수기';
    else vsdiv := '비수기';
    end if;
    
    if ( pinsuran = '5만원' ) then 
        select i.five
            into pinsurfee
        from insurance i join cartype c on c.ctid = i.ctid
        where c.acartype = pacartype;
    elsif (  pinsuran = '30만원' ) then
        select i.thirty
            into pinsurfee
        from insurance i join cartype c on c.ctid = i.ctid
        where c.acartype = pacartype;
    elsif  (  pinsuran = '70만원' ) then
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
    dbms_output.put_line( '대여요금' || to_char(vrentalfee, '9g999g999') || '원' );
    dbms_output.put_line( '자기부담금  70만원  30만원  5만원' );
    dbms_output.put_line( '보험료' || '     ' || vinsurancefee || '원' );
    dbms_output.put_line( '할인       쿠폰  T멤버십  미적용' );
    vtotMony := vrentalfee + vinsurancefee;
    dbms_output.put_line( '결제요금' || to_char(vtotMony, '9g999g999') || '원' );
    dbms_output.put_line( '주행요금' || '   ' || vdistance || '원/km' || '.반납 후 별도결제' );
    --dbms_output.put_line( '결제카드' || 카드사|| '카드' || '(' || to_date(sysdate, 'RRRR.MM.DD') || ')' );
end;













-----------------***********-고객센터-***************---------------


-- 고객센터 자주묻는질문 선택했을때 타이틀 7개 뜨는거
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
        where cdname = '자주묻는질문' 
    )
    )
    loop
    dbms_output.put_line(vCScur.ctitle);
    end loop;
end;

exec up_list_CSCUSUALLYASK('자주묻는질문');


---


CREATE OR REPLACE PACKAGE CryptIT AS 
   FUNCTION encrypt( str VARCHAR2,  
                     hash VARCHAR2 ) RETURN VARCHAR2;
   FUNCTION decrypt( xCrypt VARCHAR2,
                     hash VARCHAR2 ) RETURN VARCHAR2;
END CryptIT;
/

-- 패키지 몸체
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