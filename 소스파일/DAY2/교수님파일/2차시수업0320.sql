

-- 페이지 120
-- 퀴즈1
SELECT *
FROM STUDENT;

SELECT NAME, JUMIN , SUBSTR( JUMIN, 7,1)
FROM STUDENT;


SELECT NAME, JUMIN , DECODE( SUBSTR( JUMIN, 7,1) ,'1','남자','2', '여자')
FROM STUDENT;


-- 퀴즈2 -- 

SELECT  NAME, TEL
FROM STUDENT;

SELECT  NAME, TEL,  SUBSTR( TEL ,1,3)
FROM STUDENT; 



SELECT  NAME, TEL, DECODE( SUBSTR( TEL ,1,3) ,'031' , '경기'  ,'051', '부산' , '052' ,'울산'  , '055', '경남' , '서울')
FROM STUDENT; 


SELECT  NAME, TEL, DECODE( SUBSTR( TEL ,1,3) ,'031' , '경기'  ,'051', '부산' , '052' ,'울산'  , '055', '경남' ,  '02)'  ,'서울'   ,' ' )
FROM STUDENT; 

--국번 확인하기
SELECT NAME,   SUBSTR(TEL ,1,3)
FROM STUDENT;


-- ) 위치 얻어오기
SELECT NAME,  TEL,  INSTR(TEL ,')')
FROM STUDENT;

-- ) 위치를 기반으로 국번 얻어오기
SELECT NAME,  TEL,  INSTR(TEL ,')')  ,  INSTR(TEL ,')') -1
FROM STUDENT;


SELECT NAME,  TEL,  SUBSTR( TEL,1,   INSTR(TEL ,')') -1 )
FROM STUDENT;




SELECT NAME,   SUBSTR(TEL , 1,  INSTR(TEL ,')') -1  )  ,
DECODE( SUBSTR(TEL , 1,  INSTR(TEL ,')') -1  )   ,'02','서울','051','부산','051','부산','055','경남')
FROM STUDENT;



SELECT *
FROM STUDENT;



-- NVL  
-- NVL2

-- NULL
SELECT * FROM MEMBER_TBL_11;

-- 100+1000 =>1100
-- NULL( 값이 정해지지 않은 상태)+1000  =>   NULL 
-- NULL에 연산을 하면 결과가 NULL이다 


SELECT M_POINT +1000
FROM MEMBER_TBL_11;

SELECT M_POINT,   NVL(M_POINT  , 0) FROM MEMBER_TBL_11;

--NVL2(널이 아닐때 , 널일때)
SELECT M_POINT , NVL( M_POINT+100 , 200)
FROM MEMBER_TBL_11;



-- CASE WHEN 

SELECT M_POINT
FROM MEMBER_TBL_11;



SELECT M_POINT , CASE  WHEN  M_POINT >=3000 THEN  '상'
                       WHEN  M_POINT >=2000 THEN  '중'
                       ELSE  '하'
                 END  AS   "RESULT !!"     -- 별칭을 줄 때 스페이스나 대소문자구분하고 싶으면 쌍따옴표 사용
FROM MEMBER_TBL_11;





--3번째 문제 풀이 










