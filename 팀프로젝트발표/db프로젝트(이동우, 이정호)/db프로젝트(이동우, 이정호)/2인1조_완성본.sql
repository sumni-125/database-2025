--회원 테이블
CREATE TABLE USER_TBL(
    USER_ID CHAR(4) PRIMARY KEY,                            --회원 아이디 (기본키, CHAR(4)) EX) u001
    USER_NAME VARCHAR2(10) NOT NULL,                        --회원 이름 (VARCHAR2(10))
    EMAIL VARCHAR2(50) CHECK(EMAIL LIKE '%@%.%'),           --이메일 (VARCHAR2(50), 입력 양식 %@%.%으로 제한)
    PHONE VARCHAR2(20) CHECK(PHONE LIKE '010-%-____'),      --핸드폰 (VARCHAR2(20), 입력 양식 010-XXXX-XXXX으로 제한)
    GENDER VARCHAR2(6) CHECK(GENDER IN('남', '여'))          --성별 (VARCHAR2(6), 입력 값 남', '여'로 제한)
);

--회원 값 생성
INSERT INTO USER_tbl VALUES ('u001', '김하준', 'hajun@acorn.com', '010-2389-8901', '남');
INSERT INTO USER_tbl VALUES ('u002', '이서윤', 'seoyun@acorn.com', '010-8109-3827', '여');
INSERT INTO USER_tbl VALUES ('u003', '박도현', 'dohyun@acorn.com', '010-0192-8209', '남');
INSERT INTO USER_tbl VALUES ('u004', '정예린', 'yerin@acorn.com', '010-9301-8930', '여');
INSERT INTO USER_tbl VALUES ('u005', '최민석', 'minseok@acorn.com', '010-8301-1192', '남');
INSERT INTO USER_tbl VALUES ('u006', '한지우', 'jiu@acorn.com', '010-9803-8293', '남');
INSERT INTO USER_tbl VALUES ('u007', '유건우', 'gunwoo@acorn.com', '010-2088-8332', '남');
INSERT INTO USER_tbl VALUES ('u008', '송다은', 'daeun@acorn.com', '010-9920-1340', '여');
INSERT INTO USER_tbl VALUES ('u009', '배승현', 'seonghyun@acorn.com', '010-3301-9899', '남');
INSERT INTO USER_tbl VALUES ('u010', '오윤서', 'yunseo@acorn.com', '010-7721-3412', '여');

SELECT * FROM USER_TBL; --화원 테이블 확인

--지점 테이블
CREATE TABLE LOCATION_TBL(
    LOC_ID VARCHAR2(15) PRIMARY KEY,                --지점 ID (VARCHAR2(15), 기본키) EX) LOC123
    LOC_NAME VARCHAR2(30) NOT NULL,                 --지점 이름 (VARCHAR2(30))
    LOC_ADDR VARCHAR2(100) NOT NULL,                --주소 (VARCHAR2(100))
    USER_ID CHAR(4) REFERENCES USER_TBL(USER_ID)    --사용자 아이디 (CHAR(4), USER_TBL 참조)
);

--지점 테이블 값 생성
INSERT INTO LOCATION_TBL VALUES ('LO123', '강남역점', '서울특별시 강남구 테헤란로 101', 'u001');
INSERT INTO LOCATION_TBL VALUES ('LO234', '홍대입구점', '서울특별시 마포구 양화로 23', 'u003');
INSERT INTO LOCATION_TBL VALUES ('LO345', '종로점', '서울특별시 종로구 종로 45', 'u005');

SELECT * FROM LOCATION_TBL; --지점 테이블 확인

--INSERT INTO LOCATION_TBL VALUES ('LO456', '잠실점', '서울특별시 송파구 올림픽로 240', 'u007');
--INSERT INTO LOCATION_TBL VALUES ('LO567', '성수점', '서울특별시 성동구 아차산로 35', 'u009');
--INSERT INTO LOCATION_TBL VALUES ('LO678', '용산점', '서울특별시 용산구 한강로2가 11', 'u002');
--INSERT INTO LOCATION_TBL VALUES ('LO789', '신촌점', '서울특별시 서대문구 연세로 50', 'u004');
--INSERT INTO LOCATION_TBL VALUES ('LO890', '이태원점', '서울특별시 용산구 이태원로 12', 'u006');
--INSERT INTO LOCATION_TBL VALUES ('LO901', '광화문점', '서울특별시 종로구 세종대로 89', 'u008');
--INSERT INTO LOCATION_TBL VALUES ('LO012', '동대문점', '서울특별시 중구 장충단로 267', 'u010');

--카테고리 테이블
CREATE TABLE CATEGORY(
    CATEGORY_ID VARCHAR2(10) PRIMARY KEY,                                                  --카테고리 아이디 (VARCHAR2(10), 기본키) EX)CT01
    CATEGORY_NAME VARCHAR2(20) CHECK(CATEGORY_NAME IN ('소설', '에세이', '전문서', '만화'))   --카테고리 이름(VARCHAR2(20), 입력 가능한 값 소설', '에세이', '전문서', '만화' 4개로 제한)
);

--카테고리 값 생성
INSERT INTO CATEGORY VALUES ('CT01', '소설');
INSERT INTO CATEGORY VALUES ('CT02', '에세이');
INSERT INTO CATEGORY VALUES ('CT03', '전문서');
INSERT INTO CATEGORY VALUES ('CT04', '만화');

SELECT * FROM CATEGORY;  --카테고리 테이블 확인

--도서 테이블
CREATE TABLE BOOK(
    BOOK_ID VARCHAR2(10) PRIMARY KEY,                           --책 ID (VARCHAR2(10), 기본키) EX) BK101
    TITLE VARCHAR2(50) NOT NULL,                                --책 제목 (VARCHAR2(50))
    AUTHOR VARCHAR2(50) NOT NULL,                               --책 작가 (VARCHAR2(50))
    BOOK_CNT NUMBER(2) NOT NULL,                                --도서수량 (NUMBER(2))
    BOOK_REMAIN_CNT NUMBER(2) NOT NULL,                         --대출 가능 도서 수량 (NUMBER(2))
    CATEGORY_ID VARCHAR2(10) REFERENCES CATEGORY(CATEGORY_ID)   --카테고리 아이디(VARCHAR2(10), CATEGORY 참조)
);

--도서 값 생성
INSERT INTO BOOK VALUES ('BK101', '백년의 고독', '가브리엘 가르시아 마르케스', 50, 35, 'CT01');
INSERT INTO BOOK VALUES ('BK102', '파우스트', '요한 볼프강 폰 괴테', 50, 45, 'CT01');
INSERT INTO BOOK VALUES ('BK103', '채식주의자', '한강', 50, 40, 'CT01');
INSERT INTO BOOK VALUES ('BK104', '살인자의 기억법', '김영하', 50, 30, 'CT01');
INSERT INTO BOOK VALUES ('BK105', '나미야 잡화점의 기적', '히가시노 게이고', 50, 25, 'CT01');
INSERT INTO BOOK VALUES('BK201', '죽은 자의 집 청소', '김완', 50, 45, 'CT02');
INSERT INTO BOOK VALUES('BK202', '아몬드', '손원평', 50, 30, 'CT02');
INSERT INTO BOOK VALUES('BK203', '나는 나로 살기로 했다', '김수현', 50, 35, 'CT02');
INSERT INTO BOOK VALUES('BK204', '여행의 이유', '김영하', 50, 40, 'CT02');
INSERT INTO BOOK VALUES('BK205', '멈추면, 비로소 보이는 것들', '혜민 스님', 50, 45, 'CT02');
INSERT INTO BOOK VALUES('BK301', '클린 코드', '로버트 C. 마틴', 50, 20, 'CT03');
INSERT INTO BOOK VALUES('BK302', '이코노미스트의 경제학', '그랜트 제임스', 50, 40, 'CT03');
INSERT INTO BOOK VALUES('BK303', '정신분석학 입문', '지그문트 프로이트', 50, 35, 'CT03');
INSERT INTO BOOK VALUES('BK304', '기계학습', '타부 가라오', 50, 45, 'CT03');
INSERT INTO BOOK VALUES('BK305', '리더십의 5가지 장애물', '패트릭 렌시오니', 50, 30, 'CT03');
INSERT INTO BOOK VALUES('BK401', '슬램덩크', '이노우에 다케히코', 50, 20, 'CT04');
INSERT INTO BOOK VALUES('BK402', '진격의 거인', '이사야마 하지메', 50, 25, 'CT04');
INSERT INTO BOOK VALUES('BK403', '나루토', '키시모토 마사시', 50, 15, 'CT04');
INSERT INTO BOOK VALUES('BK404', '유미의 세포들', '이동건', 50, 25, 'CT04');
INSERT INTO BOOK VALUES('BK405', '귀멸의 칼날', '고토게 코요하루', 50, 10, 'CT04');

SELECT * FROM BOOK;  --도서 테이블 확인

--도서 대출 테이블
CREATE TABLE LOAN_TBL(
    LOAN_ID VARCHAR2(10) PRIMARY KEY,                                       --대출 ID (VARCHAR2(10, 기본키) LN001
    LOAN_DATE DATE DEFAULT SYSDATE,                                         --대출일자 (DATE, 기본값을 SYSDATE로 지정)
    DUE_DATE DATE,                                                          --반납일자 (DATE)
    LOAN_STATUS VARCHAR2(15) CHECK(LOAN_STATUS IN ('대출 중', '연체')),       --대출상태 (VARCHAR2(15), 입력값을 '대출 중', '연체' 2개로 제한)
    USER_ID CHAR(4) REFERENCES USER_TBL(USER_ID),                           --사용자 아이디 (CHAR(4), USER_TBL 참조)
    BOOK_ID VARCHAR2(10) REFERENCES BOOK(BOOK_ID)                           --책 아이디 (VARCHAR2(10), BOOK 참조)
);

--도서 대출 값 생성
INSERT INTO LOAN_TBL VALUES ('LN001', TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-03-08', 'YYYY-MM-DD'), '대출 중', 'u003', 'BK101');
INSERT INTO LOAN_TBL VALUES ('LN002', TO_DATE('2025-04-02', 'YYYY-MM-DD'), TO_DATE('2025-04-09', 'YYYY-MM-DD'), '대출 중', 'u004', 'BK102');
INSERT INTO LOAN_TBL VALUES ('LN003', TO_DATE('2025-05-03', 'YYYY-MM-DD'), TO_DATE('2025-05-10', 'YYYY-MM-DD'), '연체', 'u005', 'BK103');
INSERT INTO LOAN_TBL VALUES ('LN004', TO_DATE('2025-06-04', 'YYYY-MM-DD'), TO_DATE('2025-06-11', 'YYYY-MM-DD'), '연체', 'u001', 'BK201');
INSERT INTO LOAN_TBL VALUES ('LN005', TO_DATE('2025-07-05', 'YYYY-MM-DD'), TO_DATE('2025-07-12', 'YYYY-MM-DD'), '대출 중', 'u008', 'BK202');
INSERT INTO LOAN_TBL VALUES ('LN006', TO_DATE('2025-08-06', 'YYYY-MM-DD'), TO_DATE('2025-08-13', 'YYYY-MM-DD'), '연체', 'u009', 'BK203');
INSERT INTO LOAN_TBL VALUES ('LN007', TO_DATE('2025-09-07', 'YYYY-MM-DD'), TO_DATE('2025-09-14', 'YYYY-MM-DD'), '대출 중', 'u002', 'BK301');

SELECT * FROM LOAN_TBL; --도서 대출 테이블 확인

--도서 리뷰 테이블
CREATE TABLE REVIEW(
    REVIEW_ID VARCHAR2(10) PRIMARY KEY,                     --리뷰 아이디 (VARCHAR2(10), 기본키) EX) RE0001
    CONTENTS VARCHAR2(100),                                 --리뷰 내용 (VARCHAR2(100))
    RATING NUMBER(1) CHECK(RATING BETWEEN 1 AND 5),         --평점 (NUMBER(1))
    REVIEW_DATE DATE,                                       --작성 날짜 (DATE)
    USER_ID CHAR(4) REFERENCES USER_TBL(USER_ID),           --사용자 아이디 (CHAR(4), USER_TBL 참조)
    BOOK_ID VARCHAR2(10) REFERENCES BOOK(BOOK_ID)           --책 아이디 (VARCHAR2(10), BOOK 참조)
);

--도서 리뷰 값 생성
INSERT INTO REVIEW VALUES ('RE0001', '읽는 내내 몰입감을 느꼈다.', 5, TO_DATE('2025-01-04', 'YYYY-MM-DD'), 'u001', 'BK101');
INSERT INTO REVIEW VALUES ('RE0002', '문학적으로 뛰어나며 독자에게 많은 생각을 남긴다.', 3, TO_DATE('2025-01-12', 'YYYY-MM-DD'), 'u003', 'BK103');
INSERT INTO REVIEW VALUES ('RE0003', '감정적으로 강한 울림을 주는 작품이다.', 4, TO_DATE('2025-01-27', 'YYYY-MM-DD'), 'u006', 'BK201');
INSERT INTO REVIEW VALUES ('RE0004', '여행을 통한 성찰과 깊은 메시지가 좋았다.', 4, TO_DATE('2025-02-12', 'YYYY-MM-DD'), 'u009', 'BK204');
INSERT INTO REVIEW VALUES ('RE0005', '코드의 품질을 높이는 중요한 원칙들이 담겨 있다.', 5, TO_DATE('2025-02-23', 'YYYY-MM-DD'), 'u001', 'BK301');
INSERT INTO REVIEW VALUES ('RE0006', '기본적인 경제 원리를 잘 설명하고 있다.', 4, TO_DATE('2025-02-25', 'YYYY-MM-DD'), 'u002', 'BK302');
INSERT INTO REVIEW VALUES ('RE0007', '농구와 청춘을 다룬 뛰어난 이야기와 캐릭터들이 돋보인다.', 5, TO_DATE('2025-03-06', 'YYYY-MM-DD'), 'u006', 'BK401');
INSERT INTO REVIEW VALUES ('RE0008', '전개와 캐릭터의 깊이가 매우 인상적이다.', 3, TO_DATE('2025-03-14', 'YYYY-MM-DD'), 'u007', 'BK402');
INSERT INTO REVIEW VALUES ('RE0009', '돈을 저금해야 한다는 것을 알았다', 3, TO_DATE('2025-02-25', 'YYYY-MM-DD'), 'u002', 'BK302');
INSERT INTO REVIEW VALUES ('RE0010', '그냥 볼만 했다', 2, TO_DATE('2025-01-27', 'YYYY-MM-DD'), 'u006', 'BK201');

SELECT * FROM REVIEW; --도서 리뷰 테이블 확인

-- 도서관 좌석 테이블
CREATE TABLE library_seat_tbl(
 seat_id varchar2(10) PRIMARY KEY,                                      --좌석 아이디 (varchar2(10), 기본키) EX) ST01
 seat_position varchar(50) NOT null,                                    --좌석 위치 (varchar(50))
 seat_status NUMBER(2) DEFAULT '1' CHECK (seat_status IN ('0', '1'))    --좌석 상태 (NUMBER(2), 입력값을 '0':자리 없음, '1':자리 있음 으로 제한)
);

--도서관 좌석 값 생성
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st01', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st02', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st03', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st04', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st05', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st06', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st07', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st08', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st09', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st10', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st11', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st12', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st13', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st14', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st15', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st16', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st17', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st18', '1층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st19', '1층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st20', '1층');

INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st21', '2층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st22', '2층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st23', '2층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st24', '2층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st25', '2층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st26', '2층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st27', '2층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st28', '2층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st29', '2층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st30', '2층', 0);

INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st31', '3층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st32', '3층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st33', '3층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st34', '3층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st35', '3층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st36', '3층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st37', '3층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st38', '3층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st39', '3층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st40', '3층', 0);

INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st41', '4층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st42', '4층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st43', '4층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st44', '4층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st45', '4층');
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st46', '4층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st47', '4층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position )VALUES ('st48', '4층');
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st49', '4층', 0);
INSERT INTO library_seat_tbl (seat_id, seat_position, seat_status )VALUES ('st50', '4층', 0);

SELECT * FROM library_seat_tbl; --도서관 좌석 테이블 확인

-- 좌석예약 테이블
CREATE TABLE library_seat_reservation(
 reservation_seat_id varchar2(10) PRIMARY KEY,                                                                                 --좌석예약아이디 (varchar2(10), 기본키) EX) sr01
 reservation_time DATE DEFAULT sysdate,                                                                                        --예약날짜 (DATE, 기본값 현재 날짜)
 reservation_id varchar2(10) REFERENCES library_seat_tbl(seat_id),                                                             --예약 ID (varchar2(10), library_seat_tbl 참조)
 USER_ID CHAR(4) REFERENCES USER_TBL(USER_ID),                                                                                 --사용자 아이디 (CHAR(4), USER_TBL 참조)
 reservation_seat_status varchar2(20) DEFAULT '예약대기' CHECK (reservation_seat_status IN ('예약대기', '예약확인','예약완료'))     --예약좌석상태 (varchar2(20), 기본값 예약대기, 입력값을 '예약대기', '예약확인', '예약완료' 3개로 제한)
);

-- 좌석예약 값 생성
INSERT INTO library_seat_reservation (reservation_seat_id, reservation_time, reservation_id, USER_ID ) VALUES ('sr01', sysdate, 'st05', 'u001');
INSERT INTO library_seat_reservation (reservation_seat_id, reservation_time, reservation_id, USER_ID, reservation_seat_status ) VALUES ('sr02', sysdate, 'st25', 'u003', '예약완료');
INSERT INTO library_seat_reservation (reservation_seat_id, reservation_time, reservation_id, USER_ID ) VALUES ('sr03', sysdate, 'st19', 'u004');
INSERT INTO library_seat_reservation (reservation_seat_id, reservation_time, reservation_id, USER_ID, reservation_seat_status ) VALUES ('sr04', sysdate, 'st46', 'u005', '예약확인');

SELECT * FROM library_seat_reservation; --좌석예약 테이블 확인
------------------------------------------------------------->>
SELECT * FROM USER_TBL; --화원 테이블 확인
SELECT * FROM LOCATION_TBL; --지점 테이블 확인
SELECT * FROM CATEGORY;  --카테고리 테이블 확인
SELECT * FROM BOOK;  --도서 테이블 확인
SELECT * FROM LOAN_TBL; --도서 대출 테이블 확인
SELECT * FROM REVIEW; --도서 리뷰 테이블 확인
SELECT * FROM library_seat_tbl; --도서관 좌석 테이블 확인
SELECT * FROM library_seat_reservation; --좌석예약 테이블 확인

DROP TABLE USER_tbl; --회원 테이블 삭제
DROP TABLE LOCATION_TBL; --지점 테이블 삭제
DROP TABLE CATEGORY; --카테고리 테이블 삭제
DROP TABLE BOOK; --도서 테이블 삭제
DROP TABLE LOAN_TBL; --도서 대출 테이블 삭제
DROP TABLE REVIEW; --도서 리뷰 테이블 삭제
DROP TABLE library_seat_tbl; --도서관 좌석 테이블 삭제
DROP TABLE library_seat_reservation; --좌석예약 테이블 삭제
------------------------------------------------------------->>
--회원별 주요 이용 지점(즐겨찾기)
SELECT U.USER_ID "회원 ID", U.USER_NAME "회원 이름", NVL(L.LOC_NAME, '미정') "지점", NVL(L.LOC_ADDR, '미정') "지점 주소"
FROM USER_TBL U
LEFT OUTER JOIN LOCATION_TBL L
ON U.USER_ID = L.USER_ID;

--USER_TBL[회원 테이블], LOCATION_TBL[지점 테이블 조인
--조인 과정에서 LOCATION_TBL에 없는 USER_TBL 요소도 전부 출력
--NULL인 부분은 미정으로 표시

--도서별 카테고리
SELECT B.BOOK_ID "도서 ID", B.TITLE "도서 제목", B.AUTHOR "저자", C.CATEGORY_NAME "카테고리 값"
FROM BOOK B
JOIN CATEGORY C
ON B.CATEGORY_ID = C.CATEGORY_ID;

--BOOK(도서 테이블)과 CATEGORY(카테고리 테이블)을 조인

-- 대출현황
CREATE VIEW V_LOAN --뷰 생성
AS
    SELECT lt.LOAN_ID "대출 ID", UT.USER_NAME "회원 이름", lt.LOAN_STATUS "대출 여부", b.TITLE "도서 이름", LT.LOAN_DATE "대출일", LT.DUE_DATE "반납일"
    FROM LOAN_TBL lt
    JOIN USER_TBL ut
    ON lt.user_id = ut.USER_ID
    JOIN BOOK b
    ON lt.BOOK_ID = b.BOOK_ID;
    
SELECT * FROM V_LOAN
WHERE "대출 여부" = '대출 중'; --대출 중인 도서 목록 

SELECT * FROM V_LOAN
WHERE "대출 여부" = '연체'; --연체 중인 도서 목록 

--LOAN_TBL(도서 대출 테이블)과 USER_TBL (회원 테이블)과 BOOK(도서 테이블)을 조인
--조인한 후 V_LOAN로 생성
--생성한 뷰를 가져와 WHERE 절로 대출 현황(대출 중, 연체) 표시

-- 전체적인 도서 리뷰확인
CREATE VIEW V_REVIEW --뷰 생성
AS
    SELECT b.BOOK_ID "도서 코드", b.TITLE "도서 제목", r.CONTENTS "리뷰 내용", r.RATING || '점' "평점", C.CATEGORY_NAME "카테고리"
    FROM REVIEW r
    JOIN BOOK b 
    ON r.BOOK_ID = b.BOOK_ID
    JOIN CATEGORY C
    ON B.CATEGORY_ID = C.CATEGORY_ID;
    
SELECT * FROM V_REVIEW; -- 전체적인 도서 리뷰확인

--REVIEW(리뷰 테이블)과 BOOK(책 테이블)과 CATEGORY(카테고리 테이블)을 조인
--조인한 후 V_REVIEW로 생성
--생성한 뷰로 전체 리뷰 목록 표시

--특정(BK201) 도서별 리뷰확인
SELECT * FROM V_REVIEW
WHERE "도서 코드" = 'BK201';

--V_REVIEW 뷰에 WHERE 절로 특정 도서의 도서 코드를 지정 후 해당 도서의 리뷰만 출력

--리뷰 평점 순
SELECT * FROM V_REVIEW
ORDER BY "평점" DESC;

--V_REVIEW 뷰에 ORDER BY로 평점이 높은 순으로 표시

--특정 카테고리(전문서)에 해당되는 리뷰만 표시
SELECT * FROM V_REVIEW
WHERE "카테고리" = '전문서';

--V_REVIEW 뷰에 WHERE 절로 카테고리를 지정하고 그 카테고리에 해당하는 도서의 리뷰만 표시 

-- 회원별 자석 예약 현황
SELECT lsr.RESERVATION_SEAT_ID "좌석 예약 코드" , 
       U.USER_NAME "예약자", 
       lsr.RESERVATION_SEAT_STATUS "예약현황", 
       lsr.RESERVATION_ID "좌석 코드", 
       lst.SEAT_POSITION "층"
FROM library_seat_reservation lsr
JOIN library_seat_tbl lst
ON lsr.RESERVATION_ID = lst.SEAT_ID
JOIN USER_TBL U
ON LSR.USER_ID = U.USER_ID;

--library_seat_reservation(도서관 좌석 테이블), library_seat_tbl(좌석예약 테이블), USER_TBL (회원 테이블)을 조인

--층별 남은 좌석 수 확인
SELECT seat_position "층", count(seat_status) || '개' "남은 좌석 수"
FROM library_seat_tbl
GROUP BY seat_position;

--library_seat_tbl(좌석예약 테이블)에서 seat_status을 COUNT
--(seat_status은 0(없음), 1(있음)으로 나뉘어져 있음. COUNT로 1(있음)을 전부 계산해서 남은 좌석을 표시)
------------------------------------------------------------->>

SELECT seat_position "층", count(seat_status)
FROM library_seat_tbl
group by seat_position;

SELECT seat_position "층", decode(seat_status, 1, 1)
FROM library_seat_tbl;

SELECT seat_position "층", count(decode(seat_status, 1, 1)) "남은 좌석"
FROM library_seat_tbl
group by seat_position
order by seat_position;












