# Student Management API

## Overview

This project provides a RESTful API for managing student records using FastAPI and MySQL. All configurations and provisioning are automated with Ansible and Vagrant. The API supports CRUD operations to create, read, update, and delete student information.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Vagrant 2.4.1:** [Download Vagrant](https://www.vagrantup.com/)
- **VirtualBox:** [Download VirtualBox](https://www.virtualbox.org/)
- **Ansible:** [Download Ansible](https://www.ansible.com/)

## Steps to Run

> [!IMPORTANT]
> Ensure that the Vagrant machine has access to the internet for package installations.

1. **Clone the Repository**
   ```bash
   git clone https://github.com/hfmartinez/vagrant_virtualization.git
   
   cd vagrant_virtualization/app
   ```
2. **Update Database Credentials**

- Create a file named `.env` in the `app` directory with the following content:
  ```plaintext
  DB_USER=your_mysql_username
  DB_PASSWORD=your_mysql_password
  DB_HOST=localhost
  DB_DATABASE=universidad
  ```
- Replace `your_mysql_username` and `your_mysql_password` with your desired MySQL credentials. The root password will also need to be set in the Ansible playbook.

3. **Run Vagrant**

```bash
   vagrant up
```

4.  **Access the API**

- Once the setup is complete, the API will be accessible at `http://localhost:8000`

5.  **Stopping the Virtual Machine**

```bash
vagrant halt
```

6. **Destroying the Virtual Machine**

```bash
vagrant destroy
```

## API Endpoints

- `POST /students/`: Create a new student
- `GET /students/`: Retrieve all students
- `GET /students/{student_id}`: Retrieve a student by ID
- `PUT /students/{student_id}`: Update a student's information
- `DELETE /students/{student_id}`: Delete a student by ID

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
