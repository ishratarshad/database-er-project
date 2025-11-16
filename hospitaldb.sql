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
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
);

-- patient table
CREATE TABLE PATIENT (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(50),
    Contact VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    Address VARCHAR(100)
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
    Notes TEXT,
    VisitType VARCHAR(50),
    FOREIGN KEY (ApptID) REFERENCES APPOINTMENT(ApptID)
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

-- prescription table
CREATE TABLE PRESCRIPTION (
    PrescriptionID INT PRIMARY KEY,
    VisitID INT,
    MedicationID INT,
    Dosage VARCHAR(100),
    Frequency VARCHAR(100),
    Duration VARCHAR(100),
    FOREIGN KEY (VisitID) REFERENCES VISIT(VisitID),
    FOREIGN KEY (MedicationID) REFERENCES MEDICATION(MedicationID)
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
    Source VARCHAR(50),
    Method ENUM(
        'Cash','Debit/Credit','Check','Digital Wallet',
        'Electronic Transfer','Payment Platform'
    ),
    Amount DECIMAL(10,2),
    ReceivedTime DATETIME,
    ReferenceNo VARCHAR(50),
    FOREIGN KEY (InvoiceID) REFERENCES INVOICE(InvoiceID)
);

-- insurance provider table
CREATE TABLE INSURANCEPROVIDER (
    ProviderID INT PRIMARY KEY,
    ProviderName VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(100)
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
