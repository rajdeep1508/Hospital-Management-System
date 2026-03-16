from flask import Flask, render_template, request, redirect, session, url_for, flash
import mysql.connector

app = Flask(__name__)
app.secret_key = "mysecretkey123"

# DATABASE CONNECTION
db = mysql.connector.connect(
    host="maglev.proxy.rlwy.net",
    user="root",
    port=20801,
    password="apzpYIzeIDxFFvFUcAvFxFCSgaNyZZup",
    database="hospital_db"
)

# ---------------- HOME ----------------

@app.route('/')
def home():
    return render_template("home.html")


# ---------------- LOGIN ----------------

@app.route('/login/<role>', methods=['GET','POST'])
def login(role):

    error = None

    if request.method == 'POST':

        username = request.form.get('username')
        password = request.form.get('password')

        if not username or not password:
            error = "All fields are required"
            return render_template("login.html", role=role, error=error)

        cursor = db.cursor()

        query = "SELECT * FROM users WHERE username=%s AND password=%s AND role=%s"
        cursor.execute(query,(username,password,role))

        user = cursor.fetchone()
        cursor.close()

        if user:

            session['username'] = user[1]
            session['role'] = user[3]

            if role == "admin":
                return redirect(url_for('admin_dashboard'))

            elif role == "doctor":
                return redirect(url_for('doctor_dashboard'))

            else:
                return redirect(url_for('patient_dashboard'))

        else:
            error = "Invalid username or password"

    return render_template("login.html", role=role, error=error)


# ---------------- LOGOUT ----------------

@app.route("/logout")
def logout():

    session.pop("user", None)

    return redirect("/")


# ---------------- DASHBOARDS ----------------

@app.route("/admin_dashboard")
def admin_dashboard():

    if 'role' not in session or session['role'] != 'admin':
        return redirect('/')

    return render_template("admin_dashboard.html")


@app.route('/doctor_dashboard')
def doctor_dashboard():

    if 'role' not in session or session['role'] != 'doctor':
        return redirect('/')

    doctor_id = session['username']

    cursor = db.cursor()

    query = """
    SELECT a.appointment_id, p.name, a.date, a.appointment_time
    FROM appointments a
    JOIN patients p ON a.patient_id = p.patient_id
    WHERE a.doctor_id = %s
    """

    cursor.execute(query,(doctor_id,))
    appointments = cursor.fetchall()

    cursor.close()

    return render_template(
        "doctor_dashboard.html",
        appointments=appointments
    )

@app.route('/patient_dashboard')
def patient_dashboard():

    if 'role' not in session or session['role'] != 'patient':
        return redirect('/')

    patient_id = session['username']

    cursor = db.cursor()

    # ---------- APPOINTMENTS ----------
    query = """
    SELECT d.name, a.date, a.appointment_time
    FROM appointments a
    JOIN doctors d ON a.doctor_id = d.doctor_id
    WHERE a.patient_id = %s
    """

    cursor.execute(query,(patient_id,))
    appointments = cursor.fetchall()

    # ---------- TREATMENTS ----------
    query = """
    SELECT tr.diagnosis, tr.prescription, a.date
    FROM treatment_records tr
    JOIN appointments a ON tr.appointment_id = a.appointment_id
    WHERE a.patient_id = %s
    """

    cursor.execute(query,(patient_id,))
    treatments = cursor.fetchall()

    cursor.close()

    return render_template(
        "patient_dashboard.html",
        appointments=appointments,
        treatments=treatments
    )


# ---------------- ADD PATIENT ----------------

@app.route("/add_patient", methods=["GET", "POST"])
def add_patient():

    if 'role' not in session or session['role'] != 'admin':
        return redirect('/')

    if request.method == "POST":

        name = request.form.get("name")
        age = request.form.get("age")
        gender = request.form.get("gender")
        phone = request.form.get("phone")

        if not name or not age or not gender or not phone:
            return render_template("add_patient.html", error="All fields are required")

        cursor = db.cursor()

        # Insert patient
        query = "INSERT INTO patients (name, age, gender, phone) VALUES (%s,%s,%s,%s)"
        cursor.execute(query,(name,age,gender,phone))
        db.commit()

        # Get generated patient ID
        patient_id = cursor.lastrowid

        # Generate credentials
        first_name = name.split()[0].lower()

        username = str(patient_id)
        password = first_name + str(patient_id)

        # Insert login credentials
        query = "INSERT INTO users(username,password,role) VALUES(%s,%s,'patient')"
        cursor.execute(query,(username,password))
        db.commit()

        cursor.close()

        return render_template(
            "patient_created.html",
            username=username,
            password=password
        )

    return render_template("add_patient.html")


# ---------------- VIEW PATIENTS ----------------

@app.route('/view_patients')
def view_patients():

    if 'role' not in session:
        return redirect('/')

    cursor = db.cursor()
    cursor.execute("SELECT * FROM patients")

    patients = cursor.fetchall()
    cursor.close()

    return render_template('view_patients.html', patients=patients)


# ---------------- DELETE PATIENT ----------------

@app.route('/delete_patient/<int:id>')
def delete_patient(id):

    cursor = db.cursor()

    # delete treatments related to appointments
    query = """
    DELETE FROM treatment_records
    WHERE appointment_id IN
    (SELECT appointment_id FROM appointments WHERE patient_id=%s)
    """
    cursor.execute(query,(id,))

    # delete appointments
    query = "DELETE FROM appointments WHERE patient_id=%s"
    cursor.execute(query,(id,))

    # delete patient
    query = "DELETE FROM patients WHERE patient_id=%s"
    cursor.execute(query,(id,))

    db.commit()
    cursor.close()

    return redirect('/view_patients')


# ---------------- EDIT PATIENT ----------------

@app.route('/edit_patient/<int:id>', methods=['GET','POST'])
def edit_patient(id):

    cursor = db.cursor()
    error = None

    if request.method == 'POST':

        name = request.form.get('name')
        age = request.form.get('age')
        gender = request.form.get('gender')
        phone = request.form.get('phone')

        if not name or not age or not gender or not phone:
            error = "All fields are required"
            return render_template("edit_patient.html", error=error)

        query = """
        UPDATE patients
        SET name=%s, age=%s, gender=%s, phone=%s
        WHERE patient_id=%s
        """

        cursor.execute(query,(name,age,gender,phone,id))
        db.commit()

        cursor.close()

        return redirect('/view_patients')

    cursor.execute("SELECT * FROM patients WHERE patient_id=%s",(id,))
    patient = cursor.fetchone()

    cursor.close()

    return render_template("edit_patient.html", patient=patient, error=error)


# ---------------- SEARCH PATIENT ----------------

@app.route('/search_patient', methods=['GET','POST'])
def search_patient():

    cursor = db.cursor()

    if request.method == 'POST':

        name = request.form.get('name')

        if not name:
            return redirect('/view_patients')

        query = "SELECT * FROM patients WHERE name LIKE %s"
        cursor.execute(query,('%'+name+'%',))

        patients = cursor.fetchall()
        cursor.close()

        return render_template('view_patients.html', patients=patients)

    return render_template('search_patient.html')


# ---------------- ADD DOCTOR ----------------

@app.route('/add_doctor', methods=['GET','POST'])
def add_doctor():

    if 'role' not in session or session['role'] != 'admin':
        return redirect('/')

    if request.method == 'POST':

        name = request.form.get('name')
        specialization = request.form.get('specialization')
        phone = request.form.get('phone')

        if not name or not specialization or not phone:
            return render_template("add_doctor.html", error="All fields are required")

        name = "Dr. " + name

        cursor = db.cursor()

        # Insert doctor
        query = "INSERT INTO doctors(name,specialization,phone) VALUES(%s,%s,%s)"
        cursor.execute(query,(name,specialization,phone))
        db.commit()

        # Get generated doctor ID
        doctor_id = cursor.lastrowid

        # Extract first name
        first_name = name.split()[1].lower()

        username = str(doctor_id)
        password = first_name + str(doctor_id)

        # Insert login credentials
        query = "INSERT INTO users(username,password,role) VALUES(%s,%s,'doctor')"
        cursor.execute(query,(username,password))
        db.commit()

        cursor.close()

        return render_template(
            "doctor_created.html",
            username=username,
            password=password
        )

    return render_template('add_doctor.html')


# ---------------- VIEW DOCTORS ----------------

@app.route('/view_doctors')
def view_doctors():

    cursor = db.cursor()

    cursor.execute("SELECT * FROM doctors")
    doctors = cursor.fetchall()

    cursor.close()

    return render_template('view_doctors.html', doctors=doctors)


# ---------------- BOOK APPOINTMENT ----------------

@app.route('/book_appointment', methods=['GET','POST'])
def book_appointment():

    cursor = db.cursor()

    if request.method == 'POST':

        patient_id = request.form.get('patient_id')
        doctor_id = request.form.get('doctor_id')
        date = request.form.get('date')
        appointment_time = request.form.get('appointment_time')

        if not patient_id or not doctor_id or not date or not appointment_time:
            return "All fields are required"

        cursor.execute(
        "SELECT * FROM appointments WHERE doctor_id=%s AND date=%s AND appointment_time=%s",
        (doctor_id,date,appointment_time))

        existing = cursor.fetchone()

        if existing:
            return "This time slot is already booked"

        query = """
        INSERT INTO appointments(patient_id,doctor_id,date,appointment_time)
        VALUES(%s,%s,%s,%s)
        """

        cursor.execute(query,(patient_id,doctor_id,date,appointment_time))
        db.commit()

        return redirect('/view_appointments')

    cursor.execute("SELECT patient_id,name FROM patients")
    patients = cursor.fetchall()

    cursor.execute("SELECT doctor_id,name FROM doctors")
    doctors = cursor.fetchall()

    cursor.close()
    from datetime import date


    return render_template("book_appointment.html",patients=patients,doctors=doctors,today=date.today())


# ---------------- VIEW APPOINTMENTS ----------------

@app.route('/view_appointments')
def view_appointments():

    cursor = db.cursor()

    query = """
    SELECT a.appointment_id, p.name, d.name, a.date, a.appointment_time
    FROM appointments a
    JOIN patients p ON a.patient_id = p.patient_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
    """

    cursor.execute(query)
    appointments = cursor.fetchall()

    cursor.close()

    return render_template('view_appointments.html', appointments=appointments)


# ---------------- DELETE APPOINTMENT ----------------

@app.route('/delete_appointment/<int:id>')
def delete_appointment(id):

    cursor = db.cursor()

    query = "DELETE FROM appointments WHERE appointment_id=%s"
    cursor.execute(query,(id,))

    db.commit()
    cursor.close()

    return redirect('/view_appointments')


# ---------------- ADD TREATMENT ----------------

@app.route("/add_treatment", methods=["GET","POST"])
def add_treatment():

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST":

        patient_id = request.form["patient_id"]
        doctor_id = request.form["doctor_id"]
        diagnosis = request.form["diagnosis"]
        treatment = request.form["treatment"]

        query = """
        INSERT INTO treatment_records 
        (patient_id, doctor_id, diagnosis, treatment)
        VALUES (%s,%s,%s,%s)
        """

        cursor.execute(query,(patient_id,doctor_id,diagnosis,treatment))
        conn.commit()

        return redirect("/treatments")

    cursor.execute("SELECT * FROM patients")
    patients = cursor.fetchall()

    cursor.execute("SELECT * FROM doctors")
    doctors = cursor.fetchall()

    return render_template("add_treatment.html",patients=patients,doctors=doctors)



# ---------------- TREATMENT DIAGNOSIS ----------------

@app.route('/get_treatments/<diagnosis>')
def get_treatments(diagnosis):

    cursor = db.cursor()

    query = "SELECT treatment_name FROM treatment_master WHERE diagnosis_name=%s"
    cursor.execute(query,(diagnosis,))

    treatments = cursor.fetchall()

    cursor.close()

    return {"treatments":[t[0] for t in treatments]}    

# ---------------- TREATMENT ----------------


@app.route("/treatments")
def treatments():

    cursor = db.cursor(dictionary=True)

    query = """
    SELECT 
        p.name AS patient_name,
        d.name AS doctor_name,
        tr.diagnosis,
        tr.prescription AS treatment
    FROM treatment_records tr
    JOIN appointments a ON tr.appointment_id = a.appointment_id
    JOIN patients p ON a.patient_id = p.patient_id
    JOIN doctors d ON a.doctor_id = d.doctor_id
    """

    cursor.execute(query)
    treatments = cursor.fetchall()

    cursor.close()

    return render_template("treatments.html", treatments=treatments)

# ---------------- DOCTOR ADD TREATMENT ----------------

@app.route('/doctor_add_treatment/<int:appointment_id>', methods=['GET','POST'])
def doctor_add_treatment(appointment_id):

    if 'role' not in session or session['role'] != 'doctor':
        return redirect('/')

    cursor = db.cursor()

    if request.method == "POST":

        diagnosis = request.form.get('diagnosis')
        treatment = request.form.get('treatment')

        query = """
        INSERT INTO treatment_records
        (appointment_id, diagnosis, prescription)
        VALUES (%s,%s,%s)
        """

        cursor.execute(query,(appointment_id, diagnosis, treatment))
        db.commit()

        flash("Treatment added successfully!")

        cursor.close()

        return redirect('/doctor_dashboard')

    return render_template(
        "doctor_add_treatment.html",
        appointment_id=appointment_id
    )

if __name__ == "__main__":
    app.run(debug=True)    