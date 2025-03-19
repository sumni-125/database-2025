create table member_tbl_11(
 m_id   varchar2(5) not null  primary key ,
 m_pw  varchar2(5)  ,
 m_name varchar2(10) ,
 m_tel varchar2(13) ,
 m_birthday date ,
 m_point  number(6) ,
 m_grade varchar2(2) 
);
 commit;

insert into member_tbl_11 values ('m100' , '1234' , '성기훈', '010-1111-2222' , '2004-01-01' , 100,  '01');
 insert into member_tbl_11 values ('m101' , '4444' , '김상우', '010-2222-3333' , '2004-01-01' , 1500, '01');
 insert into member_tbl_11 values ('m102' , '5555' , '김일남', '010-3333-4444' , '2004-12-10' , 2000, '02');
 insert into member_tbl_11 values ('m103' , '6666' , '이준호', '010-4444-5555' , '2004-04-10' , 1900, '02');
 insert into member_tbl_11 values ('m104' , '7777' , '김새벽', '010-5555-6666' , '2004-09-12' , 3000, '03');
 insert into member_tbl_11 values ('m105' , '8888' , '최덕수', '010-6666-7777' , '2004-08-10' , 4800, '03');
 insert into member_tbl_11 values ('m106' , '9999' , '이알리', '010-7777-8888' , '2004-07-10' , 2900, '01');
 insert into member_tbl_11 values ('m107' , '0101' , '김미녀', '010-8888-9999' , '2004-06-09' , 1200, '01');
 insert into member_tbl_11 values ('m108' , '0404' , '이정재', '010-9999-8888' , '2004-05-19' , 3000, '03');
 insert into member_tbl_11 ( m_id, m_pw, m_name , m_tel , m_birthday) 
 values ('m109' , '0448' , '박해수', '010-7878-1111' , '2004-11-27' );
 insert into member_tbl_11 ( m_id, m_pw, m_name , m_tel , m_birthday) 
 values ('m110' , '4848' , '위하준', '010-8888-9090' , '2004-11-09');
 commit;

select *
from member_tbl_11;

select m_name, m_birthday
from member_tbl_11;

select m_id, m_birthday, m_point
from member_tbl_11
where m_name = '박해수';

select m_name, m_tel
from member_tbl_11
where m_point>=2000;

select m_name, m_tel
from member_tbl_11
where m_point between 2000 and 3000;

select m_name, m_tel, m_point
from member_tbl_11
where m_grade='01';

select m_name, m_tel
from member_tbl_11
where m_birthday > '04/06/01';

select m_name, m_birthday
from member_tbl_11
where m_birthday < '04/05/01';

select m_name, m_tel, m_grade
from member_tbl_11
where m_grade not in ('01');

select m_id, m_name, m_tel
from member_tbl_11
where m_grade='02';

select m_name, m_tel
from member_tbl_11
where m_point<1500;

select *
from member_tbl_11
where m_point is null;

select *
from member_tbl_11
where m_point is not null;

select distinct m_grade
from member_tbl_11;
