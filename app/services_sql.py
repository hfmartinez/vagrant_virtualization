import mysql.connector
from models import Student
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Database connection configuration
config = {
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "host": os.getenv("DB_HOST"),
    "database": os.getenv("DB_DATABASE"),
}


def create_student(student: Student):
    # Create a new student in the database
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()
    cursor.execute(
        "INSERT INTO students (name, major, age, email, year_of_entry) VALUES (%s, %s, %s, %s, %s)",
        (
            student.name,
            student.major,
            student.age,
            student.email,
            student.year_of_entry,
        ),
    )
    connection.commit()
    student.id = cursor.lastrowid
    cursor.close()
    connection.close()
    return student


def read_students():
    # Retrieve all students from the database
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM students")
    students = cursor.fetchall()
    cursor.close()
    connection.close()
    return students


def read_student(student_id: int):
    # Retrieve a student by ID
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM students WHERE id = %s", (student_id,))
    student = cursor.fetchone()
    cursor.close()
    connection.close()
    return student


def update_student(student_id: int, student: Student):
    # Update a student's information
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()
    cursor.execute(
        "UPDATE students SET name = %s, major = %s, age = %s, email = %s, year_of_entry = %s WHERE id = %s",
        (
            student.name,
            student.major,
            student.age,
            student.email,
            student.year_of_entry,
            student_id,
        ),
    )
    connection.commit()
    cursor.close()
    connection.close()
    return cursor.rowcount


def delete_student(student_id: int):
    # Delete a student by ID
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()
    cursor.execute("DELETE FROM students WHERE id = %s", (student_id,))
    connection.commit()
    cursor.close()
    connection.close()
    return cursor.rowcount
