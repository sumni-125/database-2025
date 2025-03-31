--2인 1조 프로젝트 김보성/황예지
-- 도서관 관리 프로그램

-- 회원 정보 테이블
CREATE TABLE LIB_MEMBER(
    M_ID VARCHAR2(4) PRIMARY KEY,
    M_NAME VARCHAR2(10) NOT NULL,
    M_TEL VARCHAR2(13) NOT NULL CHECK(M_TEL like '010-____-____'),
    M_BIRTHDAY DATE NOT NULL,
    M_RENTAL_LEFT VARCHAR2(2) DEFAULT '3' NOT NULL
);

-- 도서 정보 테이블
CREATE TABLE LIB_BOOK_INFO (
    B_ID VARCHAR2(10) PRIMARY KEY NOT NULL ,
    B_TITLE VARCHAR2(90) NOT NULL,
    B_AUTHOR VARCHAR2(50) DEFAULT '무명' NOT NULL,
    B_PUBLISHER VARCHAR2(50) NOT NULL,
    B_RENTAL_STATUS VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    CONSTRAINT CK_B_ID CHECK (REGEXP_LIKE(B_ID, '^[A-Z]{2}[A-Z]{2}[A-Z]{1}[0-9]{4}[A-Z]{1}$'))
);

-- 대출 정보 테이블
CREATE TABLE LIB_BOOK_RENTAL(
    RENTAL_ID VARCHAR2(4) PRIMARY KEY NOT NULL,
    MEMBER_ID VARCHAR2(4) NOT NULL,
    BOOK_ID VARCHAR2(10) NOT NULL,
    RENTAL_DATE DATE NOT NULL, 
    RETURN_DATE DATE NOT NULL,
    RETURN_STATUS VARCHAR2(1) DEFAULT 'N',
    FOREIGN KEY (MEMBER_ID) REFERENCES LIB_MEMBER(M_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES LIB_BOOK_INFO(B_ID)
);

---도서코드 형식을 위한 테이블(도서관/장르/언어)
-- 도서관코드 테이블 
CREATE TABLE LIB_BOOK_LIBRARY(
    L_ID VARCHAR2(5) NOT NULL,
    L_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO LIB_BOOK_LIBRARY VALUES('HJ','합정도서관');
INSERT INTO LIB_BOOK_LIBRARY VALUES('GY','고양도서관');

-- 장르코드테이블
CREATE TABLE LIB_BOOK_GENRE(
    G_ID VARCHAR2(5) PRIMARY KEY NOT NULL,
    G_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO LIB_BOOK_GENRE VALUES('FI','소설');
INSERT INTO LIB_BOOK_GENRE VALUES('PE','시/에세이');
INSERT INTO LIB_BOOK_GENRE VALUES('HT','취미/여행');
INSERT INTO LIB_BOOK_GENRE VALUES('ST','과학/기술');
INSERT INTO LIB_BOOK_GENRE VALUES('SH','인문/사회');
INSERT INTO LIB_BOOK_GENRE VALUES('EB','경제/경영');
INSERT INTO LIB_BOOK_GENRE VALUES('TE','수험서');
INSERT INTO LIB_BOOK_GENRE VALUES('AT','예술');
INSERT INTO LIB_BOOK_GENRE VALUES('CM','만화');
INSERT INTO LIB_BOOK_GENRE VALUES('MZ','잡지');

--언어코드 테이블
CREATE TABLE LIB_BOOK_LANGUAGE(
    LAN_ID VARCHAR2(5) NOT NULL,
    LAN_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO LIB_BOOK_LANGUAGE VALUES('K','한국어');
INSERT INTO LIB_BOOK_LANGUAGE VALUES('E','영어');
INSERT INTO LIB_BOOK_LANGUAGE VALUES('J','일본어');




-- 각 테이블 출력
select * from LIB_MEMBER;           -- 회원 정보
select * from LIB_BOOK_INFO;        -- 도서 정보
select * from LIB_BOOK_RENTAL;      -- 대출 정보
-- 아래 테이블의 ID값을 기반으로 책 정보 속 코드(B_ID) 구성
select * from LIB_BOOK_GENRE;       -- 도서 장르
select * from LIB_BOOK_LIBRARY;     -- 도서관 정보
select * from LIB_BOOK_LANGUAGE;    -- 도서 언어




-----테이블 활용
-- 대출 도서 정보 가져오기
-- 도서 정보의 (B_ID) 값을 테이블의 코드를 기반으로 구성 해 두었음.
-- B_ID의 특정 코드 부분들을 SUBSTR로 가져와 해당 코드가 있는 코드 구성 테이블과 비교하여 출력
select r.rental_id as 대출코드, I.b_id as 도서코드, I.b_title as 도서명
     , I.b_author as 작가, G.g_name as 장르,
       L.LAN_NAME as 언어,LI.L_name as 도서관
from LIB_BOOK_INFO I
JOIN LIB_BOOK_LIBRARY LI
ON LI.L_ID = substr(I.B_ID,1,2)  -- 보유 도서관 출력
JOIN LIB_BOOK_GENRE G
ON G.G_ID = substr(I.B_ID,3,2)   -- 도서 장르 출력
JOIN LIB_BOOK_LANGUAGE L
ON L.LAN_ID = substr(I.B_ID,5,1) -- 도서 언어 출력
JOIN LIB_BOOK_RENTAL R
ON R.BOOK_ID = I.B_ID
order by r.rental_id;


--장르별 정렬 출력
select i.b_id 도서코드, G.g_name 장르, i.b_title 도서명, i.b_author 저자, l.lan_name 언어
from LIB_BOOK_INFO I
JOIN LIB_BOOK_GENRE G
ON G.G_ID = substr(I.B_ID,3,2)   -- 도서 장르 출력
JOIN LIB_BOOK_LANGUAGE L
ON L.LAN_ID = substr(I.B_ID,5,1) -- 도서 언어 출력
order by g.g_name;


-- 대출 정보의 반납 여부(RETURN_STATUS) 값이 미반납(N)인 경우 -> 대출가능 'N'로 변경해야함
select rental_id 대출코드, return_status 반납여부 from lib_book_rental;

select * from lib_book_info; -- 대출가능여부 값 변경 전

-- 도서 정보 테이블의 대출가능여부 값을 'Y' -> 'N'으로 변경
UPDATE LIB_BOOK_INFO I
SET I.B_RENTAL_STATUS = 'N'         -- B_RENTAL_STATUS 컬럼의 값을 'N'으로 설정
WHERE I.B_RENTAL_STATUS ='Y'        -- 현재 대출 상태가 'Y'인 행
    AND EXISTS(                     -- 서브쿼리 사용
        SELECT 1                    -- 결과행 반환용. 값 의미 X
        FROM LIB_BOOK_RENTAL R      -- LIB_BOOK_RENTAL 조회
        WHERE I.B_ID = R.BOOK_ID    -- 현재 도서(I.B_ID)에 대해
        AND R.RETURN_STATUS = 'N'   -- 반납 상태가 'N'인 대여 기록이 존재하는지 확인
        );

-- 도서 반납 여부 수정
UPDATE LIB_BOOK_RENTAL
SET RETURN_STATUS = 'Y'     -- 반납 : 'Y' /  미반납 : 'N'
WHERE RENTAL_ID = 'R002' or RENTAL_ID = 'R001';   -- 해당 대여 코드(RENTAL_ID)

select rental_id 대출코드, return_status 반납여부 from lib_book_rental;


-- 대출 정보 테이블의 반납여부(RETURN_STATUS) 값이 반납완료(Y)인 경우 -> 대출가능 'Y'로 변경해야함 
select l.rental_id 대출코드,i.b_title, l.return_status 반납여부 
from lib_book_rental l
join lib_book_info i
on l.book_id = i.b_id;

select b_id , b_title , b_rental_status 대출가능 from lib_book_info; --대출가능 변경 전 확인

-- 도서 정보 테이블의 대출가능여부 값을 'N' -> 'Y'로 변경
UPDATE LIB_BOOK_INFO I
SET I.B_RENTAL_STATUS = 'Y'         -- B_RENTAL_STATUS 컬럼의 값을 'Y'으로 설정
WHERE I.B_RENTAL_STATUS ='N'        -- 현재 대여 상태가 'N'인 행을 대상
    AND EXISTS(                     -- 서브쿼리 사용
        SELECT 1                    -- 결과행 반환용. 값 의미 X
        FROM LIB_BOOK_RENTAL R      -- LIB_BOOK_RENTAL 조회
        WHERE I.B_ID = R.BOOK_ID    -- 현재 도서(I.B_ID)에 대해
        AND R.RETURN_STATUS = 'Y'   -- 반납 상태가 'Y'인 대여 기록이 존재하는지 확인
        );
        
select b_id , b_title , b_rental_status 대출가능 from lib_book_info;  --대출가능 변경 후 확인



--회원테이블의 대출가능 수량 업데이트 전 확인
select m_id, m_name, m_rental_left 대출가능권수 from lib_member;

-- 서적 대출시 회원 정보(LIB_MEMBER)속 대출가능 수량(M_RENTAL_LEFT)만큼 감소, 반납 시 반납 수 만큼 증가
UPDATE LIB_MEMBER M
SET M.M_RENTAL_LEFT = LEAST(    -- LEAST = 여러 값 중 가장 작은 값을 반환하여 M_RENTAL_LEFT 값이 3을 넘지 않음.
    3,
    M.M_RENTAL_LEFT 
    - (SELECT COUNT(*) 
       FROM LIB_BOOK_RENTAL R 
       WHERE R.MEMBER_ID = M.M_ID AND R.RETURN_STATUS = 'N')    -- 대출 테이블의 ID와 회원정보 테이블의 ID가 동일하고, 반납정보가 'N'인 경우 M_RENTAL_LEFT에서 - 처리
    + (SELECT COUNT(*)
       FROM LIB_BOOK_RENTAL R
       WHERE R.MEMBER_ID = M.M_ID AND R.RETURN_STATUS = 'Y')    -- 대출 테이블의 ID와 회원정보 테이블의 ID가 동일하고, 반납정보가 'N'인 경우 M_RENTAL_LEFT에서  처리
)
WHERE EXISTS (
    SELECT 1
    FROM LIB_BOOK_RENTAL R
    WHERE R.MEMBER_ID = M.M_ID AND (R.RETURN_STATUS = 'N' OR R.RETURN_STATUS = 'Y')
    -- 대출정보의 회원ID와 회원정보에서의 회원ID가 동일하고 대출정보의 반납정보가 'N'이거나 'Y'인 레코드를 찾기.
    -- 레코드 존재시 회원정보 행 업데이트, 없을 시 회원정보 행 업데이트 방지.
);

--대출가능 수량 업데이트 후
select m_id, m_name, m_rental_left 대출가능 from lib_member;





--회원정보
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M001', '김보성', '010-5776-1927', '2000-12-06');
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M002', '황예지', '010-3827-5448', '2002-01-06');
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M003', '김민준', '010-1234-5678', '1995-08-22');
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M004', '박민서', '010-2345-6789', '1998-03-15');
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M005', '최수현', '010-3456-7890', '2002-11-05');
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M006', '이하은', '010-4567-8901', '2005-07-19');
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M007', '정우진', '010-5678-9012', '1990-12-25');
INSERT INTO LIB_MEMBER (M_ID, M_NAME, M_TEL, M_BIRTHDAY) VALUES ('M008', '한지우', '010-6789-0123', '2008-09-30');


--도서정보
--한국소설
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYFIK2014A','소년이 온다','한강','창비');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJFIK2015A','스토너','존 윌리엄스','알에이치코리아');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYFIK2022A','급류','정대건','민음사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJFIK2021A','작별하지 않는다','한강','문학동네');
--한국 시/에세이
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJPEK2020A','꽃을 보듯 너를 본다','나태주','지혜');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYPEK2013A','서랍에 저녁을 넣어 두었다','한강','문학과지성사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJPEK2020B','소년과 두더지와 여우의 말','찰리 맥커시','상상의 힘');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYPEK2022A','잘했고 잘하고 있고 잘 될 것이다','정영욱','부크럼');
--한국 취미/여행
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYHTK2017A','매일매일 두뇌 트레이닝 스도쿠 600','손호성','봄봄스쿨');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJHTK2020A','데코폴리 스티커 컬러링 북: 강아지','.DNA디자인스튜디오','DNA디자인');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJHTK2025A','디스 이즈 파리(2025~2026)','김민준 외','테라출판사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJHTK2025B','디스 이즈 스페인(2025~2026)','천혜진','테라출판사');
--과학/기술
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYSTK2021A','물고기는 존재하지 않는다','룰루 밀러','곰출판');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYSTK2010A','코스모스','칼 세이건','사이언스북스');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJSTK2023A','이기적 유전자','리처드 도킨스','을유문화사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYSTK2021B','다정한 것이 살아남는다','브라이언 헤어 외','디플롯');
--인문/사회
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJSHK2023A','사피엔스','유발 하라리','김영사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYSHK2019A','사랑의 기술','에리히 프롬','문예출판사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJSHK2024A','어떻게 민주주의는 무너지는가','스티븐 레비츠키 외','어크로스');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYSHK2016A','왜 세계의 절반은 굶주리는가?','장 지글러','갈라파고스');
--경제/경영
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJEBK2023A','돈의 심리학','모건 하우절','인플루엔셜');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYEBK2013A','자본주의','EBS 자본주의 제작팀','가나출판사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYEBK2020A','돈의 속성','김승호','스노우폭스북스');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJEBK2018A','생각에 관한 생각','대니얼 카너먼','김영사');
--수험서
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJTEK2025A','2025 객관식세법 2','원재훈 외','나우퍼블리셔');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYTEK2025B','2025 세법플러스','원재훈 외','나우퍼블리셔');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYTEK2025C','2025 핵심정리 사회보험법','이주현','새흐름');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYTEK2024A','2025 하루에 끝장내기 재정학','정병열','세경북스');
--예술
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJATK2009A','스즈키 바이올린 교본 1','세광음악출판사 편집부','세광음악출판사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYATK2022A','수인×이종족 캐릭터 디자인','스미요시 료','므큐');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYATK2016A','룰루랄라 신나는 우쿨렐레 1','정광교 외','디자인기타');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJATK2006A','나의 첫 바이올린 연주곡집','황운순','현대음악출판사');
--만화
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYCMK2022A','오란고교 호스트부 1','Bisco Hatori','학산문화사');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJCMK2022B', '나츠메 우인장25', 'Yuki Midorikawa', '대원씨아이');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJCMK2022C', '진격의 거인34', 'Hajime Isayama', '위즈덤하우스');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJCMK2022D', '너의 이름은', 'Makoto Shinkai', '대원씨아이');
--잡지
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYMZK2022A','보스토크(Vostok). 33','보스토크 프레스 편집부','보스토크프레스');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJMZK2018A','매거진 B No 70: Porshe(한글판)','매거진 B 편집부','비미디어컴퍼니');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('HJMZK2017A','매거진 B No 53: 무인양품(MUJI)(한글판)','매거진 B 편집부','비미디어컴퍼니');
INSERT INTO LIB_BOOK_INFO ( B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER)
VALUES ('GYMZK2015A','매거진 B No 37: Tsutaya(한글판)','매거진 B 편집부','비미디어컴퍼니');
-- 영어 서적 (소설)
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('FIE2006A', 'The Road', 'Cormac McCarthy', 'Vintage Books'); -- 소설
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYFIE2006B', 'The Alchemist', 'Paulo Coelho', 'HarperOne'); -- 소설
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYFIE2008C', 'The Kite Runner', 'Khaled Hosseini', 'Riverhead Books'); -- 소설
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYFIE2010D', 'The Girl with the Dragon Tattoo', 'Stieg Larsson', 'Norstedts Förlag'); -- 소설
-- 영어 서적 (시/에세이)
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYPEE2011A', 'The Help', 'Kathryn Stockett', 'Penguin Group'); -- 시/에세이
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYPEE2014B', 'Gone Girl', 'Gillian Flynn', 'Crown Publishing Group'); -- 시/에세이
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYPEE2017C', 'The Underground Railroad', 'Colson Whitehead', 'Doubleday'); -- 시/에세이
-- 영어 서적 (과학/기술)
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYSTE1995A', 'The Selfish Gene', 'Richard Dawkins', 'Oxford University Press'); -- 과학/기술
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYSTE2000B', 'A Brief History of Time', 'Stephen Hawking', 'Bantam Books'); -- 과학/기술
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYSTE2008C', 'Freakonomics', 'Steven D. Levitt & Stephen J. Dubner', 'William Morrow'); -- 과학/기술
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('GYSTE2005D', 'The Singularity Is Near', 'Ray Kurzweil', 'Viking'); -- 과학/기술
-- 일본어 서적 (소설)
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJFIJ2016A', '너의 이름은.', 'Makoto Shinkai', '대원씨아이'); -- 소설
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJFIJ2003B', '스즈미야 하루히의 우울', '타니가와 나쓰키', '미래엔'); -- 소설
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJFIJ2006C', '클럽', '타카하시 요시유키', '북폴리오'); -- 소설
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJFIJ2008D', '카모메 식당', '히가시노 게이고', '소담출판사'); -- 소설
-- 일본어 서적 (시/에세이)
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJPEJ2009A', '백설공주에게 죽음을', 'S. J. 워드', '알에이치코리아'); -- 시/에세이
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJPEJ2008B', '엄마를 부탁해', '신경숙', '창비'); -- 시/에세이
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJPEJ2018C', '작별인사', '김영하', '문학동네'); -- 시/에세이
-- 일본어 서적 (과학/기술)
INSERT INTO LIB_BOOK_INFO (B_ID, B_TITLE, B_AUTHOR, B_PUBLISHER) 
VALUES ('HJSTJ2014A', '에너지의 미래', '엘리자베스 코스트로프', '시공사'); -- 과학/기술


--대출정보
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R001','M001','GYCMK2022A','2025-02-14',TO_DATE('2025-02-14')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R002','M002','HJFIK2021A','2025-03-14',TO_DATE('2025-03-14')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R003', 'M001','GYFIK2014A', '2025-03-20', TO_DATE('2025-03-20')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R004', 'M006', 'HJSTJ2014A', '2025-03-15', TO_DATE('2025-03-15')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R005', 'M003','HJPEK2020A', '2025-03-25', TO_DATE('2025-03-25')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R006', 'M004','GYHTK2017A', '2025-03-26', TO_DATE('2025-03-26')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R007', 'M005','GYSTK2021A', '2025-03-28', TO_DATE('2025-03-28')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R008', 'M006','HJSHK2023A', '2025-03-29', TO_DATE('2025-03-29')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R009', 'M007','HJEBK2023A', '2025-03-30', TO_DATE('2025-03-30')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R010', 'M008','HJTEK2025A', '2025-03-20', TO_DATE('2025-03-20')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R011', 'M001','HJATK2009A', '2025-03-17', TO_DATE('2025-03-17')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R012', 'M003', 'HJFIJ2016A', '2025-03-30', TO_DATE('2025-03-30')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R013', 'M002', 'HJPEJ2009A', '2025-03-02', TO_DATE('2025-03-02')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R014', 'M004', 'GYSTE1995A', '2025-03-04', TO_DATE('2025-03-04')+15);
INSERT INTO LIB_BOOK_RENTAL (RENTAL_ID, MEMBER_ID, BOOK_ID, RENTAL_DATE, RETURN_DATE)
VALUES ('R015', 'M005', 'GYFIE2006B', '2025-03-05', TO_DATE('2025-03-05')+15);
