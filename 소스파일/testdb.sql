select * from student;

create table  acorntbl (
    id  varchar2(10) primary key,
    pw  varchar2(10) ,
    name varchar2(10)
);

insert into acorntbl values('usung0518', '1234', '권지언'); 
insert into acorntbl values('boseong00', '1234', '김보성'); 
insert into acorntbl values('Jys123', '9876', ' 정연수');
insert into acorntbl values('sumni', '1234', '이수민');
insert into acorntbl values('dongwoo12', '1234', '이동우');
insert into acorntbl values('gusrl123', 'dks123', '윤현기');
insert into acorntbl values('sulivun_03', '1234', '박시우');
insert into acorntbl values('yerin0373', '1234', '박예린'); 
insert into acorntbl values('yzei', '1234', '황예지'); 
insert into acorntbl values('jitae', '1214', '최지태'); 
insert into acorntbl values('sookyung', '1004', '박수경'); 
insert into acorntbl values('dhdbstjr', '123', '오윤석'); 
insert into acorntbl values('LHJ0319', '1234', ' 이정호'); 
insert into acorntbl values('gudxor8251', '1234', '임형택'); 
insert into acorntbl values('che', '1234', '최하은');
insert into acorntbl values('umin', '1234', '김유민');
insert into acorntbl values('gill', '1234', '김민환');

insert into acorntbl (id) values('test');

delete from acorntbl where id = 'test';

commit;



--테이블의 전체 컬럼 조회하기
select * from acorntbl;

--특정컬럼 조회하기
select id, name from acorntbl;

--정렬하기
select id, pw
from acorntbl
order by id;

--정렬하기
select id, pw
from acorntbl
order by pw desc;

--정렬기준을 조회컬럼의 순서로 사용할 수 있음
select id, pw
from acorntbl
order by 2;

-- || 연결연산자
-- 데이터베이스 문자, 날짜 데이터는 ' 혿따옴표 ' 사용
select name || '님'
from acorntbl;

-- 비밀번호 조회하기
select DISTINCT pw
from acorntbl;



create table  acorntbl2 (
    id  varchar2(10) primary key,
    pw  varchar2(10) ,
    name varchar2(10),
    point number(6) 
);


select *  from acorntbl2 ;
insert into acorntbl2 values('usung0518', '1234', '권지언',1500); 
insert into acorntbl2 values('boseong00', '1234', '김보성',3000); 
insert into acorntbl2 values('Jys123', '9876', ' 정연수',4000);
insert into acorntbl2 values('sumni', '1234', '이수민',2000);
insert into acorntbl2 values('dongwoo12', '1234', '이동우',100);
insert into acorntbl2 values('gusrl123', 'dks123', '윤현기',5000);
insert into acorntbl2 values('sulivun_03', '1234', '박시우',3400);
insert into acorntbl2 values('yerin0373', '1234', '박예린',1200); 
insert into acorntbl2 values('yzei', '1234', '황예지',6500); 
insert into acorntbl2 values('jitae', '1214', '최지태',4500);
insert into acorntbl2 values('sookyung', '1004', '박수경',200); 
insert into acorntbl2 values('yunseok', '123', '오윤석',700);
insert into acorntbl2 values('LHJ0319', '1234', ' 이정호',5000); 
insert into acorntbl2 values('gudxor8251', '1234', '임형택',2800); 
insert into acorntbl2 values('che', '1234', '최하은',7800);
insert into acorntbl2 values('umin', '1234', '김유민',4900);
insert into acorntbl2 values('gill', '0000', '김민환',5900);

insert into acorntbl2 (id) values('test' );

commit;
select * from acorntbl2;


--특정 조건으로 조회하기
--where절 사용하기

-- = (같다)
select id, pw, name
from acorntbl2
where name = '권지언';

-- > (크다)
select id, name, point
from acorntbl2
where point > 5000;

-- > = (이상)
select id, name, point
from acorntbl2
where point >= 3000;


-- <(작다)
select id, name, point
from acorntbl2
where point < 1000;

-- <(이하)
select id, name, point
from acorntbl2
where point <= 3000;

-- between a and b ( a가 더 작은 값이어야 한다 - a, b 포함된다 )
select id, name, pw, point
from acorntbl2
where point BETWEEN 2000 and 3000;

-- 조건이 여러개 있을 때 and
-- 비밀번호가 1234이고 포인트가 3000이상인 사람

select name, id, point
from acorntbl2
where pw = '1234' and point >=3000;


--포인트가 2000보다 크고 3000보다 작은 사람 조회하기

select name, id, point
from acorntbl2
where point>2000 and point<3000;


-- 조건이 여러개 있을 때 or
-- 포인트가 1000원 미만이거나, 포인트가 5000이상인 회원 조회

select name, id, point
from acorntbl2
where point<1000 or point>5000;


-- in( )

select id, pw, name, point
from acorntbl2
where pw in ('1234','123');
















