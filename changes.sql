-- Change 1
-- Insert 100000 users with a birthdate between 1875 and 1880.

DECLARE
    i NUMBER;
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO Members (UserID, FirstName, LastName, BirthDate, Email, Gender)
        VALUES (USERIDSEQ.NEXTVAL, 'User' || i, 'LastName' || i, TO_DATE('01-JAN-' || TRUNC(DBMS_RANDOM.VALUE(1875, 1880)), 'DD-MON-YYYY'), 'user' || i || '@example.com', 'M');
    END LOOP;
END;
/


-- Change 2
-- Update the names of all new users inserted in change 1.

UPDATE Members
SET FirstName = 'NewFirstName', LastName = 'NewLastName'
WHERE BirthDate BETWEEN TO_DATE('01-JAN-1875', 'DD-MON-YYYY') AND TO_DATE('31-DEC-1880', 'DD-MON-YYYY');


-- Change 3
-- Add body measurements for all new users, between 1995 and 2000.

DECLARE
    i NUMBER;
BEGIN
    FOR i IN (SELECT UserID FROM Members WHERE EXTRACT(YEAR FROM BirthDate) BETWEEN 1875 AND 1880) LOOP
        INSERT INTO BodyMeasurements (MeasurementID, UserID, MeasurementDate, Height, Weight)
        VALUES (MEASUREMENT_SEQ.NEXTVAL, i.UserID, TO_DATE('01-JAN-' || TRUNC(DBMS_RANDOM.VALUE(1995, 2000)), 'DD-MON-YYYY'), 0, 0);
    END LOOP;
END;


-- Change 4
-- Delete all the newly added body measurements. 

DELETE FROM BodyMeasurements
WHERE EXTRACT(YEAR FROM MeasurementDate) < 2001;
