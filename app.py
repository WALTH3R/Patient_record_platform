from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
import difflib

app = Flask(__name__)

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="PatientRecordsDB",
    port = 3307
)
cursor = db.cursor(dictionary=True)

# Homepage → Redirect to patient records
@app.route('/')
def index():
    return redirect('/patients')

# Patients List Page
@app.route('/patients')
def patients():
    cursor.execute("SELECT Patient_Number, First_Name, Last_Name, Email, Phone_Number, Age, Sex, Blood_Type, Height, Weight FROM Patient")
    patients = cursor.fetchall()
    return render_template('patients_list.html', patients=patients)

# Add Patient Page (form)
@app.route('/patients/add', methods=['GET', 'POST'])
def add_patient():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        email = request.form['email']
        phone = request.form['phone']
        age = request.form['age']
        sex = request.form['sex']
        blood_type = request.form['blood_type']
        height = request.form['height']
        weight = request.form['weight']

        cursor.execute("""
            INSERT INTO Patient (First_Name, Last_Name, Email, Phone_Number, Age, Sex, Blood_Type, Height, Weight)
            VALUES (%s, %s, %s, %s, %s, %s, %s,%s,%s)
        """, (first_name, last_name, email, phone, age, sex, blood_type, height, weight))
        db.commit()

        return redirect(url_for('patients'))

    return render_template('add_patient.html')

# Show Patient Records for a Selected Patient
'''
@app.route('/patients/<int:patient_id>')
def patient_record(patient_id):
    # Get patient details
    cursor.execute("SELECT * FROM Patient WHERE Patient_Number = %s", (patient_id,))
    patient = cursor.fetchone()

    # Get their medical records
    cursor.execute("SELECT * FROM Patient_Record WHERE Patient_Number = %s", (patient_id,))
    records = cursor.fetchall()

    return render_template('patients_records.html', patient=patient, records=records)
'''

@app.route('/patients/<int:patient_id>', methods=['GET', 'POST'])
def patient_record(patient_id):
    if request.method == 'POST':
        staff_number = request.form['staff_number']
        date = request.form['date']
        diagnostic = request.form['diagnostic']
        medication = request.form['medication']

        cursor.execute("""
            INSERT INTO Patient_Record (Patient_Number, Staff_Number, Date, Diagnostic, Medication)
            VALUES (%s, %s, %s, %s, %s)
        """, (patient_id, staff_number, date, diagnostic, medication))
        db.commit()

        return redirect(url_for('patient_record', patient_id=patient_id))

    # Get patient details
    cursor.execute("SELECT * FROM Patient WHERE Patient_Number = %s", (patient_id,))
    patient = cursor.fetchone()

    # Get patient records
    cursor.execute("SELECT * FROM Patient_Record WHERE Patient_Number = %s", (patient_id,))
    records = cursor.fetchall()

    return render_template('patients_records.html', patient=patient, records=records)





@app.route('/staff')
def staff():
    # Fetch doctors
    cursor.execute("SELECT * FROM Doctor")
    doctors = cursor.fetchall()

    # Fetch nurses
    cursor.execute("SELECT * FROM Nurse")
    nurses = cursor.fetchall()

    return render_template('staff.html', doctors=doctors, nurses=nurses)




# Display Pricing
@app.route('/pricing', methods=['GET', 'POST'])
def pricing():
    if request.method == 'POST':
        staff_number = request.form['staff_number']
        first_name = request.form['first_name']
        date = request.form['date']
        pricing = request.form['pricing']
        description = request.form['description']

        cursor.execute("""
            INSERT INTO Patient_Payment (Staff_Number, First_Name, Date, Pricing, Description)
            VALUES (%s, %s, %s, %s, %s)
        """, (staff_number, first_name, date, pricing, description))
        db.commit()

        return redirect(url_for('pricing'))

    cursor.execute("SELECT * FROM Patient_Payment")
    payments = cursor.fetchall()
    return render_template('pricing.html', payments=payments)

@app.route('/suggest_medication', methods=['POST'])
def suggest_medication():
    data = request.get_json()
    diagnostic_input = data.get('diagnostic', '')

    if not diagnostic_input:
        return {'medication': ''}

    # Fetch all unique diagnoses and their medications
    cursor.execute("SELECT Diagnostic, Medication FROM Patient_Record")
    records = cursor.fetchall()
    
    # Create a mapping of diagnosis -> medication (using the most recent or arbitrary one if duplicates exist)
    # Ideally, we'd want the most frequent one, but for now, let's keep it simple.
    diag_med_map = {row['Diagnostic']: row['Medication'] for row in records if row['Diagnostic']}
    
    # Find the closest match
    known_diagnoses = list(diag_med_map.keys())
    matches = difflib.get_close_matches(diagnostic_input, known_diagnoses, n=1, cutoff=0.6)

    if matches:
        best_match = matches[0]
        return {'medication': diag_med_map[best_match]}
    
    return {'medication': ''}

if __name__ == '__main__':
    app.run(debug=True)
