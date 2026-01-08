# Course Management System
### CSE-446 Web Engineering Lab 3: Servlet Project

## 📋 Project Overview

This is a comprehensive **Course Management System** developed entirely using **Servlet and JSP** technologies with **Bootstrap** for the frontend and **MySQL** for the backend database. The system simulates the functionalities of an online course management platform with three distinct user roles.

## 🎯 Project Requirements Fulfillment

### ✅ Requirement 1 (R-1): User Types
- **Student**: Can register for courses and view enrolled courses
- **Teacher**: Can view assigned courses and enrolled students  
- **Admin**: Can add courses, assign teachers, and manage the system

### ✅ Requirement 2 (R-2): Authentication
- Secure username and password authentication using BCrypt hashing
- Session management for user login/logout
- Role-based access control with authentication filters

### ✅ Requirement 3 (R-3): Admin Functionality
- Add new courses to the system
- Assign teachers to specific courses
- View system statistics and manage all courses

### ✅ Requirement 4 (R-4): Student Functionality  
- Register for available courses
- View all registered courses
- Dashboard with enrollment information

### ✅ Requirement 5 (R-5): Teacher Functionality
- View assigned courses
- View list of enrolled students for each course
- Course-specific student management

## 🏗️ Architecture

### Technology Stack
- **Backend**: Java Servlets, JSP
- **Frontend**: HTML5, CSS3, Bootstrap 5.3.0, JavaScript
- **Database**: MySQL 8.0
- **Build Tool**: Maven
- **Authentication**: BCrypt password hashing
- **Session Management**: HTTP Sessions

### Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/coursemanagement/
│   │       ├── dao/           # Data Access Objects
│   │       │   ├── UserDAO.java
│   │       │   ├── CourseDAO.java
│   │       │   └── EnrollmentDAO.java
│   │       ├── model/         # Entity Models
│   │       │   ├── User.java
│   │       │   ├── Course.java
│   │       │   └── Enrollment.java
│   │       ├── servlet/       # Servlet Controllers
│   │       │   ├── LoginServlet.java
│   │       │   ├── LogoutServlet.java
│   │       │   ├── AuthenticationFilter.java
│   │       │   ├── AdminDashboardServlet.java
│   │       │   ├── CourseManagementServlet.java
│   │       │   ├── StudentDashboardServlet.java
│   │       │   ├── TeacherDashboardServlet.java
│   │       │   └── [Additional servlets...]
│   │       └── util/          # Utility Classes
│   │           ├── DatabaseConnection.java
│   │           └── PasswordUtil.java
│   ├── resources/
│   └── webapp/
│       ├── WEB-INF/
│       │   └── web.xml        # Servlet configuration
│       ├── admin/             # Admin JSP pages
│       ├── student/           # Student JSP pages
│       ├── teacher/           # Teacher JSP pages
│       ├── css/
│       │   └── style.css      # Custom styles
│       └── login.jsp          # Login page
```

## 🗄️ Database Schema

### Tables

#### Users Table
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- BCrypt hashed
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    user_type ENUM('STUDENT', 'TEACHER', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### Courses Table
```sql
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT DEFAULT 3,
    teacher_id INT,
    max_students INT DEFAULT 50,
    enrolled_students INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE SET NULL
);
```

#### Enrollments Table
```sql
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    status ENUM('ENROLLED', 'DROPPED', 'COMPLETED', 'PENDING') DEFAULT 'ENROLLED',
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);
```

## 🔄 Easy Restart (After Setup)

**Quick restart after making changes:**
```bash
./restart_app.sh     # Full restart with status checks
./quick_restart.sh   # Minimal restart
./quick_shutdown.sh  # Fast shutdown only (requires sudo)
```

## 🛑 Safe Shutdown

**Safely shutdown all services:**
```bash
./shutdown.sh                    # Graceful Tomcat shutdown
./shutdown.sh --with-mysql       # Shutdown both Tomcat and MySQL
./shutdown.sh --force            # Force shutdown all processes
./shutdown.sh --help             # Show help and options
```

See **[RESTART_COMMANDS.md](RESTART_COMMANDS.md)** for all restart options.

## 🚀 Setup and Installation

### Prerequisites
- Java 11 or higher
- MySQL 8.0 or higher
- Apache Tomcat 9.0 or higher
- Maven 3.6 or higher

### Installation Steps

1. **Clone the project:**
   ```bash
   git clone [repository-url]
   cd course-management-system
   ```

2. **Setup MySQL Database:**
   ```sql
   CREATE DATABASE course_management_db;
   ```

3. **Configure Database Connection:**
   Update `src/main/webapp/WEB-INF/web.xml` with your database credentials:
   ```xml
   <context-param>
       <param-name>DB_URL</param-name>
       <param-value>jdbc:mysql://localhost:3306/course_management_db</param-value>
   </context-param>
   <context-param>
       <param-name>DB_USERNAME</param-name>
       <param-value>your_username</param-value>
   </context-param>
   <context-param>
       <param-name>DB_PASSWORD</param-name>
       <param-value>your_password</param-value>
   </context-param>
   ```

4. **Build the project:**
   ```bash
   mvn clean compile
   ```

5. **Deploy to Tomcat:**
   ```bash
   mvn package
   # Copy target/course-management-system.war to Tomcat webapps/
   ```

6. **Start Tomcat and access the application:**
   ```
   http://localhost:8080/course-management-system
   ```

## ☁️ Railway Deployment (Free Tier)

Railway can build the Dockerfile in this repo and host both the web app (Tomcat) and a managed MySQL database.

### 1. Prepare the repo
- Push the latest code to GitHub (already done if you see this README online).
- The provided `Dockerfile` performs a Maven build stage and deploys the WAR as `ROOT.war` inside Tomcat, so no extra steps are required.

### 2. Create Railway services
1. Log in to [Railway](https://railway.app) → **New Project** → **Deploy from Repo** → select this GitHub repo.
2. Keep the default “Deploy Dockerfile” option.
3. Inside the same project, click **Add Service → MySQL** to provision a managed MySQL instance (always-free while within quota).

### 3. Configure environment variables
Railway injects database credentials as env vars. The app now auto-detects the following keys (first one found wins):

| Purpose | Preferred Vars |
|---------|----------------|
| Connection URL | `DATABASE_URL`, `JDBC_DATABASE_URL`, `DB_URL` |
| Host/DB fallback | `MYSQLHOST` + `MYSQLDATABASE` (+ optional `MYSQLPORT`) |
| Username | `JDBC_DATABASE_USERNAME`, `DB_USERNAME`, `MYSQLUSER` |
| Password | `JDBC_DATABASE_PASSWORD`, `DB_PASSWORD`, `MYSQLPASSWORD` |

For Railway specifically, you can simply set **`DATABASE_URL`** to the MySQL connection string that Railway shows (format: `mysql://USER:PASSWORD@HOST:PORT/DATABASE?ssl-mode=REQUIRED`). The app will parse it automatically.

### 4. Redeploy
- After env vars are set, hit **Deploy** (or trigger a redeploy) for the web service.
- The container exposes port `8080`; Railway maps it to a public HTTPS URL automatically.

### 5. Database initialization
- `DatabaseConnection.initializeDatabase()` creates tables and inserts sample data on first run, so you don’t need manual SQL imports.
- You can optionally connect to the Railway MySQL instance using their provided credentials to inspect/modify data.

### Auto-Initialization
The system automatically:
- Creates database tables on first run
- Inserts sample data including default users
- Sets up proper indexes and relationships

## 👥 Default Users

The system comes with pre-configured users for testing:

| Role | Username | Password | Full Name |
|------|----------|----------|-----------|
| Admin | admin | password123 | System Administrator |
| Teacher | teacher1 | password123 | Dr. John Smith |
| Teacher | teacher2 | password123 | Prof. Sarah Johnson |
| Student | student1 | password123 | Alice Cooper |
| Student | student2 | password123 | Bob Wilson |
| Student | student3 | password123 | Carol Davis |

## 🎨 Design Features

### Bootstrap Integration
- **Responsive Design**: Mobile-first approach with Bootstrap 5.3.0
- **Modern UI Components**: Cards, modals, buttons, forms
- **Icons**: Bootstrap Icons for consistent iconography
- **Color Scheme**: Professional gradient-based design

### User Experience
- **Intuitive Navigation**: Role-based navigation menus
- **Dashboard Analytics**: Real-time statistics and charts
- **Feedback System**: Success/error messages for all operations
- **Form Validation**: Client-side and server-side validation

## 🔒 Security Features

- **Password Hashing**: BCrypt with salt for secure password storage
- **Session Management**: Proper session handling with timeout
- **Access Control**: Role-based authentication filter
- **SQL Injection Prevention**: Prepared statements throughout
- **Input Validation**: Comprehensive input sanitization

## 📊 System Features

### Admin Dashboard
- System statistics overview
- User management capabilities  
- Course creation and management
- Teacher assignment to courses
- Real-time enrollment tracking

### Student Portal
- Available courses browsing
- Course registration functionality
- Personal course history
- Enrollment status tracking

### Teacher Interface
- Assigned courses overview
- Student roster for each course
- Course-specific analytics
- Enrollment management tools

## 📝 Code Documentation

All code follows professional documentation standards:
- **JavaDoc**: Comprehensive class and method documentation
- **Inline Comments**: Clear explanation of complex logic
- **Naming Conventions**: Descriptive variable and method names
- **Error Handling**: Proper exception handling and logging

## 🧪 Testing

The system includes:
- Sample data for immediate testing
- Default user accounts for each role
- Comprehensive error handling
- Database transaction management

## 🚀 Future Enhancements

Potential extensions for this system:
- Email notifications for enrollments
- Grade management system  
- Course material upload/download
- Discussion forums per course
- Advanced reporting and analytics
- Mobile application support

## 👨‍💻 Development Team

**CSE-446 Web Engineering Lab Group**
- Comprehensive system architecture
- Database design and optimization
- Servlet and JSP implementation
- Bootstrap frontend integration
- Security implementation

---

## 📚 **Comprehensive Documentation for Teachers & Reviewers**

This project includes extensive documentation designed for rigorous academic evaluation:

### **📋 Core Documentation Files:**

1. **[APPLICATION_FLOW_GUIDE.md](APPLICATION_FLOW_GUIDE.md)** - Complete application flow from start to finish
   - Beginner-friendly explanations of how everything works
   - Step-by-step breakdowns of user authentication, course enrollment, etc.
   - Database operations explained in detail
   - Security features and implementation details

2. **[TEACHER_PRESENTATION_GUIDE.md](TEACHER_PRESENTATION_GUIDE.md)** - Perfect preparation for teacher questioning
   - Common questions and detailed answers
   - Technical concepts explained clearly
   - Demonstration flow and tips
   - Architecture and design decision explanations

### **💻 Comprehensive Code Documentation:**

Every single file in this project has been enhanced with **detailed, beginner-friendly comments** explaining:

- **What each class does** and why it's needed
- **How each method works** step-by-step
- **Security features** and why they're important
- **Database operations** and SQL query explanations
- **Design patterns** and architectural decisions
- **Error handling** and edge cases

### **🔍 Key Files with Enhanced Comments:**

- **Model Classes** (`src/main/java/com/coursemanagement/model/`):
  - `User.java` - Complete explanation of user data structure and authentication
  - `Course.java` - Detailed course management and enrollment logic
  - `Enrollment.java` - Student-course relationship management

- **DAO Classes** (`src/main/java/com/coursemanagement/dao/`):
  - `UserDAO.java` - Database authentication and user management operations
  - `CourseDAO.java` - Course creation, assignment, and retrieval operations
  - `EnrollmentDAO.java` - Student enrollment and transaction management

- **Servlet Classes** (`src/main/java/com/coursemanagement/servlet/`):
  - All servlets have detailed comments explaining request handling
  - Security filter implementations documented
  - Session management and role-based access control explained

- **Utility Classes** (`src/main/java/com/coursemanagement/util/`):
  - `DatabaseConnection.java` - Connection pooling and database setup
  - `PasswordUtil.java` - BCrypt hashing and security implementation
  - `ConnectionPool.java` - Advanced connection management

### **🎯 Perfect for Academic Evaluation:**

✅ **Comprehensive Comments**: Every method, class, and important code block explained in detail

✅ **Beginner-Friendly Language**: Complex concepts broken down into simple explanations

✅ **Academic Focus**: Comments specifically designed for teacher questioning and evaluation

✅ **Security Emphasis**: Detailed explanations of all security measures implemented

✅ **Architecture Documentation**: Clear explanations of design patterns and decisions

✅ **Database Documentation**: Complete SQL operations and transaction management explained

✅ **Flow Diagrams**: Step-by-step process explanations for all major operations

### **🎓 How to Use This Documentation:**

1. **For Demo Preparation**: Read `TEACHER_PRESENTATION_GUIDE.md` first
2. **For Technical Understanding**: Study `APPLICATION_FLOW_GUIDE.md` 
3. **For Code Review**: Every Java file has comprehensive inline comments
4. **For Questions**: Use the guides to prepare answers for rigorous questioning

---

## 📄 References

- [Servlet MySQL Integration](https://www.tutorialspoint.com/servlets/servlets-database-access.htm)
- [Servlet MongoDB Integration](https://www.journaldev.com/4011/mongodb-java-servlet-web-application-example-tutorial)
- [JSP & Bootstrap Integration](http://javabyprakash.blogspot.com/2015/01/simple-login-demo-using-jsp-servlet-and.html)
- [Servlet URL Mapping](https://javapapers.com/servlet/what-is-servlet-mapping/)
- [Code Documentation Best Practices](https://medium.com/@andrewgoldis/how-to-document-source-code-responsibly-2b2f303aa525)
- [Java DAO Pattern](https://www.oracle.com/java/technologies/data-access-object.html)
- [BCrypt Password Hashing](https://github.com/patrickfav/bcrypt)
- [Java Security Best Practices](https://www.oracle.com/java/technologies/javase/seccodeguide.html)

---
