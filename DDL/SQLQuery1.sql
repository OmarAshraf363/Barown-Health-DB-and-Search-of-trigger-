create schema pre
go
CREATE TABLE pre.Patient (
    URNumber INT identity PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(150),
    Age INT,
    Email VARCHAR(50),
    Phone VARCHAR(15),
    MedicareCard VARCHAR(20) NULL
);
CREATE TABLE pre.Doctor (
    DoctorID INT identity PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50),
    Phone VARCHAR(15),
    Specialty VARCHAR(100),
    YearsOfExperience INT
);
CREATE TABLE pre.Company (
    CompanyID INT identity PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(150),
    Phone VARCHAR(15)
);
CREATE TABLE pre.Drug (
    DrugID INT identity PRIMARY KEY,
    TradeName VARCHAR(50),
    Strength VARCHAR(50),
    CompanyID INT,
    FOREIGN KEY (CompanyID) REFERENCES pre.Company(CompanyID) ON DELETE CASCADE
);
CREATE TABLE pre.Prescription (
    PrescriptionID INT identity PRIMARY KEY,
    Date DATE,
    Quantity INT,
    PatientID INT,
    DoctorID INT,
    DrugID INT,
    FOREIGN KEY (PatientID) REFERENCES pre.Patient(URNumber),
    FOREIGN KEY (DoctorID) REFERENCES pre.Doctor(DoctorID),
    FOREIGN KEY (DrugID) REFERENCES pre.Drug(DrugID)
);
CREATE TABLE pre.Patient_Doctor (
    DoctorID INT,
    PatientID INT,
    Pri_mary bit,
    PRIMARY KEY (DoctorID, PatientID),
    FOREIGN KEY (DoctorID) REFERENCES pre.Doctor(DoctorID),
    FOREIGN KEY (PatientID) REFERENCES pre.Patient(URNumber)
);