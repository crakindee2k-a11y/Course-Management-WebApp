# Course Management System

A web-based course management platform built with Java Servlets, JSP, and MySQL. Supports role-based access for students, teachers, and administrators.

## Tech Stack

- **Backend:** Java 11, Servlets, JSP
- **Frontend:** Bootstrap 5.3, HTML5, CSS3, JavaScript
- **Database:** MySQL 8.0
- **Build:** Maven 3.6+
- **Security:** BCrypt password hashing, session-based authentication

## Features

- **Admin:** Create courses, assign teachers, manage users
- **Teacher:** View assigned courses and enrolled students
- **Student:** Browse and register for courses, view enrollment history
- Auto-initialized database with sample data

## Quick Start (Local)

### Prerequisites
- Java 11+
- MySQL 8.0+
- Maven 3.6+
- Tomcat 9.0+

### Setup

```bash
# Clone and build
git clone https://github.com/crakindee2k-a11y/Course-Management-WebApp.git
cd Course-Management-WebApp
mvn clean package

# Deploy WAR to Tomcat
cp target/course-management-system-1.0.0.war $TOMCAT_HOME/webapps/

# Start Tomcat
$TOMCAT_HOME/bin/catalina.sh run
```

Database tables and sample data are created automatically on first run.

## Deploy to Railway (Free)

1. Fork/push this repo to GitHub
2. Create a [Railway](https://railway.app) project from the repo
3. Add a MySQL service in the same project
4. Set environment variable `DATABASE_URL` to the Railway MySQL connection string
5. Redeploy

The app auto-detects Railway's MySQL credentials and initializes the database on startup.

## Live Demo

- Deployed link: https://deens-course-management-webapp-production.up.railway.app/

## Default Credentials

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | password123 |
| Teacher | teacher1 | password123 |
| Student | student1 | password123 |

## License

MIT
