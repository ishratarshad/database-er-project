DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- department table
CREATE TABLE DEPARTMENT (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Phone VARCHAR(15),
    Location VARCHAR(50)
);

-- doctor table
CREATE TABLE DOCTOR (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(50),
    Contact VARCHAR(50),
    Specialty VARCHAR(50),
    Availability VARCHAR(50),
    Credentials TEXT,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
);

-- insurance provider table
CREATE TABLE INSURANCEPROVIDER (
    ProviderID INT PRIMARY KEY,
    ProviderName VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(100)
);

-- patient table
CREATE TABLE PATIENT (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(50),
    Contact VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    Address VARCHAR(100),
    ProviderID INT, 
    FOREIGN KEY (ProviderID) REFERENCES INSURANCEPROVIDER(ProviderID)
);

-- appointment table (self-reference for rescheduling)
CREATE TABLE APPOINTMENT (
    ApptID INT PRIMARY KEY,
    Status ENUM('Active', 'Rescheduled', 'Completed', 'Cancelled'),
    Reason TEXT,
    ApptDate DATE,
    StartTime DATETIME,
    EndTime DATETIME,
    CancelledReason TEXT,
    RescheduledApptID INT,
    PatientID INT,
    DoctorID INT,
    FOREIGN KEY (RescheduledApptID) REFERENCES APPOINTMENT(ApptID),
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID)
);

-- visit table
CREATE TABLE VISIT (
    VisitID INT PRIMARY KEY,
    ApptID INT,
    VisitDateTime DATETIME,
    Diagnosis TEXT,
    Treatment TEXT,
    VisitType VARCHAR(50),
    PatientID INT,
    FOREIGN KEY (ApptID) REFERENCES APPOINTMENT(ApptID),
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID)
);

-- allergy table
CREATE TABLE ALLERGY (
    AllergyID INT PRIMARY KEY,
    PatientID INT,
    Allergen TEXT,
    Severity ENUM('High', 'Med', 'Low'),
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID)
);

-- medication table
CREATE TABLE MEDICATION (
    MedicationID INT PRIMARY KEY,
    Name VARCHAR(50),
    Form VARCHAR(50),
    Strength VARCHAR(50),
    Manufacturer VARCHAR(50)
);

-- prescription table (UPDATED: added DoctorID + FK)
CREATE TABLE PRESCRIPTION (
    PrescriptionID INT PRIMARY KEY,
    VisitID INT,
    PatientID INT,
    MedicationID INT,
    DoctorID INT,
    Dosage VARCHAR(100),
    Frequency VARCHAR(100),
    Duration VARCHAR(100),
    FOREIGN KEY (VisitID) REFERENCES VISIT(VisitID),
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID),
    FOREIGN KEY (MedicationID) REFERENCES MEDICATION(MedicationID),
    FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID)
);

-- invoice table
CREATE TABLE INVOICE (
    InvoiceID INT PRIMARY KEY,
    PatientID INT,
    VisitID INT,
    IssueDate DATE,
    DueDate DATE,
    Status ENUM(
        'Draft','Issued','Paid','Partial','Overdue',
        'Cancelled','Refunded','Uncollectible'
    ),
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID),
    FOREIGN KEY (VisitID) REFERENCES VISIT(VisitID)
);

-- invoice item table
CREATE TABLE INVOICEITEM (
    ItemID INT PRIMARY KEY,
    InvoiceID INT,
    Code VARCHAR(50),
    Description TEXT,
    Quantity INT,
    Cost DECIMAL(10,2),
    LineTotal DECIMAL(10,2),
    FOREIGN KEY (InvoiceID) REFERENCES INVOICE(InvoiceID)
);

-- payment table
CREATE TABLE PAYMENT (
    PaymentID INT PRIMARY KEY,
    InvoiceID INT,
    PatientID INT,
    Source VARCHAR(50),
    Method ENUM(
        'Cash','Debit/Credit','Check','Digital Wallet',
        'Electronic Transfer','Payment Platform'
    ),
    Amount DECIMAL(10,2),
    ReceivedTime DATETIME,
    ReferenceNo VARCHAR(50),
    FOREIGN KEY (InvoiceID) REFERENCES INVOICE(InvoiceID),
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID)
);

-- insurance policy table
CREATE TABLE INSURANCEPOLICY (
    PolicyID INT PRIMARY KEY,
    PolicyNumber VARCHAR(50),
    CoverageDetails TEXT,
    StartDate DATE,
    EndDate DATE,
    PatientID INT,
    ProviderID INT,
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID),
    FOREIGN KEY (ProviderID) REFERENCES INSURANCEPROVIDER(ProviderID)
);

-- sample data --

-- department rows
INSERT INTO DEPARTMENT (DeptID, DeptName, Phone, Location) VALUES
(1, 'Cardiology',       '212-555-1001', 'Building A, 3rd Floor'),
(2, 'Neurology',        '212-555-1002', 'Building B, 2nd Floor'),
(3, 'Pediatrics',       '212-555-1003', 'Building C, 1st Floor'),
(4, 'Oncology',         '212-555-1004', 'Building D, 4th Floor'),
(5, 'General Medicine', '212-555-1005', 'Building A, 1st Floor');

-- doctor rows 
INSERT INTO DOCTOR (DoctorID, Name, Contact, Specialty, Availability, Credentials, DeptID) VALUES
(101, 'Kakashi Hatake', '917-555-1101', 'Cardiologist', 'Mon-Fri 09:00-17:00',
 'MD, Board Certified in Cardiovascular Medicine', 1),
(102, 'Sakura Haruno',  '917-555-1102', 'Pediatrician', 'Mon-Thu 10:00-18:00',
 'MD, Pediatric Residency, Specialist in Child Development', 3),
(103, 'Kenzo Tenma',    '917-555-1103', 'Neurologist',  'Tue-Fri 08:00-16:00',
 'MD, PhD in Neuroscience, Board Certified in Neurology', 2),
(104, 'Rintaro Okabe',  '917-555-1104', 'Oncologist',   'Mon-Wed 11:00-19:00',
 'MD, Fellowship in Oncology and Cancer Research', 4),
(105, 'Shoko Ieiri',    '917-555-1105', 'Internist',    'Tue-Sat 09:00-17:00',
 'MD, Internal Medicine Specialist, Trauma Care Certification', 5);

-- insurance provider rows
INSERT INTO INSURANCEPROVIDER
(ProviderID, ProviderName, Phone, Address)
VALUES
(10001, 'Leaf Village Insurance',   '800-555-3001', '1 Hokage Plaza, Konoha'),
(10002, 'Wall Shield Health',      '800-555-3002', '5 Garrison Way, Shiganshina'),
(10003, 'Demon Slayer Care',       '800-555-3003', '7 Corps HQ Rd, Tokyo'),
(10004, 'UA Hero Health',          '800-555-3004', '1 Hero Way, Musutafu'),
(10005, 'Phantom Troupe Insurance','800-555-3005', '13 Meteor City Blvd, Unknown');

-- patient rows 
INSERT INTO PATIENT (PatientID, Name, Contact, DOB, Gender, Address, ProviderID) VALUES
(201, 'Naruto Uzumaki',   '347-555-2001', '2000-10-10', 'Male',   '12 Leaf Village Rd, Konoha', 10001),
(202, 'Mikasa Ackerman',  '347-555-2002', '2001-02-10', 'Female', '8 Wall Maria St, Shiganshina', 10001),
(203, 'Tanjiro Kamado',   '347-555-2003', '2002-07-14', 'Male',   '3 Mountain Path, Kamado House', 10002),
(204, 'Hinata Hyuga',     '347-555-2004', '2000-12-27', 'Female', '9 Byakugan Ave, Konoha', 10003),
(205, 'Izuku Midoriya',   '347-555-2005', '2003-07-15', 'Male',   '1 UA Dorms, Musutafu', 10004);

-- appointment rows
INSERT INTO APPOINTMENT
(ApptID, Status, Reason, ApptDate, StartTime, EndTime, CancelledReason, RescheduledApptID, PatientID, DoctorID)
VALUES
(1001, 'Cancelled',  'Chest pain and shortness of breath', '2025-11-01',
 '2025-11-01 09:00:00', '2025-11-01 09:30:00',
 'Patient requested reschedule', NULL, 201, 101),
(1002, 'Rescheduled','Follow-up for chest pain',          '2025-11-03',
 '2025-11-03 10:00:00', '2025-11-03 10:30:00',
 NULL, 1001, 201, 101),
(1003, 'Completed',  'Routine pediatric checkup',         '2025-11-02',
 '2025-11-02 11:00:00', '2025-11-02 11:30:00',
 NULL, NULL, 203, 102),
(1004, 'Completed',  'Migraine evaluation',               '2025-11-04',
 '2025-11-04 14:00:00', '2025-11-04 14:45:00',
 NULL, NULL, 202, 103),
(1005, 'Active',     'Annual physical exam',              '2025-11-10',
 '2025-11-10 13:00:00', '2025-11-10 13:30:00',
 NULL, NULL, 205, 105);

-- visit rows
INSERT INTO VISIT
(VisitID, ApptID, VisitDateTime, Diagnosis, Treatment, VisitType, PatientID)
VALUES
(3001, 1002, '2025-11-03 10:05:00', 'Stable angina','EKG performed, labs ordered', 'In-person', 201),
(3002, 1003, '2025-11-02 11:05:00', 'Healthy child visit', 'Vaccines up to date', 'In-person', 203),
(3003, 1004, '2025-11-04 14:10:00', 'Migraine without aura', 'Headache diary recommended', 'In-person', 202),
(3004, 1005, '2025-11-10 13:05:00', 'General checkup', 'Blood pressure slightly elevated', 'In-person', 203),
(3005, 1005, '2025-11-15 09:00:00', 'Telehealth follow-up', 'Discussed lifestyle changes', 'Telehealth', 204);

-- allergy rows
INSERT INTO ALLERGY
(AllergyID, PatientID, Allergen, Severity, Notes)
VALUES
(4001, 201, 'Peanuts',       'High', 'Carries epinephrine auto-injector'),
(4002, 202, 'Penicillin',    'Med',  'Avoid beta-lactam antibiotics'),
(4003, 203, 'Dust mites',    'Low',  'Triggers mild sneezing'),
(4004, 204, 'Shellfish',     'High', 'Anaphylaxis history'),
(4005, 205, 'Pollen',        'Low',  'Seasonal allergies in spring');

-- medication rows
INSERT INTO MEDICATION
(MedicationID, Name, Form, Strength, Manufacturer)
VALUES
(5001, 'Aspirin',           'Tablet',   '81 mg',   'Konoha Pharma'),
(5002, 'Metoprolol',        'Tablet',   '50 mg',   'Shiganshina Labs'),
(5003, 'Amoxicillin',       'Capsule',  '500 mg',  'Kamado Medical'),
(5004, 'Loratadine',        'Tablet',   '10 mg',   'UA Health'),
(5005, 'Sumatriptan',       'Tablet',   '50 mg',   'Wall Rose Pharma');

-- prescription rows (UPDATED: added DoctorID and aligned with visits/doctors)
INSERT INTO PRESCRIPTION
(PrescriptionID, VisitID, PatientID, MedicationID, DoctorID, Dosage, Frequency, Duration)
VALUES
(6001, 3001, 201, 5002, 101, '1 tablet', 'Twice daily', '30 days'),   -- visit 3001 → doctor 101
(6002, 3002, 203, 5001, 102, '1 tablet', 'Once daily',  '14 days'),   -- visit 3002 → doctor 102
(6003, 3003, 202, 5005, 103, '1 tablet', 'As needed',   '10 doses'),  -- visit 3003 → doctor 103
(6004, 3004, 203, 5004, 105, '1 tablet', 'Once daily',  '30 days'),   -- visit 3004 → doctor 105
(6005, 3005, 204, 5004, 105, '1 tablet', 'Once daily',  '90 days');   -- visit 3005 → doctor 105

-- invoice rows (fixed so patientid matches the visit's patient)
INSERT INTO INVOICE
(InvoiceID, PatientID, VisitID, IssueDate, DueDate, Status)
VALUES
(7001, 201, 3001, '2025-11-03', '2025-12-03', 'Issued'),
(7002, 203, 3002, '2025-11-02', '2025-12-02', 'Paid'),
(7003, 202, 3003, '2025-11-04', '2025-12-04', 'Partial'),
(7004, 203, 3004, '2025-11-10', '2025-12-10', 'Issued'),
(7005, 204, 3005, '2025-11-15', '2025-12-15', 'Draft');

-- invoice item rows
INSERT INTO INVOICEITEM
(ItemID, InvoiceID, Code, Description, Quantity, Cost, LineTotal)
VALUES
(8001, 7001, 'CONSULT', 'Cardiology consultation',   1, 200.00, 200.00),
(8002, 7001, 'EKG',     'Electrocardiogram',         1, 150.00, 150.00),
(8003, 7002, 'PEDVIS',  'Pediatric wellness visit',  1, 180.00, 180.00),
(8004, 7003, 'NEURO',   'Neurology consultation',    1, 220.00, 220.00),
(8005, 7004, 'GENCHK',  'General physical exam',     1, 160.00, 160.00);

-- payment rows
INSERT INTO PAYMENT
(PaymentID, InvoiceID, Source, Method, Amount, ReceivedTime, ReferenceNo)
VALUES
(9001, 7002, 'Patient',      'Debit/Credit',       180.00, '2025-11-05 15:30:00', 'PAY-2025-7002-1'),
(9002, 7001, 'Insurance',    'Electronic Transfer',150.00, '2025-11-06 10:15:00', 'PAY-2025-7001-1'),
(9003, 7001, 'Patient',      'Cash',                50.00, '2025-11-07 09:45:00', 'PAY-2025-7001-2'),
(9004, 7003, 'Patient',      'Payment Platform',   120.00, '2025-11-08 11:20:00', 'PAY-2025-7003-1'),
(9005, 7004, 'Patient',      'Digital Wallet',      80.00, '2025-11-11 14:00:00', 'PAY-2025-7004-1');

-- insurance policy rows
INSERT INTO INSURANCEPOLICY
(PolicyID, PolicyNumber, CoverageDetails, StartDate, EndDate, PatientID, ProviderID)
VALUES
(11001, 'POL-LEAF-201', 'Standard outpatient and emergency coverage',
 '2025-01-01', '2025-12-31', 201, 10001),
(11002, 'POL-WALL-202', 'Full inpatient and surgical coverage',
 '2025-02-01', '2026-01-31', 202, 10002),
(11003, 'POL-DEMON-203','Basic outpatient with prescription add-on',
 '2025-03-15', '2026-03-14', 203, 10003),
(11004, 'POL-UA-204',   'Student health plan with telehealth',
 '2025-04-01', '2026-03-31', 204, 10004),
(11005, 'POL-UA-205',   'Enhanced student plan with dental',
 '2025-04-01', '2026-03-31', 205, 10004);
