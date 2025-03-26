

--문제풀이 211


--4 (혜린님)
desc emp;
SELECT nvl (to_char (deptno), 'total'), 
       SUM(CASE WHEN job = 'CLERK' THEN sal ELSE 0 END) AS CLERK,
       SUM(CASE WHEN job = 'MANAGER' THEN sal ELSE 0 END) AS MANAGER,
       SUM(CASE WHEN job = 'PRESIDENT' THEN sal ELSE 0 END) AS PRESIDENT,
       SUM(CASE WHEN job = 'ANALYST' THEN sal ELSE 0 END) AS ANALYST,
       SUM(CASE WHEN job = 'SALESMAN' THEN sal ELSE 0 END) AS SALESMAN,
       SUM(sal) AS TOTAL
FROM emp
GROUP BY rollup (deptno) 
ORDER BY deptno;


--5 (정호님)
SELECT DEPTNO, ENAME, SAL, SUM(SAL) OVER(ORDER BY SAL) "TOTAL"
FROM EMP;
--7
--8 (민환님)
select deptno, ename, sal, 
sum(sal) over( partition by  deptno order by sal) "total"
from emp;

--9 (유민님)
--9번
SELECT * FROM EMP;

SELECT DEPTNO, ENAME, SAL, SUM(SAL) OVER() AS TOTAL_SAL ,ROUND(SAL/SUM(SAL) OVER() * 100 , 2 ) AS "%"
FROM EMP;

SELECT DEPTNO, ENAME, SAL, SUM(SAL) OVER() AS TOTAL_SAL, ROUND(RATIO_TO_REPORT(SAL) OVER() * 100 , 2 ) AS "%"
FROM EMP;



--
CREATE TABLE t_emp
(
eid VARCHAR2(13) NOT NULL PRIMARY KEY ,
ename VARCHAR2(20) ,
salary NUMBER(5) ,
deptno NUMBER(5) ,
comm NUMBER(5) 
);
COMMIT;
INSERT INTO t_emp VALUES ('e001' , '신동엽' , 280,10,100) ;
INSERT INTO t_emp VALUES ('e002' , '유재석' , 250,20,50) ;
INSERT INTO t_emp VALUES ('e003' , '전현무' , 190,30,0) ;
INSERT INTO t_emp VALUES ('e004' , '양세영' , 300,20,0) ;
INSERT INTO t_emp VALUES ('e005' , '양세찬' , 290,40,100) ;
CREATE TABLE t_dept
(
deptno NUMBER(5) NOT NULL PRIMARY KEY ,
dname VARCHAR2(20) 
);
COMMIT;
INSERT INTO t_dept VALUES (10 , '영업팀') ;
INSERT INTO t_dept VALUES (20 , '기획팀') ;
INSERT INTO t_dept VALUES (30 , '관리팀') ;
INSERT INTO t_dept VALUES (40 , '마케팅팀') ;
INSERT INTO t_dept VALUES (50 , '재무팀') ;

commit;

SELECT * FROM t_emp;
SELECT * FROM T_DEPT;



--뷰만들기 
CREATE VIEW  V_EMP
AS 
  SELECT ENAME, DEPTNO
  FROM T_EMP;


SELECT * FROM V_EMP;

--


-- 
SELECT * 
FROM TBL_TEST_ORDER O
JOIN TBL_TEST_GOODS G
ON O.PCODE  = G.PCODE;

-- 
SELECT O.ODATE, G.PNAME, O.SALE_CNT , G.PRICE
FROM TBL_TEST_ORDER O
JOIN TBL_TEST_GOODS G
ON O.PCODE  = G.PCODE;


--뷰 만들기
CREATE VIEW  V_ORDER_TEST
AS
    SELECT O.ODATE, G.PNAME, O.SALE_CNT , G.PRICE
    FROM TBL_TEST_ORDER O
    JOIN TBL_TEST_GOODS G
    ON O.PCODE  = G.PCODE;


SELECT * FROM V_ORDER_TEST;


--
SELECT * FROM V_ORDER_TEST
WHERE SALE_CNT >=4;


--뷰의 종류
--단순뷰 ( 한 개의 테이블로 뷰 만들기)
--복합뷰 ( 조인테이블로 뷰 만들기)
--인라인 뷰   --- > 서브쿼리의 종류 


--TBL_TEST_ORDER
--TBL_TEST_GOODS
--TBL_TEST_CUSTOMER


SELECT * FROM TBL_TEST_CUSTOMER;

--
DELETE  FROM TBL_TEST_CUSTOMER  WHERE  ID='H007';
COMMIT;

-- 인라인뷰 경험하기 
-- 고객별 판매수량 합계 구하기 


--1) 고객별 판매수량의 합계 구하기 
--2) 고객테이블과 조인하여 결과 만들기 


SELECT * FROM TBL_TEST_ORDER ;


SELECT  ID, SALE_CNT FROM TBL_TEST_ORDER ;
--

SELECT  ID,  SUM(SALE_CNT) 
FROM TBL_TEST_ORDER 
GROUP BY ID;





 SELECT  * 
 FROM ( 
    SELECT  ID,  SUM(SALE_CNT) 
    FROM TBL_TEST_ORDER 
    GROUP BY ID
    ) A
  JOIN TBL_TEST_CUSTOMER C
  ON A.ID  = C.ID;




 SELECT  C.NAME, A.CNT
 FROM ( 
    SELECT  ID,  SUM(SALE_CNT) CNT
    FROM TBL_TEST_ORDER 
    GROUP BY ID
    ) A
  JOIN TBL_TEST_CUSTOMER C
  ON A.ID  = C.ID;

--서브쿼리   : 하나의 쿼리 안에  또 다른 쿼리가 있는 것을 서브쿼리라고 한다 



--뷰만들기
--CREATE VIEW  뷰이름
--AS
--SELECT절 

--(테이블 한개 - 단순뷰 )
--(테이블 여러개  - 복합뷰)
-- FROM절 뒤에 오는  서브쿼리 (   )가 인라인 뷰라고 한다.




--서브쿼리 
SELECT * FROM T_EMP;
--신동엽 사원보다  급여가 더 많은 사원이름, 급여, 상여금 조회 하시오
SELECT  SALARY FROM T_EMP WHERE   ENAME='신동엽';    --280이 조회됨 

SELECT * FROM T_EMP
WHERE SALARY  > 280;


-- 성공한 서브쿼리로 변경 
SELECT * FROM T_EMP
WHERE SALARY  > (SELECT  SALARY FROM T_EMP WHERE   ENAME='신동엽');
--단일행 서브쿼리 연산 = ,  <> ,  >= ,<= ,> ,< 
--단일행 서브쿼리 ( 서브쿼리의 결과가 한 개의 행일 때 , 한 개의 값일 때 )
--신동엽의 급여는 280 한 개가 나옴 => 단일행 서브쿼리이다 


--P429. 연습문제1)

 select * from student;
 select * from department;
 
 --103 
 select deptno1 from  student
 where name  ='Anthony Hopkins';
 
 
 select  * from student 
 where  deptno1 =  '103';

 
 select  * from student 
 where  deptno1 =   (select deptno1 from  student
 where name  ='Anthony Hopkins');
 
 
   -- 학생과 학과테이블을 조인해서 학과명이 나올 수 있도록한다 
  select  *
  from student  s
  join department d
  on s.deptno1  = d.deptno;
 


--
  select  *
  from student  s
  join department d
  on s.deptno1  = d.deptno
  where  s.deptno1  = '103';
  
  
  select  *
  from student  s
  join department d
  on s.deptno1  = d.deptno
  where  s.deptno1  =  
  ( select deptno1 from  student
   where name  ='Anthony Hopkins');
  
  


  select  s.name , d.dname
  from student  s
  join department d
  on s.deptno1  = d.deptno
  where  s.deptno1  =  
  ( select deptno1 from  student
   where name  ='Anthony Hopkins');
      
   
--다중행 서브쿼리

SELECT * FROM t_emp;
SELECT * FROM T_DEPT;


--다중행 서브쿼리란  서브쿼리의 결과가 여러행을 반환하는 서브쿼리를 말한다 

select salary  from t_emp where salary >=280;

select  * from t_emp
where salary    in (    select salary  from t_emp where salary >=280);


select  * from t_emp
where salary    in (     280,300,290);


-- >ANY   <ANY
-- >ALL   <ALL

-- ANY :  서브쿼리의 여러 행의 값에 하나라도 만족하면 됨
-- ALL :  서브쿼리의 여러 행의 값에 모두 만족하면 됨 

select  * from t_emp
where salary  >= ANY   (    select salary  from t_emp where salary >=280);


select  * from t_emp
where salary  >= ALL   (    select salary  from t_emp where salary >=280);


--EXISTS ()
--서브쿼리가 존재하면 메인쿼리를 실행한다  , 서브쿼리의 결과가 존재하지않으면 실행되지 않는다 



SELECT * FROM T_EMP
WHERE  EXISTS (  SELECT  DEPTNO FROM T_DEPT  WHERE  DEPTNO=70);



-- 다중컬럼   (같은 조건만 비교가능하다)

SELECT GRADE, WEIGHT FROM STUDENT;

SELECT GRADE, MAX( WEIGHT)
FROM STUDENT
GROUP BY GRADE;



SELECT  GRADE, NAME, WEIGHT
FROM  STUDENT
WHERE   (GRADE, WEIGHT)  IN (  SELECT GRADE, MAX( WEIGHT)
FROM  STUDENT
GROUP BY GRADE );


--FROM절 뒤에 오는 서브쿼리  (인라인뷰 서브쿼리라고 함) , 하나의 뷰가 만들어짐


--쿼리가 복잡해질 때   뷰를 사용하거나 
--FROM 절에 서브쿼로 사용할 수 있다  ( 인라인 뷰라고 함)


--고객별 판매수량의 합계
--권지언  9
--이동우  6
--오윤석  2
--윤현기  5
--임형택  3

--1)고객별 판매수량의 합계 구하기 
--2) 1)의 쿼리결과와 고객테이블을 조인해서 전체 쿼리를 완성 


SELECT ID,SALE_CNT FROM TBL_TEST_ORDER;


SELECT  * 
FROM (

SELECT ID, SUM(SALE_CNT) AS  "CNT"
FROM TBL_TEST_ORDER
GROUP BY ID)  A
JOIN TBL_TEST_CUSTOMER C
ON  A.ID = C.ID;


--
SELECT   A.ID ,  C.NAME ,  A.CNT
FROM (
    SELECT ID, SUM(SALE_CNT) AS  "CNT"
    FROM TBL_TEST_ORDER
    GROUP BY ID)  A
JOIN TBL_TEST_CUSTOMER C
ON  A.ID = C.ID;

SELECT * FROM TBL_TEST_CUSTOMER;

 
 

--교재   420  연습문제 1,2,3 풀기
--교재   430  연습문제3  풀기  (단일행서브쿼리)
--교재   434  연습문제1  풀기  (다중행서브쿼리)




--420 1(수민님)
 CREATE VIEW V_PROF_DEPT2
 AS SELECT p.profno, p.name, d.dname
 FROM PROFESSOR P
 JOIN DEPARTMENT D
 ON P.DEPTNO = D.DEPTNO;
 
 
 
 --420 2(시우님)
 
--2번
SELECT * FROM student;
SELECT * FROM department;

-- 서브쿼리
SELECT s.DEPTNO1,max(s.HEIGHT),max(s.WEIGHT) 
FROM student s
GROUP BY s.DEPTNO1;

-- 메인
SELECT * FROM department;

-- 합체
SELECT d.DNAME,maxValues.MAX_HEIGHT,maxValues.MAX_WEIGHT
FROM (SELECT s.DEPTNO1,max(s.HEIGHT) max_height,max(s.WEIGHT) max_weight 
		FROM student s
		GROUP BY s.DEPTNO1) maxValues
JOIN DEPARTMENT d 
ON d.DEPTNO = maxValues.DEPTNO1;



--420 3(지언님)
- 420pg 3번 --
select tb.dname, tb.newmax as max_height , st.name , st.height
from ( select d.dname, max(s.height) as newmax, s.deptno1
       from student s
       join department d
       on s.deptno1 = d.deptno
       group by deptno1 , dname 
     )tb, student st
where st.height = tb.newmax and st.deptno1 = tb.deptno1;



--3번
-- 학과별 키가 가장 큰 학생의 이름 조회하기, 학과명과 함께 조회하기 

--1) 학과별 가장 큰 키 조회하기 
--2) 1번 쿼리의 내용을 학생테이블로 조인하여 학과별 가장 큰키의 학생정보 조회하기   ( 같은학과 , 키가 같아야 한다)
--3) 학과테이블 조인하여 학과명 가져오기 


SELECT *
FROM STUDENT
ORDER BY DEPTNO1;


SELECT DEPTNO1, HEIGHT
FROM STUDENT;


--학과별 가장 큰키 조회하기 
SELECT DEPTNO1,  MAX(HEIGHT)
FROM STUDENT
GROUP BY DEPTNO1;



SELECT *
FROM (
    SELECT DEPTNO1,  MAX(HEIGHT)  MAX_HEIGHT
    FROM STUDENT
    GROUP BY DEPTNO1
 )  A
 JOIN STUDENT S
 ON A.DEPTNO1 = S.DEPTNO1  AND  A.MAX_HEIGHT = S.HEIGHT;



-- 
SELECT A.DEPTNO1,  S.NAME,   A.MAX_HEIGHT   , S.HEIGHT
FROM (
    SELECT DEPTNO1,  MAX(HEIGHT)  MAX_HEIGHT
    FROM STUDENT
    GROUP BY DEPTNO1
 )  A
 JOIN STUDENT S
 ON A.DEPTNO1 = S.DEPTNO1  AND  A.MAX_HEIGHT = S.HEIGHT
 JOIN DEPARTMENT D
 ON A.DEPTNO1  = D.DEPTNO;
 
 
 SELECT * FROM DEPARTMENT;
 
 --서브쿼리
 --연관쿼리    :   서브쿼리에서 메인쿼리의 내용을 사용하는 쿼리 
 --비연관쿼리  :   서브쿼리에서 메인쿼리의 내용을 사용안함 
 
 
 

 SELECT * FROM T_EMP;
  --비연관쿼리 
  --평균SALARY보다 많이 받는 사람 조회하기 
  
  
  SELECT *
  FROM  T_EMP
  WHERE SALARY >= (
  
    SELECT AVG(SALARY) FROM T_EMP
    
  );
 
 
 -- 연관서브쿼리 
 -- 자신이 속한 부서의 가장 높은 연봉인 사람 조회하기 
 
 
 SELECT *
 FROM T_EMP;
 
 
 --자신이 속한 부서의 가장 높은 연봉조회하기   (메인쿼리의 사원의 부서정보를 서브쿼리에서 사용해야 한다)
 --연관서브쿼리란 :  서브쿼리에서 메인쿼리의 컬럼값을 사용하는 경우를 말한다 
 
 -- 자신이 속한 부서의 가장많은 급여 사람 
 SELECT  *
 FROM    T_EMP E
 WHERE   SALARY  = ( SELECT MAX(SALARY)  FROM T_EMP TE  WHERE E.DEPTNO  = TE.DEPTNO );
 
 
 -- 자신이 속한 부서의 평균 급여보다 많이 받는 사람 
 SELECT  *
 FROM    T_EMP E
 WHERE   SALARY  >= ( SELECT AVG(SALARY)  FROM T_EMP TE  WHERE E.DEPTNO  = TE.DEPTNO );
 
 
 
 
 
--SQL - DDL, DML , DCL 
--DML  (데이터 조작언어)   -CRUD
--SELECT (READ)
--INSERT (CREATE)
--UPDATE (UPDATE)
--DELETE (DELETE)



SELECT * FROM ACORNTBL2;

--홍길동 

INSERT INTO ACORNTBL2( ID, PW, NAME, POINT ) VALUES( 'hong'  ,'1234'  , '홍길동', 100);
INSERT INTO ACORNTBL2 VALUES('hong2','5678', '홍길순', 200);
  
 COMMIT;
 
 
 --변경하기  (UPDATE 로 변경하기) - WHERE절 없으면 모든 행이 변경됨, WHERE 절 확인하기 
 
 UPDATE  ACORNTBL2
 SET POINT = POINT +1000 
 WHERE ID  ='umin';
 
--비밀번호 
--che 아이디를 가진 회원의 비밀번호 변경하기 

UPDATE ACORNTBL2
SET PW ='0409'
WHERE ID='che';

COMMIT;

SELECT * FROM ACORNTBL2;

COMMIT;
-- 여러개 변경

UPDATE ACORNTBL2
SET PW='0448' , POINT=5000
WHERE ID ='boseong00';


--데이터 삭제하기 , WHERE 절 주의  , WHERE절이 없으면 테이블의 모든 행을 삭제하게 됨 .. 주의 !!
DELETE FROM ACORNTBL2 WHERE ID='hong';






--연습문제 
--P420페이지 1,2,3 (풀이완료)
--4번 풀기 
--교재   430  연습문제3  풀기  (단일행서브쿼리)
--교재   434  연습문제1  풀기  (다중행서브쿼리)
--쿼리연습하기 실습문제 PDF 제공 



















































































































































































