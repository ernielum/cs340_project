/* 
Create the following tables:
Drugs, Companies, Company_Drugs, Patients, Prescriptions, Routes, Frequencies 
*/

CREATE OR REPLACE TABLE Routes(
    route_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    description varchar(255) NOT NULL,
    PRIMARY KEY (route_id)
);

CREATE OR REPLACE TABLE Frequencies(
    frequency_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    description varchar(255) NOT NULL,
    PRIMARY KEY (frequency_id)
);

CREATE OR REPLACE TABLE Companies(
    company_id int AUTO_INCREMENT UNIQUE NOT NULL,
    name varchar(255) NOT NULL,
    total_drugs int NOT NULL DEFAULT 0,
    PRIMARY KEY (company_id)
);

CREATE OR REPLACE TABLE Drugs(
    drug_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    name varchar(255) NOT NULL,
    year_approved INT(4) NOT NULL,
    PRIMARY KEY (drug_id)
);

CREATE OR REPLACE TABLE Companies_Drugs(
    company_id int NOT NULL,
    drug_id int NOT NULL,
    -- as long as a company is producing a drug, the company cannot be deleted
    FOREIGN KEY (company_id) REFERENCES Companies(company_id),
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id) ON DELETE CASCADE
);


CREATE OR REPLACE TABLE Patients(
    patient_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    fname varchar(255) NOT NULL,
    lname varchar(255) NOT NULL,
    email varchar(255),
    phone char(10),
    birthday date NOT NULL,
    PRIMARY KEY (patient_id)
);

CREATE OR REPLACE TABLE Prescriptions(
    prescription_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    patient_id INT NOT NULL,
    drug_id INT NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    frequency_id INT NOT NULL,
    route_id int NOT NULL,
    description text,
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (frequency_id) REFERENCES Frequencies(frequency_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    PRIMARY KEY (prescription_id)
);

/* 
Insert reference data for category tables.
(Routes, Frequencies) examples are from https://www.fda.gov/regulatory-information/fdaaa-implementation-chart
*/

INSERT INTO Routes(description)
VALUES
('Oral'),
('Intravenous'),
('Intramuscular'),
('Ocular'),
('Otic'),
('Nasal'),
('Topical');

INSERT INTO Frequencies(description)
VALUES
('Everyday'),
('Every other day'),
('Every 8 hours'),
('Every 12 hours'),
('As Needed');

INSERT INTO Companies(name, total_drugs)
VALUES
('Pain Pain Go Away', 0),
('Easy Sneezy', 0),
('Legendary Bio', 0),
('Meds 4 You', 0),
('Milead', 0);

INSERT INTO Drugs(name, year_approved)
VALUES
('acetaminophen', 1950),
('enoxaparin', 1998),
('fluticasone', 1998),
('latanoprost', 1996),
('diclofenac', 2007);

INSERT INTO Companies_Drugs(company_id, drug_id)
VALUES
(1, 1),
(1, 5),
(2, 3),
(3, 4),
(4, 2);

INSERT INTO Patients(lname, fname, email, phone, birthday)
VALUES
('Parker', 'Peter', 'spiderman@gmail.com', 5381987555, '2001-08-10'),
('Stark', 'Tony', 'ironman@stark.com', 5913670923, '1970-05-29'),
('Allen', 'Barry', 'flashstep@hotmail.com', 5214085024, '1992-09-30'),
('Luck', 'Lucy', 'luckylucy@outlook.com', 4652876158, '2008-04-30'),
('Williamson', 'William', 'will@will.com', NULL, '2021-12-21');

INSERT INTO Prescriptions(drug_id, patient_id, start_date, end_date, frequency_id, route_id, description)
VALUES
(2, 1, '2022-01-25', '2022-02-21', 1, 3, 'To prevent blood clots.'),
(5, 1, '2022-02-07', '2022-03-02', 2, 7, 'For arthritis.'),
(1, 2, '2022-02-11', '2022-05-25', 5, 1, 'For headaches when Spiderman gets in trouble.'),
(2, 3, '2022-09-20', '2022-10-03', 2, 3, 'To prevent blood clots.'),
(3, 4, '2023-04-06', '2023-05-03', 5, 6, 'For allergies.');

UPDATE Companies
SET total_drugs = (SELECT COUNT(company_id) FROM Companies_Drugs WHERE Companies_Drugs.company_id = Companies.company_id);