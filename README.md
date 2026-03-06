# Ocean View Resort Reservation System

## Project Overview
The Ocean View Resort Reservation System is a web-based application developed to manage guest reservations, payments, billing, and room availability at Ocean View Resort. The system allows resort staff to efficiently manage reservations and operational tasks through a centralized interface.

This project was developed using Java web technologies and follows an MVC (Model–View–Controller) architecture to maintain a clear separation between presentation, business logic, and data access layers.

---

## Key Features

### Authentication
- Staff login system with role-based access
- Secure session management
- Admin and receptionist access levels

### Reservation Management
- Create new guest reservations
- View and search reservation records
- Cancel reservations when applicable

### Payment and Billing
- Record guest payments
- Generate printable bills
- Track pending payments

### Room Management
- Update room status (Available / Maintenance)
- Prevent reservations for unavailable rooms

### User Management
- Admin can create receptionist accounts
- Role-based system access control

### Dashboard Overview
- View active reservations
- Monitor pending payments
- Track total revenue

### Automated Testing
- JUnit test classes implemented
- Automated test execution using Maven
- GitHub Actions CI workflow validates builds

---

## Technologies Used

- **Java**
- **JSP (Java Server Pages)**
- **Java Servlets**
- **Maven**
- **MySQL**
- **JDBC**
- **Apache Tomcat**
- **Git & GitHub**
- **GitHub Actions (CI/CD)**

---

## System Architecture

The system follows the **MVC architecture pattern**:

Controller Layer
Handles HTTP requests and responses

Service Layer
Contains business logic and validation

DAO Layer
Handles database interactions

Model Layer
Represents system entities


This architecture improves maintainability, scalability, and separation of concerns.

---

## Database

The system uses **MySQL** as the database backend.

Database components include:

- Tables for users, reservations, rooms, and payments
- Stored procedures for reservation creation
- Triggers and functions for data validation and processing

---

## Running the Application

### Prerequisites

- Java JDK 21
- Apache Tomcat
- MySQL
- Maven

### Steps

1. Clone the repository
git clone https://github.com/AvinashFdo/oceanview-resort-webapp.git

2. Configure MySQL database
Create the database and import the schema.

3. Configure database connection
Update database credentials in the configuration file.

4. Build the project
  
5. Deploy to Apache Tomcat
Deploy the generated WAR file to Tomcat and run the server.

6. Access the application
http://localhost:8080/oceanview-resort-webapp


---

## Author

Developed as part of the **CIS6003 Software Development Coursework**.

Student:  
Avinash Fernando

Institution:  
ICBT Campus Sri Lanka

---

## License

This project is developed for academic purposes.
