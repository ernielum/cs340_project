from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
from dotenv import load_dotenv, find_dotenv

import os

# db_connector file might not actually be needed
# due to the way we interact with the database
import database.db_connector as db

# Load the .env file into the environment variables
load_dotenv()

# Set the variables in our app to the already set environment variables
host = os.environ.get("340DBHOST")
user = os.environ.get("340DBUSER")
passwd = os.environ.get("340DBPW")
database = os.environ.get("340DB")

app = Flask(__name__)
db_connection = db.connect_to_database()

app.config['MYSQL_HOST'] = host
app.config['MYSQL_USER'] = user
app.config['MYSQL_PASSWORD'] = passwd
app.config['MYSQL_DB'] = database
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)

# Routes

@app.route('/')
def root():
    return render_template("index.j2")

@app.route('/index.j2')
def index():
    return render_template("index.j2")

@app.route('/companies.j2', methods=['POST', 'GET'])
def companies():
    if request.method == 'POST':
        # add company
        if request.form.get("addCompany"):
        # retrieve user form input
            name = request.form['name']
            query = "INSERT INTO Companies(name, total_drugs) VALUES (%s, 0);"
            cur = mysql.connection.cursor()
            cur.execute(query, (name,))
            mysql.connection.commit()
        return redirect("/companies.j2")
    
    if request.method == 'GET':
        # mySQL query to show all companies in Companies
        query = "SELECT * FROM Companies;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        companies_data = cur.fetchall()
        return render_template("companies.j2", companies=companies_data)
    
    
@app.route('/companies/delete/<int:id>')
def delete_company(id):
    # mySQL query to delete the company with passed id
    query = "DELETE FROM Companies WHERE company_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    return redirect("/companies.j2")

@app.route('/companies/edit/<int:id>', methods=['POST', 'GET'])
def edit_company(id):
    if request.method == 'GET':
        query = "SELECT * FROM Companies WHERE company_id = %s;"
        cur = mysql.connection.cursor()
        cur.execute(query, (id, ))
        data = cur.fetchall()
        return render_template("edit_companies.j2", data=data)
    
    if request.method == 'POST':
        # edit company
        if request.form.get("updateCompany"):
            # retrieve user form input
            id = request.form["companyID"]
            name = request.form["name"]
            query = "UPDATE Companies SET name = %s WHERE company_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (name, id))
            mysql.connection.commit()
        return redirect("/companies.j2")
           
@app.route('/drugs.j2', methods=['POST', 'GET'])
def drugs():
    if request.method == 'POST':
        # add drug
        if request.form.get("addDrug"):
        # retrieve user form input
            name = request.form['name']
            year_approved = request.form["year_approved"]
            query = "INSERT INTO Drugs (name, year_approved) VALUES (%s, %s);"
            cur = mysql.connection.cursor()
            cur.execute(query, (name, year_approved))
            mysql.connection.commit()
        return redirect("/drugs.j2")
    
    if request.method == 'GET':
        # mySQL query to show all drugs in Drugs
        query = "SELECT * FROM Drugs;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        drugs_data = cur.fetchall()
        return render_template("drugs.j2", drugs=drugs_data)

@app.route('/drugs/delete/<int:id>')
def delete_drug(id):
    # mySQL query to delete the drug with passed id
    query = "DELETE FROM Drugs WHERE drug_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    return redirect("/drugs.j2")

@app.route('/patients.j2', methods=['POST', 'GET'])
def patients():
    if request.method == 'POST':
        # add patient
        if request.form.get("addPatient"):
        # retrieve user form input
            fname = request.form['fname']
            lname = request.form['lname']
            email = request.form['email']
            phone = request.form['phone']
            birthday = request.form['birthday']
            query = "INSERT INTO Patients(fname, lname, email, phone, birthday) VALUES (%s, %s, %s, %s, %s);"
            cur = mysql.connection.cursor()
            cur.execute(query, (fname, lname, email, phone, birthday,))
            mysql.connection.commit()
        return redirect("/patients.j2")
    
    if request.method == 'GET':
        # mySQL query to show all patients in Patients
        query = "SELECT * FROM Patients;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        patients_data = cur.fetchall()
        return render_template("patients.j2", patients=patients_data)
    
@app.route('/patients/delete/<int:id>')
def delete_patient(id):
    # mySQL query to delete the patient with the passed id.
    query = "DELETE FROM Patients WHERE patient_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    return redirect("/patients.j2")

@app.route('/patients/edit/<int:id>', methods=['POST', 'GET'])
def edit_patient(id):
    if request.method == 'GET':
        query = "SELECT * FROM Patients WHERE patient_id = %s;"
        cur = mysql.connection.cursor()
        cur.execute(query, (id,))
        data = cur.fetchall()
        return render_template("edit_patients.j2", data=data)
    
    if request.method == 'POST':
        if request.form.get("updatePatient"):
            # retrieve user form input
            fname = request.form['fname']
            lname = request.form['lname']
            email = request.form['email']
            phone = request.form['phone']
            birthday = request.form['birthday']
            query = "UPDATE Patients SET fname = %s, lname = %s, email = %s, phone = %s, birthday = %s WHERE patient_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (fname, lname, email, phone, birthday, id))
            mysql.connection.commit()
        return redirect("/patients.j2")


@app.route('/prescriptions.j2', methods=['POST', 'GET'])
def prescriptions():
    if request.method == 'POST':
        # add prescription
        if request.form.get("addPrescription"):
        # retrieve user form input
            drug_id = request.form["drug_id"]
            patient_id = request.form['patient_id']
            start_date = request.form["start_date"]
            end_date = request.form["end_date"]
            frequency = request.form["prescription_frequency"]
            route = request.form["prescription_route"]
            description = request.form["prescription_description"]
            query = "INSERT INTO Prescriptions(drug_id, patient_id, start_date, end_date, frequency_id, route_id, description) VALUES (%s, %s, %s, %s, %s, %s, %s);"
            cur = mysql.connection.cursor()
            cur.execute(query, (drug_id, patient_id, start_date, end_date, frequency, route, description))
            mysql.connection.commit()
        return redirect("/prescriptions.j2")
    
    if request.method == 'GET':
        # mySQL query to show all prescriptions in Prescriptions
        query = "SELECT Prescriptions.prescription_id, Patients.lname, Patients.fname, Drugs.name AS Drug, Prescriptions.start_date, Prescriptions.end_date, Frequencies.description AS Frequency, Routes.description AS Route, Prescriptions.description  FROM Prescriptions INNER JOIN Patients ON Prescriptions.patient_id = Patients.patient_id INNER JOIN Drugs ON Prescriptions.drug_id = Drugs.drug_id INNER JOIN Frequencies ON Prescriptions.frequency_id = Frequencies.frequency_id INNER JOIN Routes ON Prescriptions.route_id = Routes.route_id;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        prescriptions_data = cur.fetchall()

        # mySQL query to grab drug id/name data from dropdown

        query = "SELECT drug_id, name FROM Drugs ORDER BY name ASC;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        drugs_data = cur.fetchall()

        # mySQL query to grab frequency id/description data from dropdown

        query = "SELECT * FROM Frequencies;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        frequencies_data = cur.fetchall()

        # mySQL query to grab route id/description data from dropdown

        query = "SELECT * FROM Routes;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        routes_data = cur.fetchall()

        return render_template("prescriptions.j2", prescriptions=prescriptions_data, drugs=drugs_data, frequencies=frequencies_data, routes=routes_data)

@app.route('/prescriptions/delete/<int:id>')
def delete_prescription(id):
    # mySQL query to delete the prescription with passed id
    query = "DELETE FROM Prescriptions WHERE prescription_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    return redirect("/prescriptions.j2")

@app.route('/routes.j2', methods=['POST', 'GET'])
def routes():
    if request.method == 'POST':
        if request.form.get("addRoute"):
            description = request.form['description']
            query = "INSERT INTO Routes (description) VALUES (%s);"
            cur = mysql.connection.cursor()
            cur.execute(query, (description,))
            mysql.connection.commit()
        return redirect("/routes.j2")

    if request.method == 'GET':
        query = "SELECT * FROM Routes;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        routes_data = cur.fetchall()
        return render_template("/routes.j2", routes=routes_data)
    
@app.route('/frequencies.j2', methods=['POST', 'GET'])
def frequencies():
    if request.method == 'POST':
        if request.form.get("addFrequency"):
            description = request.form['description']
            query = "INSERT INTO Frequencies(description) VALUES (%s);"
            cur = mysql.connection.cursor()
            cur.execute(query, (description,))
            mysql.connection.commit()
        return redirect("/frequencies.j2")

    if request.method == 'GET':
        query = "SELECT * FROM Frequencies;"
        cur = mysql.connection.cursor()
        cur.execute(query)
        freq_data = cur.fetchall()
        return render_template("frequencies.j2", frequencies=freq_data)

@app.route('/frequencies/delete/<int:id>')
def delete_frequency(id):
    query = "DELETE FROM Frequencies WHERE frequency_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    return redirect("/frequencies.j2")


@app.route('/companies_drugs.j2')
def companies_drugs():
    return render_template("companies_drugs.j2")

@app.route('/test_companies')
def test_companies():
    query = "SELECT * FROM Companies;"

    cursor = db.execute_query(db_connection=db_connection, query=query)
    results = json.dumps(cursor.fetchall())

    return results

# Listener

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 49171)) 
    #                                 ^^^^
    #              You can replace this number with any valid port
    
    app.run(port=port) 