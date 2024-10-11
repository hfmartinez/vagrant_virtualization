CREATE DATABASE IF NOT EXISTS universidad;

USE universidad;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    major VARCHAR(100) NOT NULL,
    age INT,
    email VARCHAR(100),
    year_of_entry INT
);

INSERT INTO
    students (name, major, age, email, year_of_entry)
VALUES
    (
        'Juan Pérez',
        'Ingeniería en Sistemas',
        20,
        'juan.perez@example.com',
        2021
    ),
    (
        'Ana Gómez',
        'Arquitectura',
        22,
        'ana.gomez@example.com',
        2020
    ),
    (
        'Luis Fernández',
        'Medicina',
        21,
        'luis.fernandez@example.com',
        2021
    ),
    (
        'Marta Sánchez',
        'Derecho',
        23,
        'marta.sanchez@example.com',
        2019
    ),
    (
        'Carlos Ruiz',
        'Ingeniería Civil',
        24,
        'carlos.ruiz@example.com',
        2018
    ),
    (
        'Laura Torres',
        'Psicología',
        22,
        'laura.torres@example.com',
        2020
    ),
    (
        'Javier López',
        'Ciencias de la Computación',
        19,
        'javier.lopez@example.com',
        2022
    ),
    (
        'Sofía Martínez',
        'Biología',
        23,
        'sofia.martinez@example.com',
        2019
    ),
    (
        'Diego Morales',
        'Economía',
        21,
        'diego.morales@example.com',
        2021
    ),
    (
        'Patricia Jiménez',
        'Comunicación',
        22,
        'patricia.jimenez@example.com',
        2020
    );