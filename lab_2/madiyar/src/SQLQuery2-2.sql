USE [Civil_Registry_System]
CREATE TABLE Certificate_Types (
    CertificateTypeID INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) NOT NULL
        CHECK (Name IN (N'Birth', N'Marriage Registration', N'Divorce', N'Death'))
);
GO
CREATE TABLE Nationalities (
    NationalityID INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) NOT NULL
);
GO
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY NOT NULL,
    FullName NVARCHAR(100) NOT NULL
);
GO
CREATE TABLE Citizens (
    IIN CHAR(12) PRIMARY KEY NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    BirthPlace NVARCHAR(100) NULL,
    Address NVARCHAR(150) NULL,
    Gender NVARCHAR(10) NULL,
    DocumentNumber NVARCHAR(20) NULL,
    DocumentIssueDate DATE NULL,
    NationalityID INT NULL,
    MaritalStatus NVARCHAR(20) NULL
        CHECK (MaritalStatus IN (N'Single', N'Married', N'Divorced', N'Widowed', N'Deceased')),
    FOREIGN KEY (NationalityID) REFERENCES Nationalities(NationalityID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);
GO
CREATE TABLE Certificates (
    CertificateID INT PRIMARY KEY NOT NULL,
    CertificateTypeID INT NOT NULL,
    RegistrationDate DATE NOT NULL,
    IssueDate DATE NOT NULL,
    RegistryOfficeName NVARCHAR(100) NOT NULL,
    EmployeeID INT NOT NULL,
    FOREIGN KEY (CertificateTypeID) REFERENCES Certificate_Types(CertificateTypeID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO
CREATE TABLE Certificate_Wife_Mother (
    CertificateID INT NOT NULL,
    CitizenIIN CHAR(12) NOT NULL,
    FOREIGN KEY (CertificateID) REFERENCES Certificates(CertificateID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (CitizenIIN) REFERENCES Citizens(IIN)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO
CREATE TABLE Certificate_Husband_Father (
    CertificateID INT NOT NULL,
    CitizenIIN CHAR(12) NOT NULL,
    FOREIGN KEY (CertificateID) REFERENCES Certificates(CertificateID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (CitizenIIN) REFERENCES Citizens(IIN)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO
CREATE TABLE Certificate_Child (
    CertificateID INT NOT NULL,
    CitizenIIN CHAR(12) NOT NULL,
    FOREIGN KEY (CertificateID) REFERENCES Certificates(CertificateID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (CitizenIIN) REFERENCES Citizens(IIN)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO
CREATE TABLE Certificate_Death (
    CertificateID INT NOT NULL,
    CitizenIIN CHAR(12) NOT NULL,
    Diagnosis NVARCHAR(100) NULL,
    FOREIGN KEY (CertificateID) REFERENCES Certificates(CertificateID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (CitizenIIN) REFERENCES Citizens(IIN)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO
CREATE TABLE Payments (
    CertificateID INT NOT NULL,
    CitizenIIN CHAR(12) NOT NULL,
    TaxAmount MONEY NOT NULL CHECK (TaxAmount >= 0),
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (CertificateID) REFERENCES Certificates(CertificateID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (CitizenIIN) REFERENCES Citizens(IIN)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO
