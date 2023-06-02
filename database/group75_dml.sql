/*--------------------------------------------

            SELECT QUERIES

--------------------------------------------*/

/* Companies */

-- get all companies data for browse companies page
SELECT * FROM Companies;

-- get all company names in ascending order to populate dropdown
SELECT company_id, name FROM Companies
ORDER BY name ASC;

-- get a single company's name for update form
-- (total drugs should not be able to be editted since it is dependent on a subquery)
SELECT * FROM Companies
WHERE company_id = :company_id_selected_from_browse_companies_page;

/* Companies_Drugs */

-- get all companies_drugs for browse companies_drugs page
SELECT Companies_Drugs.companies_drugs_id AS ID, Companies.name AS Company, Drugs.name AS Drug FROM Companies_Drugs
INNER JOIN Companies ON Companies_Drugs.company_id = Companies.company_id
INNER JOIN Drugs ON Drugs.drug_id = Companies_Drugs.drug_id;

-- get specific companies_drugs relationship for update form
SELECT Companies_Drugs.companies_drugs_id AS ID, Companies.name AS Company, Drugs.name AS Drug FROM Companies_Drugs
INNER JOIN Companies ON Companies_Drugs.company_id = Companies.company_id
INNER JOIN Drugs ON Drugs.drug_id = Companies_Drugs.drug_id
WHERE companies_drugs_id = :companies_drugs_id_selected_from_browse_companies_page;

-- get all drugs associated with a specific company
SELECT Drugs.name FROM Companies_Drugs
INNER JOIN Companies ON Companies_Drugs.company_id = Companies.company_id
INNER JOIN Drugs ON Drugs.drug_id = Companies_Drugs.drug_id
WHERE Companies_Drugs.company_id = :company_id_selected_from_browse_companies_drugs_page;

-- get all companies associated with a specific drug
SELECT Companies.name FROM Companies_Drugs
INNER JOIN Companies ON Companies_Drugs.company_id = Companies.company_id
INNER JOIN Drugs ON Drugs.drug_id = Companies_Drugs.drug_id
WHERE Companies_Drugs.drug_id = :drug_id_selected_from_browse_companies_drugs_page;

/* Drugs */

-- get all drug data for browse drugs page
SELECT * FROM Drugs;

-- get all drug names in ascending order to populate dropdown
SELECT drug_id, name FROM Drugs
ORDER BY name ASC;

-- get a single drug's data for update drug form
SELECT * FROM Drugs WHERE drug_id = :drug_id_selected_from_browse_drugs_page;

/* Patients */

-- get all patient data for browse patient page
SELECT * FROM Patients;

-- get a single patient's data for update patient form
SELECT * FROM Patients WHERE patient_id = :patient_id_selected_from_browse_patients_page;

/* Prescriptions */

-- get all prescriptions for browse prescriptions page
SELECT Prescriptions.prescription_id, Patients.lname, Patients.fname, Drugs.name AS Drug, Prescriptions.start_date, Prescriptions.end_date, Frequencies.description AS Frequency, Routes.description AS Route, Prescriptions.description
FROM Prescriptions
INNER JOIN Patients ON Prescriptions.patient_id = Patients.patient_id
INNER JOIN Drugs ON Prescriptions.drug_id = Drugs.drug_id
INNER JOIN Frequencies ON Prescriptions.frequency_id = Frequencies.frequency_id
INNER JOIN Routes ON Prescriptions.route_id = Routes.route_id;

-- get all prescriptions for a specific patient
SELECT Patients.lname, Patients.fname, Drugs.name, Prescriptions.start_date, Prescriptions.end_date, Frequencies.description, Routes.description, Prescriptions.description
FROM Prescriptions
INNER JOIN Patients ON Prescriptions.patient_id = Patients.patient_id
INNER JOIN Drugs ON Prescriptions.drug_id = Drugs.drug_id
INNER JOIN Frequencies ON Prescriptions.frequency_id = Frequencies.frequency_id
INNER JOIN Routes ON Prescriptions.route_id = Routes.route_id
WHERE Prescriptions.patient_id = :patient_id_input;

-- get all prescriptions for a specific drug
SELECT Patients.lname, Patients.fname, Drugs.name, Prescriptions.start_date, Prescriptions.end_date, Frequencies.description, Routes.description, Prescriptions.description
FROM Prescriptions
INNER JOIN Patients ON Prescriptions.patient_id = Patients.patient_id
INNER JOIN Drugs ON Prescriptions.drug_id = Drugs.drug_id
INNER JOIN Frequencies ON Prescriptions.frequency_id = Frequencies.frequency_id
INNER JOIN Routes ON Prescriptions.route_id = Routes.route_id
WHERE Prescriptions.drug_id = :drug_id_from_dropdown_input;

-- get a single prescription's data for update prescription form
SELECT Patients.lname, Patients.fname, Drugs.name, Prescriptions.start_date, Prescriptions.end_date, Frequencies.description, Routes.description, Prescriptions.description
FROM Prescriptions
INNER JOIN Patients ON Prescriptions.patient_id = Patients.patient_id
INNER JOIN Drugs ON Prescriptions.drug_id = Drugs.drug_id
INNER JOIN Frequencies ON Prescriptions.frequency_id = Frequencies.frequency_id
INNER JOIN Routes ON Prescriptions.route_id = Routes.route_id
WHERE Prescriptions.prescription_id = :prescription_id_selected_from_browse_prescriptions_page;

/* Frequencies */

-- get all frequencies for browse frequencies page
SELECT * FROM Frequencies;

-- get all frequency descriptions to populate dropdown
SELECT description FROM Frequencies;

/* Routes */

-- get all routes for browse routes page
SELECT * FROM Routes;

-- get all route descriptions to populate dropdown
SELECT description FROM Routes;


/*--------------------------------------------

            INSERT QUERIES

--------------------------------------------*/

/* Companies */

-- add a new company
INSERT INTO Companies(name, total_drugs)
VALUES (:name_input, 0);

/* Companies_Drugs */

-- associate a company with a drug
INSERT INTO Companies_Drugs(company_id, drug_id)
VALUES (:company_id_from_dropdown_input, :drug_id_from_dropdown_input);

/* Drugs */

-- add a new drug
INSERT INTO Drugs(name, year_approved)
VALUES (:drug_name_input, :year_approved_input);

/* Patients */

-- add a new patient
INSERT INTO Patients(lname, fname, email, phone, birthday)
VALUES (:lname_input, :fname_input, :email_input, :phone_input, :birthday_input);

/* Prescriptions */

-- add a new prescription
INSERT INTO Prescriptions(drug_id, patient_id, start_date, end_date, frequency_id, route_id, description)
VALUES (:drug_id_from_dropdown_input, :patient_id_input, :start_date_input, :end_date_input, :frequency_id_from_dropdown_input, :route_id_from_dropdown_input, :prescription_description_input);

/* Frequencies */

-- add a new frequency
INSERT INTO Frequencies(description)
VALUES (:frequency_description_input);

/* Routes */

-- add a new route
INSERT INTO Routes(description)
VALUES(:route_description_input);


/*--------------------------------------------

            UPDATE QUERIES

--------------------------------------------*/

/* Companies */

-- update company data based on update form
UPDATE Companies
SET name = :name_input
WHERE company_id = :company_id_from_the_update_form;

-- update number of drugs produced by a company
-- this query should be used upon associating/disassociating a drug with a company
UPDATE Companies
SET total_drugs = (SELECT COUNT(company_id) FROM Companies_Drugs WHERE Companies_Drugs.company_id = Companies.company_id);

/* Companies_Drugs */
-- update companies_drugs relationship based on update form
UPDATE Companies_Drugs
SET company_id = :company_id_input, drug_id = :drug_id_input
WHERE companies_drugs_id = :companies_drugs_id_from_the_update_form;

/* Patients */

-- update patient data based on update form
UPDATE Patients
SET fname = :fname_input, lname = :lname_input, email = :email_input, phone = :phone_input, birthday = :birthday_input
WHERE patient_id = :patient_id_from_the_update_form;

/* Prescriptions */

-- update prescription data based on update form
UPDATE Prescriptions
SET patient_id = :patient_id_input, drug_id = :drug_id_from_dropdown_input, start_date = :start_date_input, end_date = :end_date_input, frequency_id = :frequency_id_from_dropdown_input, route_id = :route_id_from_dropdown_input, description = :prescription_description_input
WHERE prescription_id = :prescription_id_from_the_update_form;


/*--------------------------------------------

            DELETE QUERIES

--------------------------------------------*/


/* Companies */

-- delete a company
DELETE FROM Companies WHERE company_id = :company_id_selected_from_browse_companies_page;

/* Companies_Drugs */

-- dis-associate a company from a drug (M:M relationship deletion)
DELETE FROM Companies_Drugs WHERE companies_drugs_id = :companies_drugs_id_selected_from_browse_page;

/* Drugs */

-- delete a drug
DELETE FROM Drugs WHERE drug_id = :drug_id_selected_from_browse_drugs_page;

/* Patients */

-- delete a patient
DELETE FROM Patients WHERE patient_id = :patient_id_selected_from_browse_patients_page;

/* Prescriptions */

-- delete a prescription
DELETE FROM Prescriptions WHERE prescription_id = :prescription_id_selected_from_browse_prescriptions_page;

/* Frequencies */

-- delete a frequency
DELETE FROM Frequencies WHERE frequency_id = :frequency_id_selected_from_browse_frequencies_page;

/* Routes */

-- delete a route
DELETE FROM Routes WHERE route_id = :route_id_selected_from_browse_routes_page;