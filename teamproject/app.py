from flask import Flask, render_template, request, redirect, url_for, session
import cx_Oracle
import datetime

app = Flask(__name__)
app.secret_key = 'your_secret_key'  

dsn = cx_Oracle.makedsn("localhost", 1521, sid="testdb")
conn = cx_Oracle.connect(user="scott", password="tiger", dsn=dsn)
cursor = conn.cursor() 


@app.route('/')
def home():
    cursor = conn.cursor()  # Local cursor for this route
    cursor.close()
    return render_template('login.html')

# 로그인
@app.route('/login', methods=['POST'])
def login():
    cursor = conn.cursor()  # Local cursor for this route
    user_id = request.form['id']
    pwd = request.form['pw']
    role = request.form['role']

    if role == 'teacher_tbl':
        cursor.execute("SELECT teacher_cd FROM teacher_tbl WHERE id=:id AND pwd=:pwd", {'id': user_id, 'pwd': pwd})
        result = cursor.fetchone()
        if result:
            session['user_id'] = user_id
            session['role'] = role
            #session['isadmin'] = result[1].strip()
            cursor.close()
            return redirect(url_for('teacher_dashboard'))

    elif role == 'student_tbl':
        cursor.execute("SELECT student_cd FROM student_tbl WHERE id=:id AND pwd=:pwd", {'id': user_id, 'pwd': pwd})
        if cursor.fetchone():
            session['user_id'] = user_id
            session['role'] = role
            return redirect(url_for('student_dashboard'))  

    elif role == 'parent':
        cursor.execute("SELECT student_cd FROM parents_tbl WHERE id=:id AND pwd=:pwd", {'id': user_id, 'pwd': pwd})
        if cursor.fetchone():
            session['user_id'] = user_id
            session['role'] = role
            return redirect(url_for('parent_dashboard')) 

    return render_template('login.html')


# 학생 회원가입 
@app.route('/signup_student', methods=['GET', 'POST'])
def signup_student():
    cursor = conn.cursor()  # Local cursor for this route
    if request.method == 'POST':
        id = request.form['id']
        pwd = request.form['pwd']
        name = request.form['name']
        grade = request.form['grade']
        ban = request.form['ban']
        stu_num = request.form['stu_num']

        class_cd = grade + ban.zfill(2)
        student_cd = class_cd + stu_num.zfill(2) 

        cursor.execute("SELECT id FROM student_tbl WHERE id = :id", {'id': id})
        if cursor.fetchone():
            cursor.close()
            return "이미 사용 중인 아이디입니다."

        cursor.execute("SELECT student_cd FROM student_tbl WHERE student_cd = :student_cd", {'student_cd': student_cd})
        if cursor.fetchone():
            return "이미 등록된 학번입니다."

        try:
            cursor.execute("""
                INSERT INTO student_tbl (student_cd, id, pwd, class_cd, stu_num, grade, name)
                VALUES (:student_cd, :id, :pwd, :class_cd, :stu_num, :grade, :name)
            """, {
                'student_cd': student_cd,
                'id': id,
                'pwd': pwd,
                'class_cd': class_cd,
                'stu_num': stu_num,
                'grade': grade,
                'name': name
            })
            conn.commit()
            cursor.close()
            return redirect(url_for('login')) 

        except Exception as e:
            cursor.close()
            return f"오류 발생: {str(e)}"
            
    return render_template('signup_student.html')


# 부모 회원가입
@app.route('/signup_parent', methods=['GET', 'POST'])
def signup_parent():
    cursor = conn.cursor()  # Local cursor for this route
    if request.method == 'POST':
        id = request.form['id']
        pwd = request.form['pwd']
        phone = request.form['phone']
        grade = request.form['grade']
        ban = request.form['ban']
        stu_num = request.form['stu_num']

        class_cd = grade + ban
        student_cd = class_cd + stu_num.zfill(2)

        try:
            cursor.execute("SELECT student_cd FROM student_tbl WHERE student_cd = :scd", {'scd': student_cd})
            if not cursor.fetchone():
                cursor.close()
                return "해당 자녀 정보가 존재하지 않습니다."

            parents_cd = student_cd + "_P"

            cursor.execute("""
                INSERT INTO parents_tbl (parents_cd, student_cd, id, pwd, phone)
                VALUES (:parents_cd, :student_cd, :id, :pwd, :phone)
            """, {
                'parents_cd': parents_cd,
                'student_cd': student_cd,
                'id': id,
                'pwd': pwd,
                'phone': phone
            })
            conn.commit()
            return "학부모 회원가입 완료! <a href='/'>로그인하러 가기</a>"

        except cx_Oracle.IntegrityError:
            return "이미 존재하는 아이디입니다."
        except Exception as e:
            return f"오류 발생: {str(e)}"

    return render_template('signup_parent.html')

# 알림장 내용 추가
@app.route('/teacher_dashboard', methods=['GET', 'POST'])
def teacher_dashboard():
    cursor = conn.cursor()  # Local cursor for this route
    if 'user_id' not in session or session.get('role') != 'teacher_tbl' or session.get('isadmin') != 'Y':
        cursor.close()
        return "접근 권한이 없습니다."

    if request.method == 'POST':
        title = request.form['title']
        desc = request.form['desc']
        teacher_id = session['user_id']

        cursor.execute("SELECT teacher_cd, class_cd FROM teacher_tbl WHERE id = :id", {'id': teacher_id})
        result = cursor.fetchone()
        if not result:
            return "선생님 정보 없음"
        teacher_cd, class_cd = result

        import datetime
        now = datetime.datetime.now()
        n_no = now.strftime('%m%d%H%M') + teacher_cd[-1]

        try:
            cursor.execute("""
                INSERT INTO notices_tbl (n_no, title, notice_desc, teacher_cd, class_cd)
                VALUES (:n_no, :title, :desc, :teacher_cd, :class_cd)
            """, {
                'n_no': n_no,
                'title': title,
                'desc': desc,
                'teacher_cd': teacher_cd,
                'class_cd': class_cd
            })
            conn.commit()
            return "알림장 작성 완료! <a href='/teacher_tbl/mynotices'>내가 쓴 알림장 보기</a>"
        except Exception as e:
            return f"오류 발생: {str(e)}"

    return render_template('teacher_dashboard.html')

# 알림장 보기
@app.route('/notices_tbl/<class_cd>')
def notices_list(class_cd):
    cursor = conn.cursor()  # Local cursor for this route
    cursor.execute("""
        SELECT n_no, title, TO_CHAR(notice_date, 'YYYY-MM-DD'), teacher_cd 
        FROM notices_tbl 
        WHERE class_cd = :class_cd
        ORDER BY notice_date DESC
    """, {'class_cd': class_cd})
    notices_tbl = cursor.fetchall()

    cursor.close()
    return render_template('notices_list.html', notices_tbl=notices_tbl, class_cd=class_cd)

# 알림장 상세 보기 ( 선택된 거 )
@app.route('/notice/<n_no>')
def notice_detail(n_no):
    cursor = conn.cursor()  # Local cursor for this route
    cursor.execute("SELECT n_no, title, notice_desc, TO_CHAR(notice_date, 'YYYY-MM-DD'), teacher_cd, class_cd FROM notices_tbl WHERE n_no = :cd", {'cd': n_no})
    row = cursor.fetchone()
    if not row:
        cursor.close()
        return "알림장 정보를 찾을 수 없습니다."
    
    notice = {
        'n_no': row[0],
        'title': row[1],
        'notice_desc': row[2],
        'notice_date': row[3],
        'teacher_cd': row[4],
        'class_cd': row[5]
    }

    cursor.execute("""
        SELECT r.replices_desc, TO_CHAR(r.notice_date, 'YYYY-MM-DD'), s.name 
        FROM replices_tbl r
        JOIN student_tbl s ON r.student_cd = s.student_cd
        WHERE r.n_no = :cd
        ORDER BY r.notice_date ASC
    """, {'cd': n_no})
    replices_tbl = [{'replices_desc': r[0], 'notice_date': r[1], 'name': r[2]} for r in cursor.fetchall()]

    return render_template('notice_detail.html', notice=notice, replices_tbl=replices_tbl)

# 댓글 작성성
@app.route('/reply/<n_no>', methods=['POST'])
def reply_write(n_no):
    cursor = conn.cursor()  # Local cursor for this route
    if 'user_id' not in session or session.get('role') not in ['student_tbl', 'parent']:
        cursor.close()
        return "댓글 작성 권한이 없습니다."

    replices_desc = request.form['replices_desc']

    if session['role'] == 'student_tbl':
        cursor.execute("SELECT student_cd FROM student_tbl WHERE id = :id", {'id': session['user_id']})
    else:  
        cursor.execute("SELECT student_cd FROM parents_tbl WHERE id = :id", {'id': session['user_id']})
    
    result = cursor.fetchone()
    if not result:
        return "학생 정보가 없습니다."
    
    student_cd = result[0]

    import datetime
    now = datetime.datetime.now()
    replices_id = 'R' + now.strftime('%d%H%M%S')

    try:
        cursor.execute("""
            INSERT INTO replices_tbl (replices_id, n_no, student_cd, replices_desc)
            VALUES (:replices_id, :n_no, :student_cd, :replices_desc)
        """, {
            'replices_id': replices_id,
            'n_no': n_no,
            'student_cd': student_cd,
            'replices_desc': replices_desc
        })
        conn.commit()
        return redirect(url_for('notice_detail', n_no=n_no))
    except Exception as e:
        return f"댓글 등록 실패: {str(e)}"

# 교사페이지
@app.route('/teacher_tbl/mynotices')
def teacher_mynotices():
    cursor = conn.cursor()  # Local cursor for this route
    if 'user_id' not in session or session.get('role') != 'teacher_tbl':
        cursor.close()
        return "접근 권한이 없습니다."

    cursor.execute("SELECT teacher_cd FROM teacher_tbl WHERE id = :id", {'id': session['user_id']})
    result = cursor.fetchone()
    if not result:
        return "선생님 정보가 없습니다."

    teacher_cd = result[0]

    cursor.execute("""
        SELECT n_no, title, TO_CHAR(notice_date, 'YYYY-MM-DD'), class_cd 
        FROM notices_tbl 
        WHERE teacher_cd = :teacher_cd
        ORDER BY notice_date DESC
    """, {'teacher_cd': teacher_cd})
    notices_tbl = cursor.fetchall()

    return render_template('teacher_mynotices.html', notices_tbl=notices_tbl)

if __name__ == "__main__":
    app.run(debug=True)