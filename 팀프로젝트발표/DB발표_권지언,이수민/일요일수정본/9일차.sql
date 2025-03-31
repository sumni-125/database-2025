-- teacher 테이블
CREATE TABLE teacher (
    teacher_cd VARCHAR2(4) PRIMARY KEY,
    id VARCHAR2(20) UNIQUE NOT NULL,
    pw VARCHAR2(20) NOT NULL,
    class_cd VARCHAR2(4) UNIQUE NOT NULL
);

-- student 테이블
CREATE TABLE student (
    student_cd VARCHAR2(6) PRIMARY KEY,
    id VARCHAR2(20) UNIQUE NOT NULL,
    pw VARCHAR2(20) NOT NULL,
    class_cd VARCHAR2(4),
    class_no VARCHAR2(2),
    grade VARCHAR2(1),
    name VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_student_class FOREIGN KEY (class_cd) REFERENCES teacher(class_cd)
);

-- parents 테이블
CREATE TABLE parents (
    parent_id VARCHAR2(7) PRIMARY KEY,
    student_cd VARCHAR2(6),
    id VARCHAR2(20) UNIQUE NOT NULL,
    pw VARCHAR2(20) NOT NULL,
    tel VARCHAR2(20) NOT NULL,
    CONSTRAINT tel_check CHECK (REGEXP_LIKE(tel, '^010[0-9]{8}$')),
    CONSTRAINT fk_parents_student FOREIGN KEY (student_cd) REFERENCES student(student_cd)
);

-- notices 테이블
CREATE TABLE notices (
    notices_cd VARCHAR2(20) PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    notices_description VARCHAR2(999),
    write_date DATE DEFAULT SYSDATE,
    teacher_cd VARCHAR2(4),
    class_cd VARCHAR2(4),
    CONSTRAINT fk_notices_teacher FOREIGN KEY (teacher_cd) REFERENCES teacher(teacher_cd),
    CONSTRAINT fk_notices_class FOREIGN KEY (class_cd) REFERENCES teacher(class_cd)
);

-- replies 테이블
CREATE TABLE replies (
    reply_id VARCHAR2(6) PRIMARY KEY,
    notices_cd VARCHAR2(20),
    student_cd VARCHAR2(6),
    replies_description VARCHAR2(100),
    write_date DATE DEFAULT SYSDATE,
    writer_role VARCHAR2(10) DEFAULT 'student' CHECK (writer_role IN ('student', 'parent')),
    CONSTRAINT fk_replies_notices FOREIGN KEY (notices_cd) REFERENCES notices(notices_cd),
    CONSTRAINT fk_replies_student FOREIGN KEY (student_cd) REFERENCES student(student_cd)
);

select * from teacher;
select * from student;
select * from parents;
select * from notices;
select * from replies;







