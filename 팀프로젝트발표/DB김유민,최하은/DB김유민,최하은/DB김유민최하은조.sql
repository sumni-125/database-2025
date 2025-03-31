------영화관 테이블------(영화관 지점, 영화관 브랜드, 영화관 전화번호)
CREATE TABLE  CINEMA_TBL(
C_CODE VARCHAR(10) PRIMARY KEY,
C_NAME VARCHAR2(30),
C_BRAND  VARCHAR2(20),
C_TEL VARCHAR2(30)
);

COMMIT;

------영화관 테이블 삽입------
--롯데시네마--
INSERT INTO CINEMA_TBL VALUES('CL1', '롯데시네마 합정점','LOTTECINEMA', '02-1234-5677');
INSERT INTO CINEMA_TBL VALUES('CL2', '롯데시네마 홍대점','LOTTECINEMA', '02-1234-5678');
INSERT INTO CINEMA_TBL VALUES('CL3', '롯데시네마 신촌점','LOTTECINEMA', '02-1234-5679');

--CGV--
INSERT INTO CINEMA_TBL VALUES('CC1','씨지브이 합정점', 'CGV', '02-1234-5677');
INSERT INTO CINEMA_TBL VALUES('CC2','씨지브이 홍대점', 'CGV',  '02-1234-5678');
INSERT INTO CINEMA_TBL VALUES('CC3','씨지브이 신촌점', 'CGV',  '02-1234-5679');

--MEGABOX--
INSERT INTO CINEMA_TBL VALUES('CM1', '메가박스 합정점', 'MEGABOX', '02-1234-5677');
INSERT INTO CINEMA_TBL VALUES('CM2', '메가박스 홍대점', 'MEGABOX',  '02-1234-5678');
INSERT INTO CINEMA_TBL VALUES('CM3', '메가박스 신촌점', 'MEGABOX',  '02-1234-5679');

COMMIT;

SELECT * FROM CINEMA_TBL;

--1.영화관 정보 출력하기 
select c_brand "영화관 브랜드", c_name "영화관 지점", c_tel "영화관 전화번호"
from cinema_tbl;

------영화 테이블------(영화코드, 영화이름, 영화감독, 영화개봉일, 영화 누적 관람객 순위, 영화관 지점, 영화 러닝타임)
CREATE TABLE MOVIE_TBL(
M_CODE VARCHAR(10) PRIMARY KEY, 
M_NAME VARCHAR(30),
M_DIR VARCHAR(30),
M_REL DATE,
M_SEEN VARCHAR2(1),
C_CODE VARCHAR(50),
M_RUN NUMBER(20)
);

COMMIT;

------영화 테이블 삽입------
INSERT INTO MOVIE_TBL VALUES('M1', '범죄도시', '허명행', '2024-04-24', 1, 'CL1', '109');
INSERT INTO MOVIE_TBL VALUES('M2', '신과함께', '허진수', '2017-12-20', 2, 'CL2', '139');
INSERT INTO MOVIE_TBL VALUES('M3', '국제시장', '허명행', '2014-12-17', 3, 'CL3', '109');
INSERT INTO MOVIE_TBL VALUES('M4', '명량', '김한민', '2015-06-07', 4, 'CC1', '128');
INSERT INTO MOVIE_TBL VALUES('M5', '어벤져스', '이병헌', '2021-08-10', 5, 'CC2', '123');
INSERT INTO MOVIE_TBL VALUES('M6', '겨울왕국', '김민수', '2020-05-21', 6, 'CC3', '134');
INSERT INTO MOVIE_TBL VALUES('M7', '베테랑', '박소정', '2019-04-05', 7, 'CM1', '105');
INSERT INTO MOVIE_TBL VALUES('M8', '아바타', '윤복길', '2018-02-21', 8, 'CM2', '109');
INSERT INTO MOVIE_TBL VALUES('M9', '서울의봄', '정우성', '2011-12-14', 9, 'CM3', '143');
INSERT INTO MOVIE_TBL VALUES('M10', '로비', '하정우', '2025-04-02', '-', 'CM3', '106');
INSERT INTO MOVIE_TBL VALUES('M11', '공포특급', '김진웅', '2025-04-02', '-', 'CM3', '91');
INSERT INTO MOVIE_TBL VALUES('M12', '범죄도시2', '허명행', '2024-04-24', 1, 'CL2', '139');
INSERT INTO MOVIE_TBL VALUES('M13', '신과함께2', '허진수', '2017-12-20', 2, 'CC2', '139');

SELECT * FROM MOVIE_TBL;

--2.컬럼 이름 변경하기 (M_SEEN -> M_RANK)
alter table movie_tbl rename column m_seen to m_rank;

--3.컬럼 추가하기 (M_SEEN : 누적 관객수)
alter table movie_tbl add(m_seen number(10) default '0');

--4.데이터(값) 변경하기 (M_SEEN 값 넣어주기)
update movie_tbl
set m_seen = 4710000
where c_code = 'CL1';

--5.영화관 지점별 상영영화 정보 출력하기 
select c.c_name 영화관, m.m_name 제목, m.m_dir 감독, 
       to_char(m.m_rel, 'yy"년"mm"월"dd"일"') 개봉일, 
       m.m_run || '분' 러닝타임, 
       substr(m.m_seen, 1, 3) || '만명' 관객수, 
       m.m_rank || '위' 인기순위
from cinema_tbl c
join movie_tbl m
on c.c_code = m.c_code;

--개봉 예정 영화만 출력
SELECT M_REL 개봉일, M_NAME 이름, M_RUN || '분' 러닝타임, M_DIR 감독
FROM MOVIE_TBL
WHERE M_REL > SYSDATE;

--6.컬럼 타입 변경하기 
alter table movie_tbl modify c_code varchar(10) not null;

--7.특정 값만 추가하기 
insert into movie_tbl (m_code, m_name, c_code) values ('M14', '범죄도시3', 'CC1');

--8.영화별 상영 영화관 지점 출력하기
select m.m_name, c.c_name
from movie_tbl m
join cinema_tbl c
on m.c_code = c.c_code
order by m.m_name;

select c.c_name 범죄도시
from movie_tbl m
join cinema_tbl c
on m.c_code = c.c_code
where m.m_name = '범죄도시';

select c.c_name 신과함께
from movie_tbl m
join cinema_tbl c
on m.c_code = c.c_code
where m.m_name = '신과함께';

------상영관 테이블------(상영관 코드, 상영관 좌석수, 상영 영화 제목, 상영관 번호, 상영 시작 시간, 영화관 지점)
CREATE TABLE THEATER_TBL(
T_CODE VARCHAR(10),
T_SEAT NUMBER(3),
T_NAME VARCHAR(50),
T_NUM VARCHAR(10),
T_START VARCHAR(20),
C_CODE VARCHAR(30)
);

COMMIT;

------상영관 테이블 삽입------
INSERT INTO THEATER_TBL VALUES('T1', 150, '범죄도시', '1관', '10:00', 'CL1');
INSERT INTO THEATER_TBL VALUES('T1', 200, '국제시장', '1관', '11:00', 'CL2');
INSERT INTO THEATER_TBL VALUES('T1', 250, '어벤져스', '1관', '12:00', 'CL3');
INSERT INTO THEATER_TBL VALUES('T2', 220, '겨울왕국', '2관', '10:00', 'CC1');
INSERT INTO THEATER_TBL VALUES('T2', 230, '아바타', '2관', '11:00', 'CC2');
INSERT INTO THEATER_TBL VALUES('T2', 170, '신과함께', '2관', '12:00', 'CC3');
INSERT INTO THEATER_TBL VALUES('T3', 220, '국제시장', '3관', '10:00', 'CM1');
INSERT INTO THEATER_TBL VALUES('T3', 230, '겨울왕국', '3관', '11:00', 'CM2');
INSERT INTO THEATER_TBL VALUES('T3', 170, '아바타', '3관', '12:00', 'CM3');

SELECT * FROM THEATER_TBL;

--9.영화별 예매 가능한 영화 상영관 정보 출력 
select m.m_name 제목, c.c_name "영화관 지점"
from movie_tbl m
join cinema_tbl c
on m.c_code = c.c_code
order by m.m_name;

select a.제목, a."영화관 지점", t.t_num 상영관, t.t_start "시작 시간", t.t_seat "총 좌석 수"
from (select m.m_name 제목, c.c_name "영화관 지점"
      from movie_tbl m
      join cinema_tbl c
      on m.c_code = c.c_code
      order by m.m_name) a
join theater_tbl t
on a.제목 = t.t_name;

--10.200개 이상의 좌석을 보유한 영화관 출력
select c.c_name, t.t_seat
from cinema_tbl c
join theater_tbl t
on c.c_code = t.c_code
where t.t_seat >= 200;

------고객 테이블------(고객ID, 고객이름, 예약번호, 성별, 전화번호, 등급, 예약번호)
CREATE TABLE CUSTOMER_TBL(
CUS_ID VARCHAR(20) NOT NULL PRIMARY KEY,
CUS_NAME VARCHAR(10),
CUS_GENDER VARCHAR(1),
CUS_TEL VARCHAR(13),
CUS_GRADE VARCHAR(10),
R_NUM VARCHAR(10)
);

------고객 테이블 삽입-----
INSERT INTO CUSTOMER_TBL VALUES('C1', '김홍길', 'M', '010-1234-5784', 'WHITE', 'R1');
INSERT INTO CUSTOMER_TBL VALUES('C2', '이홍보', 'M', '010-1234-5785', 'WHITE', 'R2');
INSERT INTO CUSTOMER_TBL VALUES('C3', '박성민', 'M', '010-1234-5786', 'WHITE', 'R3');
INSERT INTO CUSTOMER_TBL VALUES('C4', '이종석', 'M', '010-1234-5787', 'GOLD', 'R4');
INSERT INTO CUSTOMER_TBL VALUES('C5', '김민석', 'M', '010-1234-5788', 'GOLD', 'R5');
INSERT INTO CUSTOMER_TBL VALUES('C6', '홍민경', 'W', '010-1234-5789', 'VIP', 'R6');
INSERT INTO CUSTOMER_TBL VALUES('C7', '박성경', 'W', '010-1234-5781', 'VIP', 'R7');
INSERT INTO CUSTOMER_TBL VALUES('C8', '허진수', 'M', '010-1234-5782', 'VVIP', 'R8');
INSERT INTO CUSTOMER_TBL VALUES('C9', '김가현', 'W', '010-1234-5783', 'VVIP', 'R9');

SELECT * FROM CUSTOMER_TBL;

--11.등급별 고객 인원 수 출력
select cus_grade 등급, count(cus_grade) || '명' "인원 수"
from customer_tbl 
group by cus_grade
order by cus_grade;

--12.값 변경하기 
update customer_tbl 
set cus_grade = case when cus_grade = 'WHITE' then '1'
                     when cus_grade = 'GOLD' then '2'
                     when cus_grade = 'VIP' then '3'
                     when cus_grade = 'VVIP' then '4'
                     else cus_grade end;

--11-1.등급별 고객 인원 수 출력
select decode(cus_grade, '1','WHITE', '2','GOLD', '3','VIP', '4','VVIP') 등급, count(cus_grade) || '명' "인원 수"
from customer_tbl 
group by cus_grade
order by cus_grade;

------예약 테이블------(예약번호, 예약날짜, 좌석정보, 상영관번호, 영화관 지점)
CREATE TABLE RESERVATION_TBL(
R_NUM VARCHAR(10) NOT NULL PRIMARY KEY,
R_TIME DATE,
R_INFO VARCHAR(20),
T_NUM VARCHAR(10),
C_CODE VARCHAR(30),
M_CODE VARCHAR(10)
);

COMMIT;

SELECT * FROM RESERVATION_TBL;

------예약 테이블 삽입------
INSERT INTO RESERVATION_TBL VALUES('R1', '2025-03-28', 'A열1번', '1관', 'CL1', 'M1');
INSERT INTO RESERVATION_TBL VALUES('R2', '2025-03-27', 'A열2번', '1관', 'CL2', 'M2');
INSERT INTO RESERVATION_TBL VALUES('R3', '2025-03-26', 'A열3번', '1관', 'CL3', 'M3');
INSERT INTO RESERVATION_TBL VALUES('R4', '2025-03-25', 'B열1번', '2관', 'CC1', 'M4');
INSERT INTO RESERVATION_TBL VALUES('R5', '2025-03-24', 'B열2번', '2관', 'CC2', 'M5');
INSERT INTO RESERVATION_TBL VALUES('R6', '2025-03-23', 'B열3번', '2관', 'CC3', 'M6');
INSERT INTO RESERVATION_TBL VALUES('R7', '2025-03-22', 'C열1번', '3관', 'CM1', 'M7');
INSERT INTO RESERVATION_TBL VALUES('R8', '2025-03-21', 'C열2번', '3관', 'CM2', 'M8');
INSERT INTO RESERVATION_TBL VALUES('R9', '2025-03-20', 'C열3번', '3관', 'CM3', 'M9');

--13.고객별 예약 정보 출력
select c.cus_name, r.r_time, r.t_num, r.r_info
from customer_tbl c 
join reservation_tbl r
on c.r_num = r.r_num;

select a.이름, a."예매 날짜", c.c_name 영화관, m.m_name 제목, a.상영관, a.좌석 
from cinema_tbl c
join movie_tbl m
on c.c_code = m.c_code
join (select c.cus_name 이름, r.r_time "예매 날짜", r.t_num 상영관, r.r_info 좌석, r.m_code
        from customer_tbl c 
        join reservation_tbl r
        on c.r_num = r.r_num) a
on m.m_code = a.m_code;


------매점 테이블------(주문번호, 스낵이름, 스낵가격, 고객ID, 영화관지점)
CREATE TABLE SNACK_TBL(
SNACK_ORDER VARCHAR(10) NOT NULL PRIMARY KEY,
SNACK_NAME VARCHAR(30),
SNACK_PRICE NUMBER(10),
CUS_ID VARCHAR(20),
C_CODE VARCHAR(30)
);

COMMIT;

SELECT * FROM SNACK_TBL;

------스낵 테이블 삽입-----
INSERT INTO SNACK_TBL VALUES('S1', '나쵸', 5800, 'C1', 'CL1');
INSERT INTO SNACK_TBL VALUES('S2', '팝콘', 10200, 'C2', 'CL2');
INSERT INTO SNACK_TBL VALUES('S3', '콜라', 3000, 'C3', 'CL3');
INSERT INTO SNACK_TBL VALUES('S4', '사이다', 2500, 'C4', 'CC1');
INSERT INTO SNACK_TBL VALUES('S5', '에이드', 4000, 'C5', 'CC2');
INSERT INTO SNACK_TBL VALUES('S6', '핫도그', 5000, 'C6', 'CC3');
INSERT INTO SNACK_TBL VALUES('S7', '탄산수', 2000, 'C7', 'CM1');
INSERT INTO SNACK_TBL VALUES('S8', '피자', 15000, 'C8', 'CM2');
INSERT INTO SNACK_TBL VALUES('S9', '맥주', 6000, 'C9', 'CM3');

--14. 특정 고객이 주문한 스낵 출력
select c.cus_name 이름, s.snack_name "주문 내역" 
from customer_tbl c
join snack_tbl s
on c.cus_id = s.cus_id
where s.cus_id = 'C1';

--15.영화관별 판매 스낵 출력
select c.c_name 영화관, s.snack_name 스낵, s.snack_price 가격
from cinema_tbl c
join snack_tbl s 
on c.c_code = s.c_code;

--16.스낵의 구매자(고객) 정보 출력
select s.snack_name 스낵, c.cus_name 구매자, 
       decode(c.cus_gender, 'M','남성', '여성') 성별, c.cus_tel 전화번호, 
       decode(c.cus_grade, '1','WHITE', '2','GOLD', '3','VIP', 'VVIP') 등급
from snack_tbl s
join customer_tbl c
on s.cus_id = c.cus_id;
