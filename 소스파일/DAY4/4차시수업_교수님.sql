

--오디션 프로그램


create table tbl_join_200(
  join_id varchar2(4)  not null primary key ,
  join_nm varchar2(20)  ,
  birth  char(8),
  gender char(1),
  specialty varchar2(1),
  charm varchar2(30)
);

insert into tbl_join_200 values( 'A001' , '케이쥬',  '20050102' , 'M', 'D', '깜찍댄스');
insert into tbl_join_200 values( 'A002' , '고키',  '20090102' , 'M', 'D', '동전마술');
insert into tbl_join_200 values( 'A003' , '나윤서',  '20070102' , 'M', 'D', '창작댄스');
insert into tbl_join_200 values( 'A004' , '장현수',  '20030103' , 'M', 'R', '보컬');
insert into tbl_join_200 values( 'A005' , '윤민',  '20020205' , 'M', 'V', '자작곡');



--멘토테이블 

create table tbl_mentor_200(
    mentor_id varchar2(4) not null primary key ,
    mentor_nm varchar2(20)
);

insert into tbl_mentor_200 values( 'J001', '박진영');
insert into tbl_mentor_200 values( 'J002', '박재상');
insert into tbl_mentor_200 values( 'J003', '보아');



create table tbl_score_200(
  score_no  number(6) not null ,
  artistid varchar2(4) not null,
  mentorid varchar2(4) not null,
  score number(3),
  primary key( score_no, artistid, mentorid)
);

insert into tbl_score_200 values( 110001, 'A001', 'J001' , 80);
insert into tbl_score_200 values( 110002, 'A001', 'J002' , 90);
insert into tbl_score_200 values( 110003, 'A001', 'J003' , 70);
insert into tbl_score_200 values( 110004, 'A002', 'J001' , 60);
insert into tbl_score_200 values( 110005, 'A002', 'J002' , 50);
insert into tbl_score_200 values( 110006, 'A002', 'J003' , 70);
insert into tbl_score_200 values( 110007, 'A003', 'J001' , 80);
insert into tbl_score_200 values( 110008, 'A003', 'J002' , 60);
insert into tbl_score_200 values( 110009, 'A003', 'J003' , 70);
insert into tbl_score_200 values( 110010, 'A004', 'J001' , 80);
insert into tbl_score_200 values( 110011, 'A004', 'J002' , 78);
insert into tbl_score_200 values( 110012, 'A004', 'J003' , 89);
insert into tbl_score_200 values( 110013, 'A005', 'J001' , 62);
insert into tbl_score_200 values( 110014, 'A005', 'J002' , 91);
insert into tbl_score_200 values( 110015, 'A005', 'J003' , 67);



select * from tbl_join_200;
select * from tbl_mentor_200;
select  *  from tbl_score_200;

--

desc tbl_join_200;


select * from tbl_join_200;




select  gender  , decode( gender , 'M','남자', 'F','여자') 
from tbl_join_200;


select join_id, 
       join_nm,
       to_char( to_date( birth), 'yyyy"년"mm"월"dd"일' ), 
       decode( gender , 'M','남자', 'F','여자')  , 
       decode( specialty  , 'D' ,'댄스' ,'V','보컬','R','랩'), charm
from tbl_join_200;


select birth  ,   to_date( birth) 
from tbl_join_200;

select birth  ,   to_char( to_date( birth), 'yyyy"년"mm"월"dd"일' )
from tbl_join_200;


select specialty  , decode( specialty  , 'D' ,'댄스' ,'V','보컬','R','랩')
from  tbl_join_200;

--

select join_id, 
       join_nm,
       to_char( to_date( birth), 'yyyy"년"mm"월"dd"일' )  as  birth, 
       decode( gender , 'M','남자', 'F','여자')  as gender , 
       decode( specialty  , 'D' ,'댄스' ,'V','보컬','R','랩'), charm
from tbl_join_200;



--2번
select  * 
from tbl_score_200 s
join tbl_join_200  j
on  s.artistid  = j.join_id
join tbl_mentor_200  m
on s.mentorid  = m.mentor_id;

--

select  s.score_no, s.artistid  , j.join_nm   ,  j.birth , s.score, m.mentor_nm
from tbl_score_200 s
join tbl_join_200  j
on  s.artistid  = j.join_id
join tbl_mentor_200  m
on s.mentorid  = m.mentor_id;




select  s.score_no, s.artistid  , j.join_nm   ,  
                substr(j.birth, 1,4)||'년'  ||  substr( j.birth,5,2)  || '월'   ||   substr( j.birth, 7,2)  || '일' ,
                s.score,  case when score >=90 then  'A'
                     when  score>=80 then  'B'
                     when  score >=70 then 'C'
                     else 'D'
                end as result , m.mentor_nm
from tbl_score_200 s
join tbl_join_200  j
on  s.artistid  = j.join_id
join tbl_mentor_200  m
on s.mentorid  = m.mentor_id;



select birth   , substr(birth, 1,4)||'년'  ||  substr( birth,5,2)  || '월'   ||   substr( birth, 7,2)  || '일' 
from  tbl_join_200;

select score  , case when score >=90 then  'A'
                     when  score>=80 then  'B'
                     when  score >=70 then 'C'
                     else 'D'
                end as result
from  tbl_score_200;
 


select * from tbl_join_200;
select * from tbl_mentor_200;
select  *  from tbl_score_200;



--그룹함수 
--순위구하기 
select * from acorntbl2;


--rank() 순위구하기 
-- 
select name, point  , rank() over( order by point)
from acorntbl2 ;


-- 
select name, point  , rank() over( order by point desc)
from acorntbl2 ;
 

--dense_rank()
--
select name, point , dense_rank() over( order by point desc)
from acorntbl2;



--row_number() : 같은 등수 일 때  rowid를 기준으로 순위를 매김
--row id는 행을 식별하는 고유번호 
select  name, point  , row_number() over( order by point desc)
from acorntbl2 ;



--누적합 
--전체합
--누적합
select name, point  , sum( point) over()
from acorntbl2;


--첫행에서 현재행까지의 누적합 구하기 
select name, point , sum(point) over( order by point)
from acorntbl2;



select name, point  , sum(point) over( order by point )
from acorntbl2;


--
select name, point  , sum(point)
                      over( order by point                       
                      Range  BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                      )   -- 같은범위가 같으면 같은 범위
from acorntbl2;



--rows BETWEEN   
select name, point  , sum(point)
                      over( order by point                       
                      rows  BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                      )   -- 같은범위가 같으면 같은 범위
from acorntbl2;



select name, point  , sum(point) over( order by  point    range between UNBOUNDED PRECEDING  and   current row    )
from acorntbl2;


--누적합의 범위 지정 (
--range between  unbounded preceding  and current row   (기본임) 
--rows between   unbounded preceding and current row 


select name, point  , sum(point) over( order by  point    rows between UNBOUNDED PRECEDING  and   current row    )
from acorntbl2;


-- 
select * from member_tbl_11;

--포인트 누적합 구하기
--고객등급별 누적합 구하기


select  m_name, m_grade, m_point
from member_tbl_11
where m_point is not null;

--전체합
select  m_name, m_grade, m_point  , sum( m_point) over()
from member_tbl_11
where m_point is not null;

-- 포인트 누적합
select  m_name, m_grade, m_point  , sum( m_point) over( order by  m_point)
from member_tbl_11
where m_point is not null;


--


select  m_name, m_grade, m_point  , sum( m_point) over( order by  m_point  )
from member_tbl_11
where m_point is not null;
-- 

select  m_name, m_grade, m_point  , sum( m_point) over( order by  m_point  range between  unbounded preceding  and current row )
from member_tbl_11
where m_point is not null;



select  m_name, m_grade, m_point  , sum( m_point) over( order by  m_point  rows between  unbounded preceding  and current row )
from member_tbl_11
where m_point is not null;


--select m_name, m_point  , m_grade ,  sum(m_point ) over( partition by m_grade  order by m_point )
--from member_tbl_11;

--고객등급별 포인트 누적합 
select m_name, m_grade , m_point , sum(m_point) over( partition by m_grade  order by m_point  )
from member_tbl_11;



--그룹바이 
--roll up  ( 부분합 구하기) - 선행조건이  group by 한 후에 집계를 내고 싶을 때 사용 



--
select * from member_tbl_11;

select sum( m_point) from member_tbl_11;


select  m_grade, m_point from member_tbl_11;


select  m_grade, sum(m_point )from member_tbl_11
group by  m_grade;


--집계 
--rollup()

select  m_grade, sum(m_point )from member_tbl_11
group by  rollup(m_grade);


select * from tbl_test_order;
select * from tbl_test_goods;



select * 
from  tbl_test_order  o
join tbl_test_goods g
on o.pcode  = g.pcode;


-- 상품별  판매수량합계 구하기
select  g.pname,  g.price , o.sale_cnt 
from  tbl_test_order  o
join tbl_test_goods g
on o.pcode  = g.pcode;



select  g.pname,    sum( g.price * o.sale_cnt )
from  tbl_test_order  o
join tbl_test_goods g
on o.pcode  = g.pcode
group by  g.pname;


select  g.pname,    sum( g.price * o.sale_cnt )
from  tbl_test_order  o
join tbl_test_goods g
on o.pcode  = g.pcode
group by   rollup(g.pname);




select  nvl(g.pname,'total'),    sum( g.price * o.sale_cnt )
from  tbl_test_order  o
join tbl_test_goods g
on o.pcode  = g.pcode
group by   rollup(g.pname);



-- 고객별 제품별  판매금액 

 
 select * from 
 tbl_test_order  o
 join tbl_test_customer   c
 on o.id  = c.id
 join   tbl_test_goods g
 on  o.pcode  = g.pcode;
 
 
 
 select  c.name,  g.pname,  g.price * o.sale_cnt from 
 tbl_test_order  o
 join tbl_test_customer   c
 on o.id  = c.id
 join   tbl_test_goods g
 on  o.pcode  = g.pcode;
 
 
  
 select  c.name,  g.pname,   sum( g.price * o.sale_cnt) 
 from 
 tbl_test_order  o
 join tbl_test_customer   c
 on o.id  = c.id
 join   tbl_test_goods g
 on  o.pcode  = g.pcode
 group by c.name,  g.pname
 order by 1;
 
 


  
 select  c.name,  g.pname,   sum( g.price * o.sale_cnt) 
 from 
 tbl_test_order  o
 join tbl_test_customer   c
 on o.id  = c.id
 join   tbl_test_goods g
 on  o.pcode  = g.pcode
 group by  rollup(c.name,  g.pname)
 order by 1;


 

-- 고객별 합계
-- 고객별 제품별 합계
-- 전체합계




-- LAG() 함수  이전행의 값을 가져올 때 사용 (판매실적)
select * from acorntbl2;


select  name, point  ,lag(point , 1,0) over( order by  point )
from acorntbl2;



--lead()함수 다음행의 값을 가져올 때  사용 
select name, point  , lead(point ,1,0) over( order by point)
from acorntbl2;


--pivot 테이블 

select  *
from emp;


-- decode로   부서별  직급별  사원 수 구하기 


select  decode( job,'CLERK',1)  , decode( job, 'SALESMAN', 1)
from emp;

select    count( job) , count(decode( job,'CLERK',1))  ,  count(decode( job, 'SALESMAN', 1))
from emp;


select  deptno, decode( job,'CLERK',1)  , decode( job, 'SALESMAN', 1)
from emp;



select  deptno, count( decode( job,'CLERK',1)) as "CLERK"  ,  count(decode( job, 'SALESMAN', 1)) as  "SALESMAN"
from emp
group by  deptno
order by 1;



select  * from  ( select deptno, job, empno from emp)
pivot(              ----  FOR JOb IN ( 값1  , 값2,  값3)    -열로 나옴
   count( empno)  for  job  in( 'CLERK' as  "CLERK"  ,  'MANAGER' as "MANAGER" ,  'SALESMAN' as  "SALESMAN" ,  'ANALYST' as "ANALYST"  ,'PRESIDENT'  as  "PRESIDENT")
);


-- 비율구하기 
-- select * from member_tbl_11;

select * from member_tbl_11
where m_point is not null;

-- 
select m_name, m_point   ,  sum(m_point) over()
from member_tbl_11
where m_point is not null;

--
select m_name, m_point   ,  sum(m_point) over()   ,  round(m_point  / sum(m_point) over()   *100,2)
from member_tbl_11
where m_point is not null;



--ratio_to_report 사용하여 비율구하기

select m_name , m_point ,  round( ratio_to_report( m_point)  over() *100   ,2)
from member_tbl_11
where m_point is not null;



--참가자 등수 조회
select  *
from  tbl_score_200;

select * from tbl_join_200  ;

select  *
from  tbl_score_200 s
join tbl_join_200  j
on  s.artistid  =   j.join_id;



select  s.artistid , j.join_nm,  score, score
from  tbl_score_200 s
join tbl_join_200  j
on  s.artistid  =   j.join_id;


--

select  s.artistid , j.join_nm,  sum( score), avg(score) , rank() over( order by avg(score) desc )
from  tbl_score_200 s
join tbl_join_200  j
on  s.artistid  =   j.join_id
group by  s.artistid , j.join_nm;


--
select  s.artistid ,
        j.join_nm,
        sum( score),
        round(avg(score) ,2) ,
        rank() over( order by avg(score) desc )
from  tbl_score_200 s
join tbl_join_200  j
on  s.artistid  =   j.join_id
group by  s.artistid , j.join_nm;







--rank()   순위구하기
--SUM() OVER()  :전체합구하기, 누적합 구하기
--LAG() OVER()   이전행 가져오기
--LEAD() OVER()  다음행 가져오기 
--ROLLUP() 집계 ( 선행조건 GROUP BY)
--RATIO_TO_REPORT() OVER() :비율구하기
--PIVOT 

 --
 
 















