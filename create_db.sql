-- Create the Members table
CREATE TABLE Members (
    UserID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(50),
    LastName VARCHAR2(50),
    BirthDate DATE,
    Email VARCHAR2(100) UNIQUE,
    Gender CHAR(1));
 
-- Create the ExerciseActivities table
CREATE TABLE ExerciseActivities (
    ActivityID NUMBER PRIMARY KEY,
    UserID NUMBER,
    ActivityName VARCHAR2(100),
    ActivityDate DATE,
    DurationInMinutes NUMBER,
    CaloriesBurned NUMBER,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
 
-- Create the DietLog table
CREATE TABLE DietLog (
    LogID NUMBER PRIMARY KEY,
    UserID NUMBER,
    MealDate DATE,
    MealDescription VARCHAR2(255),
    CaloriesConsumed NUMBER,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
 
-- Create the BodyMeasurements table
CREATE TABLE BodyMeasurements (
    MeasurementID NUMBER PRIMARY KEY,
    UserID NUMBER,
    MeasurementDate DATE,
    Height NUMBER(5, 2),
    Weight NUMBER(5, 2),
    BodyFatPercentage NUMBER(4, 2),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
 
-- Create the HealthRecords table
CREATE TABLE HealthRecords (
    RecordID NUMBER PRIMARY KEY,
    UserID NUMBER,
    RecordDate DATE,
    BloodPressure VARCHAR2(10),
    CholesterolLevel NUMBER,
    HeartRate NUMBER,
    Notes CLOB,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
