from pydantic import BaseModel


class Student(BaseModel):
    id: int
    name: str
    major: str
    age: int
    email: str
    year_of_entry: int
