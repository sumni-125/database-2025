-- 1. 환자 데이터
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1001, '김민수', 'M', DATE '1985-03-15', '01012345678');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1002, '이영희', 'F', DATE '1990-07-22', '01023456789');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1003, '박지훈', 'M', DATE '1978-11-05', '01034567890');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1004, '정수빈', 'F', DATE '1988-01-30', '01045678901');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1005, '최동혁', 'M', DATE '1965-06-10', '01056789012');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1006, '한서진', 'F', DATE '1992-08-20', '01067890123');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1007, '오경민', 'M', DATE '1980-12-12', '01078901234');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1008, '서민수', 'F', DATE '1995-04-04', '01089012345');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1009, '황재원', 'M', DATE '1978-09-09', '01090123456');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1010, '문예진', 'F', DATE '1987-11-11', '01001234567');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1011, '조지훈', 'M', DATE '1982-05-05', '01011223344');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1012, '윤수민', 'F', DATE '1993-03-03', '01022334455');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1013, '강다은', 'F', DATE '1986-07-07', '01033445566');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1014, '임상혁', 'M', DATE '1979-02-14', '01044556677');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1015, '신지은', 'F', DATE '1990-09-09', '01055667788');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1016, '장민재', 'M', DATE '1983-12-12', '01066778899');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1017, '정은비', 'F', DATE '1988-08-08', '01077889900');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1018, '홍성민', 'M', DATE '1976-04-04', '01088990011');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1019, '배수빈', 'F', DATE '1991-06-06', '01099001122');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1020, '류하은', 'F', DATE '1984-10-10', '01010111222');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1021, '민경호', 'M', DATE '1989-02-20', '01020203040');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1022, '서하린', 'F', DATE '1991-05-15', '01030304050');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1023, '윤승우', 'M', DATE '1977-11-30', '01040405060');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1024, '박채원', 'F', DATE '1986-08-08', '01050506070');
INSERT INTO patient_tbl (patient_id, name, gender, birthday, tel) VALUES (1025, '홍재영', 'M', DATE '1983-03-03', '01060607080');
COMMIT;

-- 2. 진료과 데이터
INSERT INTO department_tbl VALUES ('A01', '일반내과', '02-1234-0001', '1001');
INSERT INTO department_tbl VALUES ('A02', '내분비내과', '02-1234-0002', '1002');
INSERT INTO department_tbl VALUES ('A03', '소화기내과', '02-1234-0003', '1003');
INSERT INTO department_tbl VALUES ('B01', '일반외과', '02-2345-0001', '2001');
INSERT INTO department_tbl VALUES ('B02', '정형외과', '02-2345-0002', '2002');
INSERT INTO department_tbl VALUES ('B03', '신경외과', '02-2345-0003', '2003');
INSERT INTO department_tbl VALUES ('C01', '소아내과', '02-3456-0001', '3001');
INSERT INTO department_tbl VALUES ('C02', '소아외과', '02-3456-0002', '3002');
INSERT INTO department_tbl VALUES ('C03', '소아정형외과', '02-3456-0003', '3003');
INSERT INTO department_tbl VALUES ('D01', '응급의학과', '02-4567-0001', '4001');
INSERT INTO department_tbl VALUES ('D02', '산부인과', '02-4567-0002', '4002');
INSERT INTO department_tbl VALUES ('D03', '마취통증의학과', '02-4567-0003', '4003');
INSERT INTO department_tbl VALUES ('D04', '영상의학과', '02-4567-0004', '4004');
COMMIT;

-- 3. 의사 데이터
-- 일반내과 (A01)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3001, '김민준', 'M', DATE '1970-05-10', 'A01', 3, '월,수,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3002, '이서준', 'M', DATE '1980-08-15', 'A01', 2, '화,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3003, '박동혁', 'M', DATE '1975-03-20', 'A01', 4, '월,화,목');

-- 내분비내과 (A02)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3004, '최윤정', 'F', DATE '1978-11-22', 'A02', 4, '화,수,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3005, '오지훈', 'M', DATE '1972-02-28', 'A02', 3, '월,수,목');

-- 소화기내과 (A03)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3006, '정동윤', 'M', DATE '1968-12-12', 'A03', 3, '월,수,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3007, '유소희', 'F', DATE '1979-09-09', 'A03', 4, '화,목,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3008, '강성민', 'M', DATE '1982-04-04', 'A03', 2, '월,화');

-- 일반외과 (B01)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3009, '조현우', 'M', DATE '1970-06-06', 'B01', 3, '월,수,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3010, '문지후', 'M', DATE '1980-10-10', 'B01', 1, '화,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3011, '임동호', 'M', DATE '1976-03-03', 'B01', 4, '월,수,목,금');

-- 정형외과 (B02)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3012, '신재훈', 'M', DATE '1975-07-15', 'B02', 4, '월,화,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3013, '서민지', 'F', DATE '1983-11-11', 'B02', 3, '화,수,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3014, '윤서영', 'F', DATE '1987-05-05', 'B02', 1, '월,화');

-- 신경외과 (B03)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3015, '김재민', 'M', DATE '1972-08-08', 'B03', 3, '화,수,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3016, '박지현', 'F', DATE '1980-04-14', 'B03', 2, '월,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3017, '장상우', 'M', DATE '1978-12-30', 'B03', 4, '월,화,목,금');

-- 소아내과 (C01)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3018, '한수민', 'F', DATE '1985-01-01', 'C01', 4, '월,화,수,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3019, '이예린', 'F', DATE '1990-02-02', 'C01', 3, '월,화,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3020, '정민지', 'F', DATE '1982-03-03', 'C01', 2, '수,금');

-- 소아외과 (C02)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3021, '오승현', 'M', DATE '1976-04-04', 'C02', 3, '월,화,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3022, '강다영', 'F', DATE '1988-08-08', 'C02', 1, '화,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3023, '류지은', 'F', DATE '1983-09-09', 'C02', 4, '월,수,금');

-- 소아정형외과 (C03)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3024, '황정훈', 'M', DATE '1970-10-10', 'C03', 3, '월,수,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3025, '조은비', 'F', DATE '1985-12-12', 'C03', 4, '월,화,목');

-- 응급의학과 (D01)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3026, '최진우', 'M', DATE '1969-06-06', 'D01', 3, '월,화,수');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3027, '박서연', 'F', DATE '1982-11-11', 'D01', 4, '월,화,목,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3028, '유동혁', 'M', DATE '1974-03-03', 'D01', 2, '화,금');

-- 산부인과 (D02)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3029, '홍예진', 'F', DATE '1980-01-15', 'D02', 3, '월,수,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3030, '정현수', 'M', DATE '1979-05-05', 'D02', 4, '화,목,금');

-- 마취통증의학과 (D03)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3031, '문지호', 'M', DATE '1970-09-09', 'D03', 3, '화,수,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3032, '신은비', 'F', DATE '1985-10-10', 'D03', 4, '월,목,금');

-- 영상의학과 (D04)
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3033, '김태훈', 'M', DATE '1972-02-02', 'D04', 3, '월,화,목');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3034, '오세훈', 'M', DATE '1980-04-04', 'D04', 4, '화,수,목,금');
INSERT INTO doctor_tbl (doctor_id, name, gender, birthday, dept_id, class, available_days) VALUES (3035, '강지우', 'F', DATE '1988-08-08', 'D04', 1, '월,금');
COMMIT;

-- 예약 데이터
INSERT INTO reservation_tbl VALUES (4000, 1001, 3027, TO_DATE('2025-03-26', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4001, 1002, 3033, TO_DATE('2025-03-26', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4002, 1003, 3014, TO_DATE('2025-03-26', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4003, 1004, 3031, TO_DATE('2025-03-26', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4004, 1005, 3022, TO_DATE('2025-03-26', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4005, 1006, 3008, TO_DATE('2025-03-27', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4006, 1007, 3019, TO_DATE('2025-03-27', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4007, 1008, 3035, TO_DATE('2025-03-27', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4008, 1009, 3002, TO_DATE('2025-03-27', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4009, 1010, 3034, TO_DATE('2025-03-27', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4010, 1011, 3029, TO_DATE('2025-03-28', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4011, 1012, 3015, TO_DATE('2025-03-28', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4012, 1013, 3026, TO_DATE('2025-03-28', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4013, 1014, 3003, TO_DATE('2025-03-28', 'YYYY-MM-DD'), 2);
INSERT INTO reservation_tbl VALUES (4014, 1015, 3020, TO_DATE('2025-03-28', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4015, 1016, 3011, TO_DATE('2025-03-31', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4016, 1017, 3024, TO_DATE('2025-03-31', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4017, 1018, 3029, TO_DATE('2025-03-31', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4018, 1019, 3032, TO_DATE('2025-03-31', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4019, 1020, 3021, TO_DATE('2025-03-31', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4020, 1021, 3030, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4021, 1022, 3016, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4022, 1023, 3025, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4023, 1024, 3007, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4024, 1025, 3034, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4025, 1001, 3035, TO_DATE('2025-04-02', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4026, 1002, 3027, TO_DATE('2025-04-02', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4027, 1003, 3018, TO_DATE('2025-04-02', 'YYYY-MM-DD'), 3);
INSERT INTO reservation_tbl VALUES (4028, 1004, 3014, TO_DATE('2025-04-02', 'YYYY-MM-DD'), 1);
INSERT INTO reservation_tbl VALUES (4029, 1005, 3034, TO_DATE('2025-04-02', 'YYYY-MM-DD'), 3);
COMMIT;

-- 진료기록 데이터
INSERT INTO medical_record_tbl VALUES (5000, 4000, 60000, '화상');
INSERT INTO medical_record_tbl VALUES (5001, 4001, 55000, '골절');
INSERT INTO medical_record_tbl VALUES (5002, 4003, 72000, '두통');
INSERT INTO medical_record_tbl VALUES (5003, 4005, 68000, '역류성 식도염');
INSERT INTO medical_record_tbl VALUES (5004, 4006, 64000, '감기');
INSERT INTO medical_record_tbl VALUES (5005, 4008, 75000, '소화불량');
INSERT INTO medical_record_tbl VALUES (5006, 4010, 56000, '생리통');
INSERT INTO medical_record_tbl VALUES (5007, 4012, 67000, '급성 알레르기');
INSERT INTO medical_record_tbl VALUES (5008, 4013, 73000, '고혈압');
COMMIT;