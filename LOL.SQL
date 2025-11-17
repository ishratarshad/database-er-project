Create Table Departments (
    DeptID INT PRIMARY KEY,
    Phone VARCHAR(15),
    Name VARCHAR(50),
    Location VARCHAR(50)
);

Create Table Doctor (
    DoctorId INT PRIMARY KEY,
    Availability VARCHAR(50),
    Name VARCHAR(50),
    Contact VARCHAR(50),
    Dept INT,
    Specialty VARCHAR(50),
    FOREIGN KEY (Dept) REFERENCES Departments(DeptID)
);

Create Table Patient (
    PatientId INT PRIMARY KEY Name VARCHAR(50),
    Contact VARCHAR(50),
    DOB DATE,
    Insurnace VARCHAR (50),
);
Create Table Appointments (
    ApptID INT PRIMARY KEY,
    Status ENUM ('Active', 'Rescheuled', 'Completed'),
    Reason TEXT,
    StartTime DATETIME,
    EndTime DATETIME,
    ApptDate DATE,
    Patient INT,
    Doctor INT,
    CancelledReason TEXT,
    RescheuledId, 
    FOREIGN KEY (RescheuledId) REFERENCES (ApptID)
    FOREIGN KEY (Patient) REFERENCES Patient(PatientId),
    FOREIGN KEY (Doctor) REFERENCES Doctor(DoctorId)
);
Create Table Allergies (
    AllerID INT PRIMARY KEY,
    Severity ENUM (`High`, 'Med', 'Low'),
    Allergen TEXT,
    Patient INT,
    FOREIGN KEY (Patient) REFERENCES (PatientId)
);

Create Table Invoices (
    InvoiceID INT PRIMARY KEY,
    Patient INT,
    Visit INT,
    IssueDate DATE,
    DueDate DATE,
    Status ENUM ('Draft', 'Issued', 'Paid', 'Partial', 'Overdue', 'Cancelled', 'Refunded', 'Uncollectible'),
    FOREIGN KEY (Patient) REFERENCES Patient(PatientId)
    -- FOREIGN KEY (Visit) REFERENCES 
);

Create Table InvoiceItems (
    ItemID INT PRIMARY KEY,
    Invoice INT,
    Code TEXT,
    Descriptions TEXT,
    LineTotal INT,
    Cost INT,
    Quantity INT,
    FOREIGN KEY (Invoice) REFERENCES Invoices(InvoiceID)
);

Create Table Payments (
    PaymentID INT PRIMARY KEY,
    Invoice INT,
    Source TEXT,
    Method ENUM('Cash', 'Debit/Credit', 'Check', 'Digital Wallet', 'Electronic Transfer', 'Payment Platform'),
    Amount INT,
    RecieveTime Time,
    referenceNO INT,
    FOREIGN KEY (Invoice) REFERENCES Invoices(InvoiceID)
);