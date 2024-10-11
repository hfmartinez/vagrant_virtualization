from fastapi import FastAPI, HTTPException
from models import Student
import services_sql as sql

app = FastAPI()


@app.post("/students/", response_model=Student)
def create_student(student: Student):
    # Create a new student in the database
    return sql.create_student(student)


@app.get("/students/", response_model=list[Student])
def read_students():
    # Retrieve all students from the database
    return sql.read_students()


@app.get("/students/{student_id}", response_model=Student)
def read_student(student_id: int):
    # Retrieve a student by ID
    student = sql.read_student(student_id)
    if student is None:
        raise HTTPException(status_code=404, detail="Student not found")
    return student


@app.put("/students/{student_id}", response_model=Student)
def update_student(student_id: int, student: Student):
    # Update a student's information
    if sql.update_student(student_id, student) == 0:
        raise HTTPException(status_code=404, detail="Student not found")
    student.id = student_id
    return student


@app.delete("/students/{student_id}")
def delete_student(student_id: int):
    # Delete a student by ID
    if sql.delete_student(student_id) == 0:
        raise HTTPException(status_code=404, detail="Student not found")
    return {"detail": "Student deleted"}
