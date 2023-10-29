-- List the first name, last name, and email of users who have experienced an increase in weight of more than 6% between their first and last recorded measurements in the BodyMeasurements table. Only list those users who have a diet log in 2018.
 

SELECT
    U.UserID,
    U.FirstName,
    U.LastName,
    (Subq.LastWeight - Subq.FirstWeight) / Subq.FirstWeight,
    U.Gender
FROM
    Members U
INNER JOIN (
    SELECT
        BM.UserID,
        MAX(CASE WHEN BM.MeasurementDate = Subq.LastMeasurementDate THEN BM.Weight END) AS LastWeight,
        MIN(CASE WHEN BM.MeasurementDate = Subq.FirstMeasurementDate THEN BM.Weight END) AS FirstWeight
    FROM
        BodyMeasurements BM
    JOIN (
        SELECT
            BM.UserID,
            MAX(BM.MeasurementDate) AS LastMeasurementDate,
            MIN(BM.MeasurementDate) AS FirstMeasurementDate
        FROM
            BodyMeasurements BM
        GROUP BY
            BM.UserID
    ) Subq
    ON BM.UserID = Subq.UserID
    GROUP BY
        BM.UserID, Subq.LastMeasurementDate, Subq.FirstMeasurementDate
) Subq
ON U.UserID = Subq.UserID
WHERE
    U.USERID < 2000
    AND (Subq.LastWeight - Subq.FirstWeight) / Subq.FirstWeight > 0.06
    AND EXISTS (
        SELECT 1
        FROM DietLog D
        WHERE U.UserID = D.UserID
        AND EXTRACT(YEAR FROM D.MealDate) = 2018 -- Check if the diet log is in 2018
    );


-- Aggregate the userid, firstname, lastname, most recent heartrate, and most recent cholestrol of all males between ages 25 to 35, with a user id less than 1000, who have any exercise activity registered in the year 2017.

WITH RecentHealthRecords AS (
    SELECT
        hr.UserID,
        hr.HeartRate,
        hr.CholesterolLevel
    FROM
        HealthRecords hr
    WHERE
        (hr.UserID, hr.RecordDate) IN (
            SELECT UserID, MAX(RecordDate)
            FROM HealthRecords
            GROUP BY UserID
        )
)
SELECT
    u.UserID,
    u.FirstName,
    u.LastName,
    rhr.HeartRate,
    rhr.CholesterolLevel
FROM
    Members u
JOIN
    RecentHealthRecords rhr ON u.UserID = rhr.UserID
WHERE
    u.USERID < 100
    AND u.Gender = 'M'
    AND TRUNC(MONTHS_BETWEEN(SYSDATE, u.BirthDate) / 12) BETWEEN 25 AND 35
    AND u.UserID IN (
        SELECT UserID
        FROM ExerciseActivities
        WHERE EXTRACT(YEAR FROM ActivityDate) = 2017
        GROUP BY UserID
        HAVING COUNT(*) > 0
    )
ORDER BY u.UserID;


-- Find the total calories burned by users born between 1980 and 1990 in the ExerciseActivities table for each year between 2015 and 2020. Users should have bodyfat % under 25. UserID under 1000. Output should contain userid, name, age, gender, body fat %, and total calories burned.


WITH LatestBodyFat AS (
    SELECT
        BM.UserID,
        MAX(BM.MeasurementDate) AS LatestMeasurementDate
    FROM
        BodyMeasurements BM
    GROUP BY
        BM.UserID
)
 
SELECT
    M.UserID,
    M.FirstName || ' ' || M.LastName AS Name,
    EXTRACT(YEAR FROM EA.ActivityDate) AS Year,
    M.Gender,
    BM.BodyFatPercentage,
    SUM(EA.CaloriesBurned) AS TotalCaloriesBurned
FROM
    Members M
JOIN
    ExerciseActivities EA ON M.UserID = EA.UserID
JOIN
    LatestBodyFat LBF ON M.UserID = LBF.UserID
JOIN
    BodyMeasurements BM ON BM.UserID = LBF.UserID AND BM.MeasurementDate = LBF.LatestMeasurementDate
WHERE
    M.USERID < 1000
    AND M.BirthDate BETWEEN TO_DATE('1980-01-01', 'YYYY-MM-DD') AND TO_DATE('1990-12-31', 'YYYY-MM-DD')
    AND EXTRACT(YEAR FROM EA.ActivityDate) BETWEEN 2015 AND 2020
    AND BM.BodyFatPercentage < 25
GROUP BY
    M.UserID, M.FirstName, M.LastName, EXTRACT(YEAR FROM EA.ActivityDate), M.Gender, BM.BodyFatPercentage
ORDER BY
    M.UserID, Year;