from faker import Faker
import random
import cx_Oracle
from datetime import datetime
 
 
# Initialize the Faker object
fake = Faker()


connection = cx_Oracle.connect("c##tanmay/*******@localhost:1521")
cursor = connection.cursor()

def random_birth_date():
    return fake.date_of_birth(tzinfo=None, minimum_age=20, maximum_age=80)

cursor.execute("CREATE SEQUENCE measurement_seq")
cursor.execute("CREATE SEQUENCE record_seq")
cursor.execute("CREATE SEQUENCE log_seq")
cursor.execute("CREATE SEQUENCE activity_seq")
cursor.execute("CREATE SEQUENCE useridseq")


for i in range(150000):
    # Generate user data
    gender = random.choice(['M', 'F'])
    first_name = fake.first_name_male() if gender=="M" else fake.first_name_female() # fake names based on gender
    last_name = fake.last_name()
    birth_date = fake.date_of_birth(minimum_age=18, maximum_age=80)
    email = first_name + random.choice(['_', '.', '']) + last_name + str(random.randint(1,9999)) + random.choice(['@gmail.com', '@yahoo.com', '@hotmail.com']) #email based on name for 3 most popular domains
    height = random.uniform(150, 200) if gender=="M" else random.uniform(140, 180) #height in cm based on average male/female height
    weight = random.uniform(50, 120) if gender=="M" else random.uniform(40, 90) #weight in kg
    fat_pecentage = random.uniform(5, 35)
    cursor.execute("SELECT useridseq.NEXTVAL FROM DUAL")
    user_id = cursor.fetchone()[0]
 
    # Insert user data into MEMBERS table
    cursor.execute("""
        INSERT INTO MEMBERS (UserID, FirstName, LastName, BirthDate, Email, Gender)
        VALUES (:user_id, :first_name, :last_name, :birth_date, :email, :gender)
    """, first_name=first_name, last_name=last_name, birth_date=birth_date, email=email, gender=gender, user_id=user_id)
    
    # Generate yearly entries for various tables
    for year in range(2015, 2020):
        # Body Measurements
        if random.random() < 0.8:
            prev_height = height
            prev_weight = weight
            weight = prev_weight + random.uniform(-0.03 * prev_weight, 0.03 * prev_weight) # not a massive difference between measurements
            prev_fat_pecentage = fat_pecentage
            fat_pecentage = prev_fat_pecentage + random.uniform(-0.03 * prev_fat_pecentage, 0.03 * prev_fat_pecentage) # not a massive difference between measurements
            measurement_date = fake.date_between_dates(date_start=datetime(year,1,1), date_end=datetime(year,12,31)) #fake date for that year
            # Generate sequence-based IDs
            cursor.execute("SELECT measurement_seq.NEXTVAL FROM DUAL")
            measurement_id, = cursor.fetchone() #fetch id from sequence
            cursor.execute("""
                INSERT INTO BodyMeasurements (MeasurementID, UserID, MeasurementDate, Height, Weight, BodyFatPercentage)
                VALUES (:measurement_id, :user_id, :measurement_date, :height, :weight, :fat_pecentage)
            """, measurement_id=measurement_id, user_id=user_id, measurement_date=measurement_date, height=height, weight=weight, fat_pecentage=fat_pecentage)
 
        
        # Exercise Activities
        if random.random() < 0.7:
            activity_name = fake.word()
            activity_date = fake.date_between_dates(date_start=datetime(year,1,1), date_end=datetime(year,12,31))
            duration_minutes = random.randint(10, 120) #normal activity duration
            calories_burned = random.uniform(50, 500) #normal amount of cals burned

            # Generate sequence-based IDs
            cursor.execute("SELECT activity_seq.NEXTVAL FROM DUAL")
            activity_id, = cursor.fetchone()
            cursor.execute("""
                INSERT INTO ExerciseActivities (ActivityID, UserID, ActivityName, ActivityDate, DurationInMinutes, CaloriesBurned)
                VALUES (:activity_id, :user_id, :activity_name, :activity_date, :duration_minutes, :calories_burned)
            """, activity_id=activity_id, user_id=user_id, activity_name=activity_name, activity_date=activity_date, duration_minutes=duration_minutes, calories_burned=calories_burned)
 
 
        # Diet Log
        if random.random() < 0.7:
            meal_date = fake.date_between_dates(date_start=datetime(year,1,1), date_end=datetime(year,12,31))
            meal_description = fake.sentence()
            calories_consumed = random.uniform(200, 2000) #normal intake per meal
            # Generate sequence-based IDs
            cursor.execute("SELECT log_seq.NEXTVAL FROM DUAL")
            log_id, = cursor.fetchone()
            cursor.execute("""
                INSERT INTO DietLog (LogID, UserID, MealDate, MealDescription, CaloriesConsumed)
                VALUES (:log_id, :user_id, :meal_date, :meal_description, :calories_consumed)
            """, log_id=log_id, user_id=user_id, meal_date=meal_date, meal_description=meal_description, calories_consumed=calories_consumed)
 
        # Health Records
        if random.random() < 0.5:
            record_date = fake.date_between_dates(date_start=datetime(year,1,1), date_end=datetime(year,12,31))
            blood_pressure = fake.random_element(elements=("120/80", "140/90", "160/100"))  #Could fake it better, but did not at the moment
            cholesterol_level = random.uniform(120, 240)
            heart_rate = random.randint(60, 100)
            notes = fake.text()
            # Generate sequence-based IDs
            cursor.execute("SELECT record_seq.NEXTVAL FROM DUAL")
            record_id, = cursor.fetchone()
            cursor.execute("""
                INSERT INTO HealthRecords (RecordID, UserID, RecordDate, BloodPressure, CholesterolLevel, HeartRate, Notes)
                VALUES (:record_id, :user_id, :record_date, :blood_pressure, :cholesterol_level, :heart_rate, :notes)
            """, record_id=record_id, user_id=user_id, record_date=record_date, blood_pressure=blood_pressure, cholesterol_level=cholesterol_level, heart_rate=heart_rate, notes=notes)
    if user_id % 250 == 0:
        print(user_id)


# Commit changes and close the connection
connection.commit()
cursor.close()
connection.close()
