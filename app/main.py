from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from models import Student
from services_sql import (
    create_student,
    read_student,
    read_students,
    delete_student,
    update_student,
)

app = FastAPI()


@app.get("/")
async def redirect_to_docs():
    return RedirectResponse(url="/docs")


@app.post("/students/", response_model=Student)
def create_student_api(student: Student):
    # Create a new student in the database
    return create_student(student)


@app.get("/students/", response_model=list[Student])
def read_students_api():
    # Retrieve all students from the database
    return read_students()


@app.get("/students/{student_id}", response_model=Student)
def read_student_api(student_id: int):
    # Retrieve a student by ID
    student = read_student(student_id)
    if student is None:
        raise HTTPException(status_code=404, detail="Student not found")
    return student


@app.put("/students/{student_id}", response_model=Student)
def update_student_api(student_id: int, student: Student):
    # Update a student's information
    if update_student(student_id, student) == 0:
        raise HTTPException(status_code=404, detail="Student not found")
    student.id = student_id
    return student


@app.delete("/students/{student_id}")
def delete_student_api(student_id: int):
    # Delete a student by ID
    if delete_student(student_id) == 0:
        raise HTTPException(status_code=404, detail="Student not found")
    return {"detail": "Student deleted"}
