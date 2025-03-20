CREATE TABLE CUST_INFO(
 ID VARCHAR2(13) NOT NULL PRIMARY KEY ,
 FIRST_NM  VARCHAR2(10)   ,
 LAST_NM   VARCHAR2(10)   ,
 ANNL_PERF NUMBER(10,2)  
);
 COMMIT;

INSERT INTO CUST_INFO VALUES ('8301111567897' , 'JHUN' , 'KIM', 330.08);
 INSERT INTO CUST_INFO VALUES ('9302112567897' , 'JINYOUNG' , 'LEE', 857.61);
 INSERT INTO CUST_INFO VALUES ('8801111567897' , 'MIJA' , 'HAN', -76.77);
 INSERT INTO CUST_INFO VALUES ('9901111567897' , 'YOUNGJUN' , 'HA', 468.54);
 INSERT INTO CUST_INFO VALUES ('9801112567897' , 'DAYOUNG' , 'SUNG', -890);
 INSERT INTO CUST_INFO VALUES ('9701111567897' , 'HYEJIN' , 'SEO', 47.44);
 COMMIT;
 
 --문제) MEMBER_TBL_11 테이블로부터 고객등급 조회하기
 --SELECT M_GRADE 
 --FROM MEMBER_TBL_11 ;
 select m_grade
 from member_tbl_11;

 --문제) MEMBER_TBL_11 테이블로부터 고객등급 조회하기, 중복된 값 제외하고 조회하기
 select distinct m_grade
 from member_tbl_11;
 --문제) 고객테이블로부터 아이디  USERID라는 이름으로 조회하기 (AS 는 생략가능함)
 select id userid
 from CUST_INFO;
 --문제) 고객테이블로부터 이름에 ‘님’자를 붙여 NAME이라는 컬럼으로이 조회되도록 하시오
 select initcap(FIRST_NM) || '님' NAME
 from CUST_INFO;
 
-- <문자함수>

--문제) 고객정보 테이블로부터 주민번호 7번째 숫자 (성별을 나타내는)를 추출하여 GENDER 라는 이름으로 주민번호
--와 함께 조회하시오
select substr(id,7,1) Gender
 from CUST_INFO;


--문제) 고객정보 테이블로부터  주민번호,  LAST_NM을 모두 소문자로 조회되도록 하시오
--
select id, lower(LAST_NM)
from cust_info;

--문제) 고객정보 테이블로부터 DM발송을 위해서  NAME이라는 이름으로  
--KIM, JIHOON 과 같은형식으로 조회될 수 있도록 하시오
--
select last_nm || ', '||first_nm NAME
from cust_info;

--<숫자함수>
--문제) 고객정보 테이블로부터 고객 주민번호, 수익을 소수 둘째에서 반올림하여 소수 첫째자리까지 표시될 수 있도
--록 조회 하시오
--
select id, round(annl_perf,1)
from cust_info;


--문제)
--고객정보 테이블로부터 고객 주민번호, 수익을 소수 첫째에서 버림하여 정수로 나타낼수 있도록 조회하시오

select id, trunc(annl_perf), floor(annl_perf)
from cust_info;
 
 
-- <날짜함수>
--문제)
--현재날짜를 조회하시오
select sysdate from dual;
 
 
-- <조건식>
--문제) 고객테이블로부터 주민번호 , 수익이 300이사이면 고수익 100이상은 일반수익 0이하이면 손해 , 나머지는 변
--동없음 내용이 RESULT컬럼명으로 조회될 수 있도록 하시오
select id, case when annl_perf>=300 then '고수익'
                when annl_perf>=100 then '일반수익'
                when annl_perf<=0 then '손해'
                else '변동없음'
           end  Result
from cust_info;

 
-- <기타함수>
-- 문제) 고객테이블로부터 이름과 포인트를 조회하시오
--(단 포인트가 적립되지 않은 고객은 0으로 표시되도록 하시오)  힌트:NVL 함수 사용
SELECT * FROM MEMBER_TBL_11;

SELECT M_NAME, NVL(M_POINT,0) FROM member_tbl_11;
 
 
-- 문제) 힌트: NVL2함수를 사용하세요
--고객테이블로부터 기존포인트 점수에서 100포인트씩 인상하려고 합니다.  NEXT_POINT라는 컬럼으로 조회되도록 하
--시오, 고객이름, 포인트와 함께 조회하시오 ( 기존포인트가 없는 사람은 0포인트로 간주합니다
  SELECT M_NAME, NVL(M_POINT,0) AS "POINT", NVL2(M_POINT, M_POINT+100,0) AS "NEXT_POINT"
  FROM member_tbl_11;
