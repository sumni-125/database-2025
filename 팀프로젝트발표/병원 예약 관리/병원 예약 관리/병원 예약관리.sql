-- 1. 환자 테이블
CREATE TABLE patient_tbl (
    patient_id NUMBER(10) PRIMARY KEY, -- 환자 등록번호
    name VARCHAR2(50) NOT NULL, -- 이름
    gender CHAR(1) CHECK (gender IN ('M', 'F')) NOT NULL, -- 성별 (M/F)
    birthday DATE NOT NULL, -- 생년월일
    tel VARCHAR2(15) -- 연락처
);
COMMIT;

-- 2. 진료과 테이블
CREATE TABLE department_tbl (
    dept_id VARCHAR2(10) PRIMARY KEY, -- 진료과 ID (내과 A, 외과 B, 소아과 C, 기타과 D)
    dept_name VARCHAR2(50) NOT NULL, -- 진료과 이름
    dept_tel VARCHAR2(15), -- 대표번호
    dept_extension VARCHAR2(15) -- 내선 번호
);
COMMIT;

-- 3. 의사 테이블
CREATE TABLE doctor_tbl (
    doctor_id NUMBER(10) PRIMARY KEY, -- 의사 등록번호
    dept_id VARCHAR2(10) REFERENCES department_tbl(dept_id), -- 진료과 ID
    name VARCHAR2(50) NOT NULL, -- 이름 
    gender CHAR(1) CHECK (gender IN ('M', 'F')), -- 성별 (M/F)
    birthday DATE, -- 생년월일(나이)
    class NUMBER(1) CHECK (class IN (1, 2, 3, 4)), -- 직급 (레지던트 1, 펠로우 2, 교수 3, 과장 4)
    available_days VARCHAR2(20) -- 진료 요일
);
COMMIT;

-- 4. 예약 테이블
CREATE TABLE reservation_tbl (
    res_id NUMBER(10) PRIMARY KEY, -- 예약번호
    patient_id NUMBER(10) REFERENCES patient_tbl(patient_id), -- 환자 등록번호
    doctor_id NUMBER(10) REFERENCES doctor_tbl(doctor_id), -- 의사 등록번호
    res_datetime DATE, -- 예약 일시
    status NUMBER(1) CHECK (status IN (1, 2, 3)) -- 예약 상태 (예약 중 1, 진료 완료 2, 취소 3)
);
COMMIT;

-- 5. 진료 기록 테이블
CREATE TABLE medical_record_tbl (
    record_id NUMBER(10) PRIMARY KEY, -- 진료번호
    res_id NUMBER(10) REFERENCES reservation_tbl(res_id), -- 예약번호
    cost NUMBER CHECK (cost >= 0), -- 진료비
    diagnosis VARCHAR2(50) -- 진단명
);
COMMIT;



select * from patient_tbl;
select * from department_tbl;
select * from doctor_tbl;
select * from reservation_tbl;
select * from medical_record_tbl;



-- 환자측 인터페이스
-- 본인정보
SELECT patient_id "환자 등록번호", 
       name "이름",
       DECODE(gender, 'M', '남', 'F', '여') "성별",
       TO_CHAR (birthday, 'YY"년 "MM"월 "DD"일"') || '(' || TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)/12) || '세)' "생년월일",
       SUBSTR(tel, 1, 3) || '-' || SUBSTR(tel, 4, 4) || '-' || SUBSTR(tel, 8, 4) "전화번호"
FROM patient_tbl;

-- 진료과 정보
SELECT d.dept_name "진료과", 
       d.dept_tel "대표번호", 
       o.name "의사명"
FROM department_tbl D
JOIN doctor_tbl O
ON d.dept_id = o.dept_id;

-- 의사 정보
SELECT NAME "의사명", 
       DECODE(gender, 'M', '남', 'F', '여') "성별", 
       TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)/12) "나이", 
       DECODE(CLASS, 1, '레지던트', 2, '펠로우', 3, '교수',4 ,'과장') "직급", 
       AVAILABLE_DAYS "진료일"
FROM doctor_tbl;


-- 예약하기
WITH numbers AS (
  SELECT LEVEL - 1 AS n
  FROM dual
  CONNECT BY LEVEL <= 30
),
available_dates AS (
  SELECT d.doctor_id,
         TRUNC(SYSDATE) + n AS available_date
  FROM doctor_tbl d
  CROSS JOIN numbers
  WHERE n < 7
    -- 토요일과 일요일은 제외
    AND TO_CHAR(TRUNC(SYSDATE) + n, 'DY', 'NLS_DATE_LANGUAGE=KOREAN') NOT IN ('토', '일')
    -- 의사의 available_days에 포함된 요일만 선택
    AND TO_CHAR(TRUNC(SYSDATE) + n, 'DY', 'NLS_DATE_LANGUAGE=KOREAN')
         IN (
             SELECT REGEXP_SUBSTR(d.available_days, '[^,]+', 1, LEVEL)
             FROM dual
             CONNECT BY LEVEL <= LENGTH(d.available_days) - LENGTH(REPLACE(d.available_days, ',', '')) + 1
         )
)
SELECT DISTINCT d.dept_name AS "진료과", 
       o.name AS "의사명", 
       TO_CHAR(a.available_date, 'YY"년 "MM"월" DD"일"') AS "예약 가능 날짜"
FROM available_dates a
JOIN doctor_tbl o ON a.doctor_id = o.doctor_id
JOIN department_tbl d ON d.dept_id = o.dept_id
LEFT JOIN reservation_tbl r 
       ON a.doctor_id = r.doctor_id 
       AND a.available_date = TRUNC(r.res_datetime)
WHERE r.res_id IS NULL
ORDER BY 3,1;

-- 예약 내역 확인
SELECT d.dept_name "진료과", 
       o.name "의사명", 
       TO_CHAR(r.res_datetime, 'YY"년 "MM"월" DD"일"') "예약날짜"
FROM reservation_tbl R
JOIN doctor_tbl O
ON R.doctor_id = o.doctor_id
JOIN department_tbl D
ON d.dept_id = o.dept_id
WHERE r.res_datetime > SYSDATE AND r.status = 1;

-- 진료 내역 확인
SELECT d.dept_name "진료과", 
       o.name "의사명", 
       TO_CHAR(R.res_datetime, 'YY"년 "MM"월" DD"일"') "진료일", 
       m.diagnosis "진단명", 
       TO_CHAR(m.cost, '999,999,999') || '원' "진료비"
FROM (SELECT doctor_id, res_id, res_datetime  FROM reservation_tbl WHERE status=2) R
JOIN doctor_tbl O
ON R.doctor_id = o.doctor_id
JOIN department_tbl D
ON d.dept_id = o.dept_id
JOIN medical_record_tbl M
ON m.res_id = r.res_id
ORDER BY r.res_datetime;



-- 병원측 인터페이스
-- 환자 정보 조회
SELECT
    patient_id AS 환자등록번호,
    name AS 이름,
    DECODE(gender, 'M', '남', 'F', '여') AS 성별,
    TO_CHAR(birthday, 'YY"년 "MM"월 "DD"일"') AS 생년월일,
    TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)/12) || '세' AS 나이,
    SUBSTR(tel, 1, 3) || '-' || SUBSTR(tel, 4, 4) || '-' || SUBSTR(tel, 8, 4) AS 연락처
FROM patient_tbl
ORDER BY patient_id;

-- 특정 환자 진료기록 조회
SELECT
    p.patient_id AS 환자등록번호,
    p.name AS 이름,
    m.record_id AS 진료번호,
    dept.dept_name AS 진료과,
    d.name AS 담당의사,
    m.diagnosis AS 병명,
    TO_CHAR(r.res_datetime, 'YY"년 "MM"월" DD"일"') AS 진료일시,
    TO_CHAR(m.cost, '999,999,999') || '원' AS 진료비
FROM medical_record_tbl m
JOIN reservation_tbl r ON m.res_id = r.res_id
JOIN patient_tbl p ON r.patient_id = p.patient_id
JOIN doctor_tbl d ON r.doctor_id = d.doctor_id
JOIN department_tbl dept ON d.dept_id = dept.dept_id
ORDER BY r.res_datetime;

-- 예약 내역 확인
SELECT
    p.patient_id AS 환자등록번호,
    p.name AS 이름,
    r.res_id AS 예약번호,
    dept.dept_name AS 진료과,
    d.name AS 담당의사,
    TO_CHAR(r.res_datetime, 'YY"년 "MM"월" DD"일"') AS 예약일시,
    CASE r.status
        WHEN 1 THEN '예약 중'
        WHEN 2 THEN '진료 완료'
        WHEN 3 THEN '예약 취소'
    END AS 예약상태
FROM reservation_tbl r
JOIN patient_tbl p ON r.patient_id = p.patient_id
JOIN doctor_tbl d ON r.doctor_id = d.doctor_id
JOIN department_tbl dept ON d.dept_id = dept.dept_id
WHERE r.res_datetime > SYSDATE
ORDER BY r.res_datetime;

-- 당일 예약 환자 리스트
SELECT
    TO_CHAR(r.res_datetime, 'YYYY"년" MM"월" DD"일"') AS 예약일시,
    p.patient_id AS 환자등록번호,
    p.name AS 이름,
    r.res_id AS 예약번호,
    dept.dept_name AS 진료과,
    d.name AS 담당의사,
    dept.dept_extension AS 내선번호
FROM reservation_tbl r
JOIN patient_tbl p ON r.patient_id = p.patient_id
JOIN doctor_tbl d ON r.doctor_id = d.doctor_id
JOIN department_tbl dept ON d.dept_id = dept.dept_id
WHERE TRUNC(r.res_datetime) = TRUNC(SYSDATE)
  AND r.status = 1
ORDER BY r.res_datetime;

-- 진료과 예약 관리
SELECT
    dept.dept_id AS 진료과ID,
    dept.dept_name AS 진료과이름,
    d.doctor_id AS 의사등록번호,
    d.name AS 의사명,
    dept.dept_extension AS 내선번호,
    TO_CHAR(r.res_datetime, 'YY"년 "MM"월" DD"일"') AS 예약일시,
    p.patient_id AS 환자등록번호,
    p.name AS 환자이름
FROM reservation_tbl r
JOIN patient_tbl p ON r.patient_id = p.patient_id
JOIN doctor_tbl d ON r.doctor_id = d.doctor_id
JOIN department_tbl dept ON d.dept_id = dept.dept_id
ORDER BY 6, 2;

-- 의사 정보 등록 및 수정
SELECT
    d.doctor_id AS 의사등록번호,
    d.name AS 의사이름,
    DECODE(d.gender, 'M', '남', 'F', '여') AS 성별,
    TRUNC(MONTHS_BETWEEN(SYSDATE, d.BIRTHDAY)/12) || '세' AS 나이,
    dept.dept_name AS 진료과,
    CASE d.class
        WHEN 1 THEN '레지던트'
        WHEN 2 THEN '펠로우'
        WHEN 3 THEN '교수'
        WHEN 4 THEN '과장'
    END AS 직급
FROM doctor_tbl d
JOIN department_tbl dept ON d.dept_id = dept.dept_id
ORDER BY dept.dept_name desc;