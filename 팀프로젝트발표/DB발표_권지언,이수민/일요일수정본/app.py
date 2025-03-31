from flask import Flask, render_template, request, redirect, url_for, session
import cx_Oracle
import datetime

app = Flask(__name__)
app.secret_key = 'your_secret_key'

dsn = cx_Oracle.makedsn("localhost", 1521, sid="testdb")
conn = cx_Oracle.connect(user="scott", password="tiger", dsn=dsn)
cursor = conn.cursor()

@app.route('/', methods=['GET', 'POST'])
def home():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    user_id = request.form['id']
    pw = request.form['pw']
    role = request.form['role']
    if role == 'teacher':
        cursor.execute("SELECT teacher_cd FROM teacher WHERE id=:1 AND pw=:2", (user_id, pw))
        result = cursor.fetchone()
        if result:
            session['user_id'] = user_id
            session['role'] = role
            return redirect(url_for('teacher_dashboard'))
    elif role == 'student':
        cursor.execute("SELECT student_cd, class_cd FROM student WHERE id=:1 AND pw=:2", (user_id, pw))
        result = cursor.fetchone()
        if result:
            session['user_id'] = user_id
            session['role'] = role
            session['class_cd'] = result[1]
            return redirect(url_for('notices_list'))
    elif role == 'parent':
        cursor.execute("SELECT student_cd FROM parents WHERE id=:1 AND pw=:2", (user_id, pw))
        if cursor.fetchone():
            session['user_id'] = user_id
            session['role'] = role
            return redirect(url_for('notices_list'))

    return redirect(url_for('home'))

@app.route('/teacher_dashboard', methods=['GET', 'POST'])
def teacher_dashboard():
    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        teacher_id = session['user_id']

        cursor.execute("SELECT teacher_cd, class_cd FROM teacher WHERE id = :1", (teacher_id,))
        result = cursor.fetchone()
        if not result:
            return "선생님 정보 없음"

        teacher_cd, class_cd = result
        notices_cd = datetime.datetime.now().strftime('%Y%m%d%H%M%S')

        try:
            cursor.execute("""
                INSERT INTO notices (notices_cd, title, notices_description, teacher_cd, class_cd)
                VALUES (:1, :2, :3, :4, :5)
            """, (notices_cd, title, description, teacher_cd, class_cd))
            conn.commit()
            return redirect(url_for('teacher_dashboard'))
        except Exception as e:
            return f"\uc624\ub958 \ubc1c\uc0dd: {str(e)}"

    return render_template('teacher_dashboard.html')

@app.route('/signup_student', methods=['GET', 'POST'])
def signup_student():
    if request.method == 'POST':
        id = request.form['id']
        pw = request.form['pw']
        name = request.form['name']
        grade = request.form['grade']
        ban = request.form['ban']
        class_no = request.form['class_no']

        class_cd = grade + ban.zfill(2)
        student_cd = class_cd + class_no.zfill(2)

        cursor.execute("SELECT id FROM student WHERE id = :1", (id,))
        if cursor.fetchone():
            return "\uc774\ubbf8 \uc0ac\uc6a9 \uc911\uc778 \uc544\uc774\ub514\uc785\ub2c8\ub2e4."

        cursor.execute("SELECT student_cd FROM student WHERE student_cd = :1", (student_cd,))
        if cursor.fetchone():
            return "\uc774\ubbf8 \ub4f1\ub85d\ub41c \ud559\ubc88\uc785\ub2c8\ub2e4."

        try:
            cursor.execute("""
                INSERT INTO student (student_cd, id, pw, class_cd, class_no, grade, name)
                VALUES (:1, :2, :3, :4, :5, :6, :7)
            """, (student_cd, id, pw, class_cd, class_no, grade, name))
            conn.commit()
            return redirect(url_for('home'))
        except Exception as e:
            return f"\uc624\ub958 \ubc1c\uc0dd: {str(e)}"

    return render_template('signup_student.html')

@app.route('/signup_parent', methods=['GET', 'POST'])
def signup_parent():
    if request.method == 'POST':
        id = request.form['id']
        pw = request.form['pw']
        tel = request.form['tel']
        grade = request.form['grade']
        ban = request.form['ban']
        class_no = request.form['class_no']

        class_cd = grade + ban.zfill(2)
        student_cd = class_cd + class_no.zfill(2)

        try:
            cursor.execute("SELECT student_cd FROM student WHERE student_cd = :1", (student_cd,))
            if not cursor.fetchone():
                return "\ud574\ub2f9 \uc790\ub140 \uc815\ubcf4\uac00 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4."

            parent_id = student_cd + '_P'

            cursor.execute("""
                INSERT INTO parents (parent_id, student_cd, id, pw, tel)
                VALUES (:1, :2, :3, :4, :5)
            """, (parent_id, student_cd, id, pw, tel))
            conn.commit()
            return redirect(url_for('home'))

        except cx_Oracle.IntegrityError:
            return "\uc774\ubbf8 \uc874\uc7ac\ud558\ub294 \uc544\uc774\ub514\uc785\ub2c8\ub2e4."
        except Exception as e:
            return f"\uc624\ub958 \ubc1c\uc0dd: {str(e)}"

    return render_template('signup_parent.html')

@app.route('/notices_list')
def notices_list():
    if 'user_id' not in session:
        return redirect(url_for('home'))

    if session['role'] == 'student':
        cursor.execute("SELECT class_cd FROM student WHERE id = :1", (session['user_id'],))
        result = cursor.fetchone()
        if result:
            class_cd = result[0]
            cursor.execute("""
                SELECT notices_cd, title, TO_CHAR(write_date, 'YYYY-MM-DD'), teacher_cd 
                FROM notices WHERE class_cd = :1
                ORDER BY write_date DESC
            """, (class_cd,))
            notices = cursor.fetchall()
        else:
            notices = []

    elif session['role'] == 'parent':
        cursor.execute("""
            SELECT s.class_cd
            FROM parents p
            JOIN student s ON p.student_cd = s.student_cd
            WHERE p.id = :1
        """, (session['user_id'],))
        result = cursor.fetchone()
        if result:
            class_cd = result[0]
            cursor.execute("""
                SELECT notices_cd, title, TO_CHAR(write_date, 'YYYY-MM-DD'), teacher_cd 
                FROM notices WHERE class_cd = :1
                ORDER BY write_date DESC
            """, (class_cd,))
            notices = cursor.fetchall()
        else:
            notices = []

    elif session['role'] == 'teacher':
        cursor.execute("SELECT class_cd FROM teacher WHERE id = :1", (session['user_id'],))
        result = cursor.fetchone()
        if result:
            class_cd = result[0]
            cursor.execute("""
                SELECT notices_cd, title, TO_CHAR(write_date, 'YYYY-MM-DD'), teacher_cd 
                FROM notices WHERE class_cd = :1
                ORDER BY write_date DESC
            """, (class_cd,))
            notices = cursor.fetchall()
        else:
            notices = []
    else:
        notices = []

    return render_template('notices_list.html', notices=notices)

@app.route('/notice/<notices_cd>', methods=['GET', 'POST'])
def notice_detail(notices_cd):
    cursor.execute("""
        SELECT notices_cd, title, notices_description, TO_CHAR(write_date, 'YYYY-MM-DD'), teacher_cd, class_cd 
        FROM notices 
        WHERE notices_cd = :1
    """, (notices_cd,))

    row = cursor.fetchone()
    if not row:
        return "\uc54c\ub9bc\uc7a5 \uc815\ubcf4\ub97c \ucc3e\uc744 \uc218 \uc5c6\uc2b5\ub2c8\ub2e4."

    notice = {
        'notices_cd': row[0],
        'title': row[1],
        'description': row[2],
        'date': row[3],
        'teacher_cd': row[4],
        'class_cd': row[5]
    }

    cursor.execute("""
        SELECT r.replies_description, TO_CHAR(r.write_date, 'YYYY-MM-DD'), s.name, r.writer_role
        FROM replies r
        JOIN student s ON r.student_cd = s.student_cd
        WHERE r.notices_cd = :1
        ORDER BY r.write_date ASC
    """, (notices_cd,))

    replies = []
    for r in cursor.fetchall():
        content, date, student_name, writer_role = r
        display_name = f"{student_name}(학부모)" if writer_role == 'parent' else student_name

        replies.append({
            'replies_description': content,
            'date': date,
            'name': display_name
        })

    return render_template('notice_detail.html', notice=notice, replies=replies)

@app.route('/reply/<notices_cd>', methods=['POST'])
def reply_write(notices_cd):
    if 'user_id' not in session or session['role'] not in ['student', 'parent']:
        return "\ub85c\uadf8\uc778 \ud6c4 \uc774\uc6a9 \uac00\ub2a5\ud569\ub2c8\ub2e4."

    reply_content = request.form['reply_content']
    writer_id = session['user_id']
    role = session['role']

    if role == 'student':
        cursor.execute("SELECT student_cd FROM student WHERE id = :1", (writer_id,))
    else:
        cursor.execute("SELECT student_cd FROM parents WHERE id = :1", (writer_id,))

    result = cursor.fetchone()
    if not result:
        return "\uc791\uc131\uc790 \uc815\ubcf4\uac00 \uc5c6\uc2b5\ub2c8\ub2e4."

    student_cd = result[0]
    reply_id = datetime.datetime.now().strftime('%H%M%S')

    try:
        cursor.execute("""
            INSERT INTO replies (reply_id, notices_cd, student_cd, replies_description, writer_role)
            VALUES (:1, :2, :3, :4, :5)
        """, (reply_id, notices_cd, student_cd, reply_content, role))
        conn.commit()
        return redirect(url_for('notice_detail', notices_cd=notices_cd))
    except Exception as e:
        return f"\uc624\ub958 \ubc1c\uc0dd: {str(e)}"

if __name__ == "__main__":
    app.run(debug=True)
