# 🎓 VIVA PREPARATION GUIDE - Lab 3: Servlet Project

## CSE-446 Web Engineering Lab - Course Management System

This document maps **every lab requirement** to the **exact code locations** in your project. Use this to answer teacher questions confidently.

---

# 📋 LAB REQUIREMENTS OVERVIEW

| Requirement | Description | Status |
|-------------|-------------|--------|
| **R-1** | Three user types: Student, Teacher, Admin | ✅ Implemented |
| **R-2** | Authentication using username/password | ✅ Implemented |
| **R-3** | Admin can add courses & assign teachers | ✅ Implemented |
| **R-4** | Student can register for courses & view registered courses | ✅ Implemented |
| **R-5** | Teacher can view assigned courses & see enrolled students | ✅ Implemented |
| **Tech** | Servlet + JSP architecture | ✅ Implemented |
| **Tech** | Bootstrap/CSS for UI | ✅ Implemented |
| **Tech** | MySQL database integration | ✅ Implemented |

---

# 🔑 REQUIREMENT R-1: Three User Types (Student, Teacher, Admin)

## Where It's Defined

### 1. User Model - The UserType Enum
**File:** `src/main/java/com/coursemanagement/model/User.java`
**Lines:** 60-64

```java
public enum UserType {
    STUDENT,  // Students who take courses
    TEACHER,  // Teachers who teach courses  
    ADMIN     // Administrators who manage the system
}
```

**How to explain:**
> "We use a Java enum to define exactly three user types. An enum is better than strings because it prevents typos and provides compile-time checking. If someone tries to create a user with type 'STUDNT', it won't compile."

### 2. User Field That Stores The Type
**File:** `src/main/java/com/coursemanagement/model/User.java`
**Lines:** 163

```java
private UserType userType;
```

### 3. Helper Methods to Check User Type
**File:** `src/main/java/com/coursemanagement/model/User.java`
**Lines:** 693-755

```java
public boolean isAdmin() {
    return this.userType == UserType.ADMIN;
}

public boolean isTeacher() {
    return this.userType == UserType.TEACHER;
}

public boolean isStudent() {
    return this.userType == UserType.STUDENT;
}
```

**How to explain:**
> "These convenience methods make our code more readable. Instead of writing `user.getUserType() == UserType.ADMIN`, we just write `user.isAdmin()`."

### 4. Database Schema - How Users Are Stored
**File:** `src/main/java/com/coursemanagement/util/DatabaseConnection.java`

The users table is created with:
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    user_type ENUM('STUDENT', 'TEACHER', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**How to explain:**
> "The database uses MySQL's ENUM type which only allows these three specific values. This provides database-level validation - you can't insert a user with an invalid type."

### 5. Default Users Created on Startup
**File:** `src/main/java/com/coursemanagement/util/DatabaseConnection.java`

Three default users are created:
- `admin` / `password123` (ADMIN)
- `teacher1` / `password123` (TEACHER)
- `student1` / `password123` (STUDENT)

**How to explain:**
> "When the application starts, it automatically creates one user of each type so you can immediately test all functionality without manual database setup."

---

# 🔐 REQUIREMENT R-2: Authentication (Username & Password)

## The Complete Login Flow

### Step 1: User Submits Login Form
**File:** `src/main/webapp/login.jsp`

The form sends POST request to `/login` with username and password.

### Step 2: LoginServlet Receives the Request
**File:** `src/main/java/com/coursemanagement/servlet/LoginServlet.java`
**Lines:** 66-80

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Validate input
    if (username == null || username.trim().isEmpty() || 
        password == null || password.trim().isEmpty()) {
        request.setAttribute("errorMessage", "Username and password are required");
        // ... forward back to login page
    }
```

**How to explain:**
> "The servlet first validates that both fields are provided. We use `request.getParameter()` to get form data."

### Step 3: UserDAO Authenticates Against Database
**File:** `src/main/java/com/coursemanagement/dao/UserDAO.java`
**Lines:** 115-170 (approximately)

```java
public User authenticateUser(String username, String password) {
    String sql = "SELECT user_id, username, password, full_name, email, user_type, created_at, updated_at " +
                "FROM users WHERE username = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, username);  // Safe from SQL injection
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            String storedHashedPassword = rs.getString("password");
            
            // Verify password using BCrypt
            if (PasswordUtil.verifyPassword(password, storedHashedPassword)) {
                // Build and return User object
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                // ... set other fields
                return user;  // Authentication successful!
            }
        }
    }
    return null;  // Authentication failed
}
```

**How to explain:**
> "We use PreparedStatement with `?` placeholders to prevent SQL injection attacks. The password is never stored as plain text - we use BCrypt hashing. When verifying, we hash the input and compare it to the stored hash."

### Step 4: Password Hashing with BCrypt
**File:** `src/main/java/com/coursemanagement/util/PasswordUtil.java`

```java
public static String hashPassword(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
}

public static boolean verifyPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
}
```

**How to explain:**
> "BCrypt is a one-way hashing algorithm. Even if someone steals our database, they can't reverse the hash to get the original password. Each hash includes a random 'salt' making rainbow table attacks impossible."

### Step 5: Session Creation on Successful Login
**File:** `src/main/java/com/coursemanagement/servlet/LoginServlet.java`

```java
// Create session and store user
HttpSession session = request.getSession(true);
session.setAttribute("currentUser", user);
session.setAttribute("userRole", user.getUserType().name());
session.setAttribute("userId", user.getUserId());

// Redirect to appropriate dashboard
redirectToDashboard(request, response, user);
```

**How to explain:**
> "After successful authentication, we create an HTTP session and store the User object in it. This session is maintained by the browser using cookies, so subsequent requests know who the user is."

### Step 6: Role-Based Redirect
**File:** `src/main/java/com/coursemanagement/servlet/LoginServlet.java`
**Lines:** 135-155

```java
private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
    String contextPath = request != null ? request.getContextPath() : "";

    switch (user.getUserType()) {
        case ADMIN:
            response.sendRedirect(contextPath + "/admin/dashboard");
            break;
        case TEACHER:
            response.sendRedirect(contextPath + "/teacher/dashboard");
            break;
        case STUDENT:
            response.sendRedirect(contextPath + "/student/dashboard");
            break;
    }
}
```

**How to explain:**
> "Based on the user's role, we redirect them to their specific dashboard. Admins go to `/admin/dashboard`, teachers to `/teacher/dashboard`, and students to `/student/dashboard`."

### Authentication Filter - Protecting Pages
**File:** `src/main/java/com/coursemanagement/servlet/AuthenticationFilter.java`
**Lines:** 29-68

```java
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
    // Check if user is authenticated
    HttpSession session = httpRequest.getSession(false);
    User currentUser = null;
    
    if (session != null) {
        currentUser = (User) session.getAttribute("currentUser");
    }
    
    // If user is not authenticated, redirect to login
    if (currentUser == null) {
        httpResponse.sendRedirect(contextPath + "/login.jsp?redirect=" + relativePath);
        return;
    }
    
    // Check role-based access
    if (!hasAccess(currentUser, relativePath)) {
        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
        return;
    }
    
    chain.doFilter(request, response);  // Allow access
}
```

**How to explain:**
> "This filter runs BEFORE every request to protected pages. It checks if someone is logged in by looking for 'currentUser' in the session. If not logged in, redirect to login. If logged in but wrong role, show 403 Forbidden."

---

# 📚 REQUIREMENT R-3: Admin Can Add Courses & Assign Teachers

## Course Management Servlet
**File:** `src/main/java/com/coursemanagement/servlet/CourseManagementServlet.java`

### Admin Check (Authorization)
**Lines:** 44-51

```java
// Verify user is admin
HttpSession session = request.getSession(false);
User currentUser = (User) session.getAttribute("currentUser");

if (currentUser == null || !currentUser.isAdmin()) {
    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
    return;
}
```

**How to explain:**
> "Before any course operation, we verify the user is an admin. The `isAdmin()` method checks if `userType == ADMIN`. Non-admins get a 403 Forbidden error."

### Creating a New Course
**Lines:** 94-95

```java
if ("create".equals(action)) {
    handleCreateCourse(request, response);
}
```

The `handleCreateCourse` method:
1. Gets form data (course code, name, description, credits, max students)
2. Validates all fields
3. Checks if course code already exists
4. Creates Course object
5. Saves to database via CourseDAO

### Assigning Teacher to Course
**Lines:** 98-99

```java
if ("assign".equals(action)) {
    handleAssignTeacher(request, response);
}
```

**File:** `src/main/java/com/coursemanagement/dao/CourseDAO.java`

```java
public boolean assignTeacher(int courseId, int teacherId) {
    String sql = "UPDATE courses SET teacher_id = ? WHERE course_id = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, teacherId);
        stmt.setInt(2, courseId);
        
        return stmt.executeUpdate() > 0;
    }
}
```

**How to explain:**
> "To assign a teacher, we simply UPDATE the courses table, setting the teacher_id foreign key to point to the selected teacher's user_id."

### Course Model
**File:** `src/main/java/com/coursemanagement/model/Course.java`

Key fields:
```java
private int courseId;          // Primary key
private String courseCode;     // e.g., "CSE-446"
private String courseName;     // e.g., "Web Engineering"
private String description;    // Course description
private int credits;           // Credit hours
private int teacherId;         // Foreign key to users table
private int maxStudents;       // Enrollment limit
private int enrolledStudents;  // Current count
```

---

# 📝 REQUIREMENT R-4: Student Can Register & View Courses

## Student Dashboard Servlet
**File:** `src/main/java/com/coursemanagement/servlet/StudentDashboardServlet.java`

### Loading Student's Enrolled Courses (VIEW)
**Lines:** 59-76

```java
// Get student's enrolled courses
List<Enrollment> enrolledCourses = enrollmentDAO.getEnrollmentsByStudent(currentUser.getUserId());

// Get all available courses
List<Course> availableCourses = courseDAO.getAvailableCourses();

// Set attributes for JSP
request.setAttribute("enrolledCourses", enrolledCourses);
request.setAttribute("availableCourses", availableCourses);

// Forward to student dashboard JSP
request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
```

**How to explain:**
> "When a student visits their dashboard, we query two things: (1) courses they're already enrolled in via `getEnrollmentsByStudent()`, and (2) all available courses. The JSP displays both lists."

### Course Registration (REGISTER)
**Lines:** 110-142

```java
if ("register".equals(action)) {
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    
    // Check if student is already enrolled
    List<Enrollment> existingEnrollments = enrollmentDAO.getEnrollmentsByStudent(currentUser.getUserId());
    boolean alreadyEnrolled = existingEnrollments.stream()
        .anyMatch(enrollment -> enrollment.getCourseId() == courseId);
    
    if (alreadyEnrolled) {
        request.setAttribute("errorMessage", "You are already enrolled in this course.");
    } else {
        // Register for the course
        Enrollment enrollment = new Enrollment();
        enrollment.setStudentId(currentUser.getUserId());
        enrollment.setCourseId(courseId);
        
        boolean success = enrollmentDAO.createEnrollment(enrollment);
        if (success) {
            request.setAttribute("successMessage", "Successfully enrolled in the course!");
        }
    }
}
```

**How to explain:**
> "When a student clicks 'Register', we first check if they're already enrolled using Java Streams. If not, we create an Enrollment object linking the student to the course and save it to the database."

### Enrollment Model
**File:** `src/main/java/com/coursemanagement/model/Enrollment.java`

```java
private int enrollmentId;    // Primary key
private int studentId;       // Foreign key to users (student)
private int courseId;        // Foreign key to courses
private EnrollmentStatus status;  // ENROLLED, DROPPED, COMPLETED, PENDING
private Timestamp enrollmentDate;
```

**How to explain:**
> "The Enrollment model represents the many-to-many relationship between students and courses. One student can enroll in many courses, and one course can have many students."

### Database Query for Student's Enrollments
**File:** `src/main/java/com/coursemanagement/dao/EnrollmentDAO.java`

```java
public List<Enrollment> getEnrollmentsByStudent(int studentId) {
    String sql = "SELECT e.*, c.course_code, c.course_name, u.full_name as teacher_name " +
                "FROM enrollments e " +
                "JOIN courses c ON e.course_id = c.course_id " +
                "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                "WHERE e.student_id = ?";
    // ... execute query and return list
}
```

**How to explain:**
> "We use SQL JOINs to get all enrollment details in one query - the enrollment info, course details, and teacher name. This is more efficient than making multiple database calls."

---

# 👨‍🏫 REQUIREMENT R-5: Teacher Can View Courses & Students

## Teacher Dashboard Servlet
**File:** `src/main/java/com/coursemanagement/servlet/TeacherDashboardServlet.java`

### Loading Teacher's Assigned Courses
**Lines:** 58-67

```java
// Get teacher's assigned courses
List<Course> assignedCourses = courseDAO.getCoursesByTeacher(currentUser.getUserId());

// Set attributes for JSP
request.setAttribute("assignedCourses", assignedCourses);
request.setAttribute("currentUser", currentUser);

// Forward to teacher dashboard JSP
request.getRequestDispatcher("/teacher/dashboard.jsp").forward(request, response);
```

**How to explain:**
> "When a teacher logs in, we query `getCoursesByTeacher()` which finds all courses where `teacher_id` matches the current user's ID. This shows only the courses assigned to THIS teacher."

### View Students Servlet
**File:** `src/main/java/com/coursemanagement/servlet/ViewStudentsServlet.java`

### Verifying Teacher Owns the Course
**Lines:** 86-92

```java
// Verify that the teacher is assigned to this course
Course course = courseDAO.findById(courseId);
if (course == null || course.getTeacherId() != currentUser.getUserId()) {
    request.setAttribute("errorMessage", "You are not assigned to this course.");
    request.getRequestDispatcher("/error.jsp").forward(request, response);
    return;
}
```

**How to explain:**
> "Security check: we verify the teacher is actually assigned to the course they're trying to view. This prevents teachers from snooping on other teachers' courses."

### Getting Enrolled Students for a Course
**Lines:** 94-103

```java
// Get enrolled students for this course
List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByCourse(courseId);

// Set attributes for JSP
request.setAttribute("course", course);
request.setAttribute("enrollments", enrollments);

// Forward to view students JSP
request.getRequestDispatcher("/teacher/view-students.jsp").forward(request, response);
```

**How to explain:**
> "We call `getEnrollmentsByCourse()` which JOINs the enrollments table with users to get student names and details. The JSP then displays this list."

### Database Query for Course's Students
**File:** `src/main/java/com/coursemanagement/dao/EnrollmentDAO.java`

```java
public List<Enrollment> getEnrollmentsByCourse(int courseId) {
    String sql = "SELECT e.*, u.full_name as student_name, u.email as student_email " +
                "FROM enrollments e " +
                "JOIN users u ON e.student_id = u.user_id " +
                "WHERE e.course_id = ?";
    // ... execute and return
}
```

---

# 🏗️ ARCHITECTURE OVERVIEW

## MVC Pattern Explanation

```
┌──────────────────────────────────────────────────────────────────┐
│                        USER (Browser)                             │
│                             │                                     │
│                             ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    VIEW (JSP Pages)                          │ │
│  │  login.jsp, dashboard.jsp, courses.jsp, students.jsp         │ │
│  │  - Display data to user                                      │ │
│  │  - Collect user input via forms                              │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                             │                                     │
│                    HTTP Request (form submit)                     │
│                             ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                 CONTROLLER (Servlets)                        │ │
│  │  LoginServlet, CourseManagementServlet, StudentDashboard...  │ │
│  │  - Handle HTTP requests                                      │ │
│  │  - Validate input                                            │ │
│  │  - Call DAO methods                                          │ │
│  │  - Set attributes for JSP                                    │ │
│  │  - Forward/redirect                                          │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                             │                                     │
│                    Method calls                                   │
│                             ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    MODEL (Java Classes)                      │ │
│  │                                                              │ │
│  │  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │ │
│  │  │  User.java   │    │ Course.java  │    │Enrollment.java│  │ │
│  │  │  (POJO)      │    │  (POJO)      │    │   (POJO)      │  │ │
│  │  └──────────────┘    └──────────────┘    └──────────────┘   │ │
│  │                                                              │ │
│  │  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │ │
│  │  │  UserDAO     │    │  CourseDAO   │    │EnrollmentDAO │   │ │
│  │  │  (DB Access) │    │  (DB Access) │    │  (DB Access) │   │ │
│  │  └──────────────┘    └──────────────┘    └──────────────┘   │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                             │                                     │
│                    SQL Queries                                    │
│                             ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    DATABASE (MySQL)                          │ │
│  │  Tables: users, courses, enrollments                         │ │
│  └─────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

**How to explain MVC:**
> "MVC separates concerns:
> - **Model**: Java classes that represent data (User, Course, Enrollment) and DAOs that handle database operations
> - **View**: JSP pages that display data using HTML + JSTL/EL
> - **Controller**: Servlets that handle HTTP requests, process logic, and decide what view to show"

---

# 🛡️ SECURITY FEATURES

## 1. SQL Injection Prevention
**File:** All DAO classes use PreparedStatement

```java
// SAFE - uses parameterized query
String sql = "SELECT * FROM users WHERE username = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, username);  // Value is escaped automatically

// UNSAFE - never do this!
String sql = "SELECT * FROM users WHERE username = '" + username + "'";
```

**How to explain:**
> "PreparedStatement separates SQL structure from data. The `?` is a placeholder that gets safely substituted. Even if someone types `'; DROP TABLE users; --` as username, it's treated as literal text, not SQL."

## 2. Password Hashing
**File:** `src/main/java/com/coursemanagement/util/PasswordUtil.java`

```java
// Hashing (one-way)
String hash = BCrypt.hashpw("password123", BCrypt.gensalt(12));
// Result: "$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN82/"

// Verification
boolean matches = BCrypt.checkpw("password123", storedHash);
```

**How to explain:**
> "BCrypt is a one-way hash - you can't reverse it. The number 12 is the 'cost factor' - higher means slower but more secure. Each hash includes a random salt, so two users with the same password have different hashes."

## 3. Session-Based Authentication
```java
// Create session after login
HttpSession session = request.getSession(true);
session.setAttribute("currentUser", user);

// Check session on protected pages
HttpSession session = request.getSession(false);
User user = (User) session.getAttribute("currentUser");
if (user == null) {
    response.sendRedirect("/login.jsp");
}
```

## 4. Role-Based Access Control
**File:** `src/main/java/com/coursemanagement/servlet/AuthenticationFilter.java`

```java
private boolean hasAccess(User user, String path) {
    if (user.isAdmin()) return true;  // Admin can access everything
    if (user.isTeacher()) return path.startsWith("/teacher/");
    if (user.isStudent()) return path.startsWith("/student/");
    return false;
}
```

---

# 🗃️ DATABASE SCHEMA

## Tables Overview

```sql
-- Users table (R-1: Three user types)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- BCrypt hash
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    user_type ENUM('STUDENT', 'TEACHER', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Courses table (R-3: Admin manages courses)
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT DEFAULT 3,
    teacher_id INT,  -- Foreign key to users
    max_students INT DEFAULT 30,
    enrolled_students INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id)
);

-- Enrollments table (R-4 & R-5: Student-Course relationship)
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,    -- Foreign key to users
    course_id INT NOT NULL,     -- Foreign key to courses
    status ENUM('ENROLLED', 'DROPPED', 'COMPLETED', 'PENDING') DEFAULT 'ENROLLED',
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE KEY unique_enrollment (student_id, course_id)
);
```

**How to explain the relationships:**
> "The `enrollments` table is a **junction table** that implements the many-to-many relationship between students and courses. It has foreign keys to both `users` (student_id) and `courses` (course_id). The UNIQUE constraint prevents duplicate enrollments."

---

# 📁 PROJECT STRUCTURE

```
src/main/java/com/coursemanagement/
├── model/                    # Data classes (POJOs)
│   ├── User.java            # User entity with UserType enum
│   ├── Course.java          # Course entity
│   └── Enrollment.java      # Student-Course relationship
│
├── dao/                      # Database access layer
│   ├── UserDAO.java         # User CRUD + authentication
│   ├── CourseDAO.java       # Course CRUD + teacher assignment
│   └── EnrollmentDAO.java   # Enrollment CRUD
│
├── servlet/                  # HTTP request handlers
│   ├── LoginServlet.java    # Authentication (R-2)
│   ├── LogoutServlet.java   # Session termination
│   ├── AuthenticationFilter.java  # Security filter
│   │
│   ├── CourseManagementServlet.java   # Admin: courses (R-3)
│   ├── UserManagementServlet.java     # Admin: users
│   │
│   ├── StudentDashboardServlet.java   # Student features (R-4)
│   ├── CourseRegistrationServlet.java # Course registration
│   │
│   ├── TeacherDashboardServlet.java   # Teacher features (R-5)
│   └── ViewStudentsServlet.java       # View enrolled students
│
└── util/                     # Utilities
    ├── DatabaseConnection.java  # DB connection management
    ├── PasswordUtil.java        # BCrypt password hashing
    └── ConnectionPool.java      # Connection pooling

src/main/webapp/
├── login.jsp                 # Login page
├── admin/                    # Admin JSP pages
│   ├── dashboard.jsp
│   ├── courses.jsp
│   └── users.jsp
├── teacher/                  # Teacher JSP pages
│   ├── dashboard.jsp
│   ├── students.jsp
│   └── view-students.jsp
├── student/                  # Student JSP pages
│   ├── dashboard.jsp
│   └── courses.jsp
└── WEB-INF/
    └── web.xml              # Servlet mappings & config
```

---

# 🔄 REQUEST FLOW EXAMPLES

## Example 1: Student Registers for a Course

```
1. Student clicks "Register" button on course
   → Browser sends POST to /student/dashboard?action=register&courseId=5

2. StudentDashboardServlet.doPost() receives request
   → Checks session: is user logged in? Is user a student?
   → Gets courseId from request parameters

3. Servlet calls enrollmentDAO.getEnrollmentsByStudent(userId)
   → Checks if already enrolled (prevents duplicates)

4. Servlet creates new Enrollment object
   → enrollment.setStudentId(currentUser.getUserId())
   → enrollment.setCourseId(courseId)

5. Servlet calls enrollmentDAO.createEnrollment(enrollment)
   → DAO executes INSERT INTO enrollments (student_id, course_id)
   → Database creates new row

6. Servlet sets success message and calls doGet()
   → Reloads dashboard with updated enrollment list

7. Dashboard JSP displays success message and updated courses
```

## Example 2: Teacher Views Students in a Course

```
1. Teacher clicks course link
   → Browser sends GET to /teacher/students?courseId=5

2. ViewStudentsServlet.doGet() receives request
   → Checks session: is user logged in? Is user a teacher?
   
3. Servlet calls courseDAO.findById(courseId)
   → Verifies teacher is assigned to this course
   → If not, shows error (security!)

4. Servlet calls enrollmentDAO.getEnrollmentsByCourse(courseId)
   → DAO executes JOIN query across enrollments + users
   → Returns list of Enrollment objects with student names

5. Servlet sets attributes: course, enrollments
   → request.setAttribute("enrollments", enrollments)

6. Servlet forwards to JSP
   → request.getRequestDispatcher("/teacher/view-students.jsp").forward()

7. JSP iterates through enrollments list
   → <c:forEach items="${enrollments}" var="e">
   → Displays student name, email, enrollment date
```

---

# ❓ COMMON VIVA QUESTIONS & ANSWERS

## Q: "Why did you use Servlets instead of Spring?"
> "The lab requirement specified using Servlets and JSP to understand the fundamentals. Servlets are the foundation that frameworks like Spring build upon. Understanding Servlets helps us appreciate what Spring abstracts away."

## Q: "How do you prevent SQL injection?"
> "We use PreparedStatement with parameterized queries. The `?` placeholder ensures user input is always treated as data, never as SQL code. Additionally, input validation rejects obviously malicious input."

## Q: "Why BCrypt for passwords?"
> "BCrypt is designed for password hashing with three key features: (1) it's one-way - can't be reversed, (2) it includes a random salt to prevent rainbow table attacks, (3) it has configurable cost factor that makes brute force attacks slow."

## Q: "How does session management work?"
> "After successful login, we create an HttpSession and store the User object. The server sends a session ID cookie to the browser. On subsequent requests, the browser sends this cookie back, and we retrieve the User from the session."

## Q: "Why do you have separate DAO classes?"
> "The DAO pattern separates database logic from business logic. This makes code easier to test, maintain, and modify. If we switch from MySQL to PostgreSQL, we only need to change DAO implementations."

## Q: "How do you handle concurrent enrollment?"
> "The database has a UNIQUE constraint on (student_id, course_id) which prevents duplicate enrollments even if two requests arrive simultaneously. We also check existing enrollments in Java code for better error messages."

## Q: "What is the AuthenticationFilter for?"
> "It's a Servlet Filter that intercepts all requests to protected URLs. It checks if a valid session exists before allowing access. This centralizes security logic instead of repeating it in every servlet."

---

# 🧪 TESTING THE APPLICATION

## Default Credentials
| Role | Username | Password |
|------|----------|----------|
| Admin | admin | password123 |
| Teacher | teacher1 | password123 |
| Student | student1 | password123 |

## Test Scenarios

### R-1: Three User Types
1. Login as each user type
2. Verify each sees their specific dashboard
3. Try accessing other user's pages (should be denied)

### R-2: Authentication
1. Try logging in with wrong password (should fail)
2. Try accessing protected page without login (should redirect)
3. Login successfully and verify session is created

### R-3: Admin Course Management
1. Login as admin
2. Create a new course
3. Assign a teacher to the course
4. Verify course appears in list

### R-4: Student Registration
1. Login as student
2. View available courses
3. Register for a course
4. Verify course appears in "My Courses"
5. Try registering again (should show error)

### R-5: Teacher View Students
1. Login as teacher
2. View assigned courses
3. Click on a course to see enrolled students
4. Verify student list is correct

---

# 🔄 COMPLETE STEP-BY-STEP WALKTHROUGHS

This section provides **detailed walkthroughs** of every user action, showing exactly what happens at each step - from clicking a button to database queries to page rendering.

---

## 🔐 WALKTHROUGH 1: LOGIN FLOW (Complete)

### What happens when you visit `/login`

#### STEP 1: Browser sends request
```
Browser → GET http://localhost:8080/course-management-system-1.0.0/login
```

#### STEP 2: Tomcat receives and routes the request
**File:** `src/main/webapp/WEB-INF/web.xml`

Tomcat looks up the URL pattern `/login` and finds:
```xml
<servlet-mapping>
    <servlet-name>LoginServlet</servlet-name>
    <url-pattern>/login</url-pattern>
</servlet-mapping>
```
So it calls `LoginServlet`.

#### STEP 3: LoginServlet.doGet() runs
**File:** `src/main/java/com/coursemanagement/servlet/LoginServlet.java`
**Lines:** 46-60

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    // Check if user is already logged in
    HttpSession session = request.getSession(false);
    if (session != null && session.getAttribute("currentUser") != null) {
        User currentUser = (User) session.getAttribute("currentUser");
        redirectToDashboard(request, response, currentUser);  // Already logged in → go to dashboard
        return;
    }
    
    // Not logged in → show login page
    request.getRequestDispatcher("/login.jsp").forward(request, response);
}
```

#### STEP 4: login.jsp renders the form
**File:** `src/main/webapp/login.jsp`
**Lines:** 891-932

The JSP renders an HTML form:
```html
<form method="post" action="${pageContext.request.contextPath}/login">
    <!-- Username input -->
    <input type="text" name="username" required>
    
    <!-- Password input -->
    <input type="password" name="password" required>
    
    <!-- Submit button -->
    <button type="submit">Sign In</button>
</form>
```

The `${pageContext.request.contextPath}` becomes `/course-management-system-1.0.0`.

#### STEP 5: User fills form and clicks "Sign In"
Browser sends:
```
POST /course-management-system-1.0.0/login
Content-Type: application/x-www-form-urlencoded

username=student1&password=password123
```

#### STEP 6: LoginServlet.doPost() handles the form
**File:** `src/main/java/com/coursemanagement/servlet/LoginServlet.java`
**Lines:** 66-88

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    String username = request.getParameter("username");  // "student1"
    String password = request.getParameter("password");  // "password123"
    
    // Validate input
    if (username == null || username.trim().isEmpty() || 
        password == null || password.trim().isEmpty()) {
        request.setAttribute("errorMessage", "Username and password are required");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
    
    // Call DAO to authenticate
    User user = userDAO.authenticateUser(username.trim(), password);
```

#### STEP 7: UserDAO.authenticateUser() queries the database
**File:** `src/main/java/com/coursemanagement/dao/UserDAO.java`
**Lines:** 115-170

```java
public User authenticateUser(String username, String password) {
    String sql = "SELECT user_id, username, password, full_name, email, user_type " +
                "FROM users WHERE username = ?";
    
    Connection conn = DatabaseConnection.getConnection();
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, username);  // Safe: prevents SQL injection
    ResultSet rs = stmt.executeQuery();
    
    if (rs.next()) {
        String storedHash = rs.getString("password");  // BCrypt hash from DB
        
        // Verify password using BCrypt
        if (PasswordUtil.verifyPassword(password, storedHash)) {
            // Build User object from DB row
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setFullName(rs.getString("full_name"));
            user.setEmail(rs.getString("email"));
            user.setUserType(UserType.valueOf(rs.getString("user_type")));
            return user;  // SUCCESS!
        }
    }
    return null;  // Login failed
}
```

#### STEP 8: Password verification with BCrypt
**File:** `src/main/java/com/coursemanagement/util/PasswordUtil.java`

```java
public static boolean verifyPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
    // BCrypt.checkpw("password123", "$2a$12$...hash...") → true or false
}
```

#### STEP 9: Back in LoginServlet - create session
**File:** `src/main/java/com/coursemanagement/servlet/LoginServlet.java`
**Lines:** 90-109

```java
if (user != null) {
    // Create HTTP session
    HttpSession session = request.getSession(true);
    
    // Store user info in session (available to all pages)
    session.setAttribute("currentUser", user);
    session.setAttribute("userType", user.getUserType().name());
    session.setAttribute("userId", user.getUserId());
    session.setAttribute("username", user.getUsername());
    session.setAttribute("fullName", user.getFullName());
    
    // Set timeout: 30 minutes
    session.setMaxInactiveInterval(30 * 60);
    
    // Redirect based on role
    redirectToDashboard(request, response, user);
}
```

#### STEP 10: Role-based redirect
**File:** `src/main/java/com/coursemanagement/servlet/LoginServlet.java`
**Lines:** 135-151

```java
private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user) {
    switch (user.getUserType()) {
        case ADMIN:
            response.sendRedirect(contextPath + "/admin/dashboard");
            break;
        case TEACHER:
            response.sendRedirect(contextPath + "/teacher/dashboard");
            break;
        case STUDENT:
            response.sendRedirect(contextPath + "/student/dashboard");
            break;
    }
}
```

#### STEP 11: Browser receives redirect
```
HTTP/1.1 302 Found
Location: /course-management-system-1.0.0/student/dashboard
Set-Cookie: JSESSIONID=ABC123...
```

Browser automatically follows the redirect and loads the dashboard.

---

### LOGIN FAILURE FLOW

If password is wrong:

```java
} else {
    // Authentication failed
    request.setAttribute("errorMessage", "Invalid username or password");
    request.setAttribute("username", username);  // Preserve username
    request.getRequestDispatcher("/login.jsp").forward(request, response);
}
```

The JSP displays the error:
```jsp
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">
        ${errorMessage}
    </div>
</c:if>
```

---

## 📝 WALKTHROUGH 2: STUDENT COURSE REGISTRATION

### What happens when student clicks "Register" button

#### STEP 1: Student sees the "Register" button in dashboard
**File:** `src/main/webapp/student/dashboard.jsp`
**Lines:** 364-370

Each available course has a form:
```jsp
<form method="post" action="${pageContext.request.contextPath}/student/dashboard">
    <input type="hidden" name="action" value="register">
    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
    <button type="submit" class="btn btn-primary">
        <i class="bi bi-plus-circle"></i> Register
    </button>
</form>
```

#### STEP 2: User clicks "Register" → form submits
```
POST /course-management-system-1.0.0/student/dashboard
Content-Type: application/x-www-form-urlencoded

action=register&courseId=5
```

#### STEP 3: AuthenticationFilter checks access
**File:** `src/main/java/com/coursemanagement/servlet/AuthenticationFilter.java`

Before reaching the servlet, the filter runs:
```java
public void doFilter(...) {
    HttpSession session = httpRequest.getSession(false);
    User currentUser = (User) session.getAttribute("currentUser");
    
    if (currentUser == null) {
        // Not logged in → redirect to login
        httpResponse.sendRedirect(contextPath + "/login.jsp");
        return;
    }
    
    if (!hasAccess(currentUser, "/student/dashboard")) {
        // Wrong role → 403 Forbidden
        httpResponse.sendError(403, "Access Denied");
        return;
    }
    
    chain.doFilter(request, response);  // OK, continue
}
```

#### STEP 4: StudentDashboardServlet.doPost() handles the request
**File:** `src/main/java/com/coursemanagement/servlet/StudentDashboardServlet.java`
**Lines:** 92-146

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    // Get logged-in user from session
    HttpSession session = request.getSession(false);
    User currentUser = (User) session.getAttribute("currentUser");
    
    // Verify student role
    if (!currentUser.getUserType().name().equals("STUDENT")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
        return;
    }
    
    String action = request.getParameter("action");  // "register"
    
    if ("register".equals(action)) {
        int courseId = Integer.parseInt(request.getParameter("courseId"));  // 5
```

#### STEP 5: Check if already enrolled
**Lines:** 114-118

```java
// Get all current enrollments for this student
List<Enrollment> existingEnrollments = enrollmentDAO.getEnrollmentsByStudent(currentUser.getUserId());

// Check if already enrolled in this specific course
boolean alreadyEnrolled = existingEnrollments.stream()
    .anyMatch(enrollment -> enrollment.getCourseId() == courseId);

if (alreadyEnrolled) {
    request.setAttribute("errorMessage", "You are already enrolled in this course.");
}
```

#### STEP 6: Create new enrollment
**Lines:** 121-133

```java
} else {
    // Create new Enrollment object
    Enrollment enrollment = new Enrollment();
    enrollment.setStudentId(currentUser.getUserId());  // e.g., 3
    enrollment.setCourseId(courseId);                   // e.g., 5
    
    // Save to database via DAO
    boolean success = enrollmentDAO.createEnrollment(enrollment);
    
    if (success) {
        request.setAttribute("successMessage", "Successfully enrolled in the course!");
    } else {
        request.setAttribute("errorMessage", "Failed to enroll in the course.");
    }
}
```

#### STEP 7: EnrollmentDAO.createEnrollment() inserts into database
**File:** `src/main/java/com/coursemanagement/dao/EnrollmentDAO.java`

```java
public boolean createEnrollment(Enrollment enrollment) {
    String sql = "INSERT INTO enrollments (student_id, course_id, status) VALUES (?, ?, 'ENROLLED')";
    
    Connection conn = DatabaseConnection.getConnection();
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setInt(1, enrollment.getStudentId());  // 3
    stmt.setInt(2, enrollment.getCourseId());   // 5
    
    int rowsAffected = stmt.executeUpdate();
    return rowsAffected > 0;  // true if INSERT succeeded
}
```

**Database result:**
```sql
INSERT INTO enrollments (student_id, course_id, status) VALUES (3, 5, 'ENROLLED');
-- New row created with enrollment_id=10 (auto-increment)
```

#### STEP 8: Reload dashboard with updated data
**Lines:** 144-145

```java
// Call doGet to reload the dashboard
doGet(request, response);
```

This re-fetches:
- `enrolledCourses` (now includes the new enrollment)
- `availableCourses`

#### STEP 9: JSP shows success message and updated tables
**File:** `src/main/webapp/student/dashboard.jsp`

Success message:
```jsp
<% if (successMessage != null) { %>
    <div class="alert alert-success">
        <i class="bi bi-check-circle"></i> <%= successMessage %>
    </div>
<% } %>
```

The enrolled courses table now shows the new course!

---

## 📚 WALKTHROUGH 3: ADMIN CREATES A COURSE

### What happens when admin fills the course form and clicks "Add Course"

#### STEP 1: Admin visits course management page
```
GET /course-management-system-1.0.0/admin/courses
```

#### STEP 2: CourseManagementServlet.doGet() loads data
**File:** `src/main/java/com/coursemanagement/servlet/CourseManagementServlet.java`

```java
protected void doGet(...) {
    // Verify admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (!currentUser.isAdmin()) {
        response.sendError(403, "Access Denied");
        return;
    }
    
    // Load all courses
    List<Course> courses = courseDAO.getAllCourses();
    
    // Load all teachers (for assignment dropdown)
    List<User> teachers = userDAO.getUsersByType(UserType.TEACHER);
    
    request.setAttribute("courses", courses);
    request.setAttribute("teachers", teachers);
    request.getRequestDispatcher("/admin/courses.jsp").forward(request, response);
}
```

#### STEP 3: courses.jsp renders the form
**File:** `src/main/webapp/admin/courses.jsp`
**Lines:** 105-166

```html
<form method="post" action="${pageContext.request.contextPath}/admin/courses">
    <input type="hidden" name="action" value="create">
    
    <input type="text" name="courseCode" placeholder="CSE-446" required>
    <input type="text" name="courseName" placeholder="Web Engineering" required>
    <input type="number" name="credits" value="3" min="1" max="6" required>
    <input type="number" name="maxStudents" value="50" required>
    <textarea name="description" required></textarea>
    
    <!-- Teacher dropdown populated from ${teachers} -->
    <select name="teacherId">
        <option value="">Select a teacher</option>
        <% for (User teacher : teachers) { %>
            <option value="<%= teacher.getUserId() %>">
                <%= teacher.getFullName() %>
            </option>
        <% } %>
    </select>
    
    <button type="submit">Add Course</button>
</form>
```

#### STEP 4: Admin fills form and submits
```
POST /course-management-system-1.0.0/admin/courses
Content-Type: application/x-www-form-urlencoded

action=create&courseCode=CSE-446&courseName=Web+Engineering&credits=3&maxStudents=50&description=Learn+servlets&teacherId=2
```

#### STEP 5: CourseManagementServlet.doPost() processes creation
**File:** `src/main/java/com/coursemanagement/servlet/CourseManagementServlet.java`

```java
protected void doPost(...) {
    // Verify admin
    if (!currentUser.isAdmin()) {
        response.sendError(403);
        return;
    }
    
    String action = request.getParameter("action");  // "create"
    
    if ("create".equals(action)) {
        handleCreateCourse(request, response);
    }
}
```

#### STEP 6: handleCreateCourse() validates and saves
```java
private void handleCreateCourse(HttpServletRequest request, HttpServletResponse response) {
    // Get form data
    String courseCode = request.getParameter("courseCode");      // "CSE-446"
    String courseName = request.getParameter("courseName");      // "Web Engineering"
    String description = request.getParameter("description");    // "Learn servlets"
    int credits = Integer.parseInt(request.getParameter("credits"));  // 3
    int maxStudents = Integer.parseInt(request.getParameter("maxStudents"));  // 50
    String teacherIdStr = request.getParameter("teacherId");     // "2"
    
    // Validate: check if course code already exists
    if (courseDAO.courseCodeExists(courseCode)) {
        request.setAttribute("errorMessage", "Course code already exists!");
        showCourseList(request, response);
        return;
    }
    
    // Build Course object
    Course course = new Course();
    course.setCourseCode(courseCode);
    course.setCourseName(courseName);
    course.setDescription(description);
    course.setCredits(credits);
    course.setMaxStudents(maxStudents);
    
    if (teacherIdStr != null && !teacherIdStr.isEmpty()) {
        course.setTeacherId(Integer.parseInt(teacherIdStr));
    }
    
    // Save to database
    boolean success = courseDAO.createCourse(course);
    
    if (success) {
        request.setAttribute("successMessage", "Course created successfully!");
    } else {
        request.setAttribute("errorMessage", "Failed to create course.");
    }
    
    showCourseList(request, response);
}
```

#### STEP 7: CourseDAO.createCourse() inserts into database
**File:** `src/main/java/com/coursemanagement/dao/CourseDAO.java`

```java
public boolean createCourse(Course course) {
    String sql = "INSERT INTO courses (course_code, course_name, description, credits, max_students, teacher_id) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
    
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, course.getCourseCode());    // "CSE-446"
    stmt.setString(2, course.getCourseName());    // "Web Engineering"
    stmt.setString(3, course.getDescription());   // "Learn servlets"
    stmt.setInt(4, course.getCredits());          // 3
    stmt.setInt(5, course.getMaxStudents());      // 50
    stmt.setInt(6, course.getTeacherId());        // 2
    
    return stmt.executeUpdate() > 0;
}
```

#### STEP 8: Page reloads showing new course in list
The admin sees:
- Success message: "Course created successfully!"
- New course appears in the courses table

---

## 👨‍🏫 WALKTHROUGH 4: TEACHER VIEWS ENROLLED STUDENTS

### What happens when teacher clicks on a course to see students

#### STEP 1: Teacher is on dashboard, sees assigned courses
**File:** `src/main/webapp/teacher/dashboard.jsp`

Each course has a "View Students" link:
```html
<a href="${pageContext.request.contextPath}/teacher/students?courseId=5">
    View Students
</a>
```

#### STEP 2: Teacher clicks "View Students"
```
GET /course-management-system-1.0.0/teacher/students?courseId=5
```

#### STEP 3: AuthenticationFilter verifies teacher role
```java
// URL: /teacher/students
// User role: TEACHER
// hasAccess() returns true because path.startsWith("/teacher/")
chain.doFilter(request, response);  // Allow
```

#### STEP 4: ViewStudentsServlet.doGet() handles the request
**File:** `src/main/java/com/coursemanagement/servlet/ViewStudentsServlet.java`
**Lines:** 44-103

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    // Get logged-in user
    User currentUser = (User) session.getAttribute("currentUser");
    
    // Verify teacher role
    if (!currentUser.getUserType().name().equals("TEACHER")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
        return;
    }
    
    // Get courseId from URL parameter
    int courseId = Integer.parseInt(request.getParameter("courseId"));  // 5
```

#### STEP 5: Security check - verify teacher owns this course
**Lines:** 86-92

```java
// Get the course
Course course = courseDAO.findById(courseId);

// SECURITY: Verify this teacher is actually assigned to this course
if (course == null || course.getTeacherId() != currentUser.getUserId()) {
    request.setAttribute("errorMessage", "You are not assigned to this course.");
    request.getRequestDispatcher("/error.jsp").forward(request, response);
    return;
}
```

**Why this matters:**
> This prevents a teacher from typing `?courseId=99` in the URL to spy on another teacher's course. Always verify ownership!

#### STEP 6: Load enrolled students from database
**Lines:** 94-95

```java
List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByCourse(courseId);
```

**File:** `src/main/java/com/coursemanagement/dao/EnrollmentDAO.java`

```java
public List<Enrollment> getEnrollmentsByCourse(int courseId) {
    String sql = "SELECT e.*, u.full_name as student_name, u.email as student_email " +
                "FROM enrollments e " +
                "JOIN users u ON e.student_id = u.user_id " +
                "WHERE e.course_id = ?";
    
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setInt(1, courseId);  // 5
    ResultSet rs = stmt.executeQuery();
    
    List<Enrollment> enrollments = new ArrayList<>();
    while (rs.next()) {
        Enrollment e = new Enrollment();
        e.setEnrollmentId(rs.getInt("enrollment_id"));
        e.setStudentId(rs.getInt("student_id"));
        e.setStudentName(rs.getString("student_name"));    // From JOIN
        e.setStudentEmail(rs.getString("student_email"));  // From JOIN
        e.setStatus(EnrollmentStatus.valueOf(rs.getString("status")));
        e.setEnrollmentDate(rs.getTimestamp("enrollment_date"));
        enrollments.add(e);
    }
    return enrollments;
}
```

#### STEP 7: Forward to JSP with data
**Lines:** 97-103

```java
request.setAttribute("course", course);
request.setAttribute("enrollments", enrollments);
request.setAttribute("currentUser", currentUser);

request.getRequestDispatcher("/teacher/view-students.jsp").forward(request, response);
```

#### STEP 8: JSP renders the student list
**File:** `src/main/webapp/teacher/view-students.jsp`

```jsp
<h3>Students enrolled in <%= course.getCourseName() %></h3>

<table>
    <thead>
        <tr>
            <th>Student Name</th>
            <th>Email</th>
            <th>Status</th>
            <th>Enrollment Date</th>
        </tr>
    </thead>
    <tbody>
        <% for (Enrollment e : enrollments) { %>
            <tr>
                <td><%= e.getStudentName() %></td>
                <td><%= e.getStudentEmail() %></td>
                <td><%= e.getStatus() %></td>
                <td><%= e.getEnrollmentDate() %></td>
            </tr>
        <% } %>
    </tbody>
</table>
```

---

## 🚪 WALKTHROUGH 5: LOGOUT FLOW

### What happens when user clicks "Logout"

#### STEP 1: User clicks logout link
```html
<a href="${pageContext.request.contextPath}/logout">Logout</a>
```

#### STEP 2: LogoutServlet handles the request
**File:** `src/main/java/com/coursemanagement/servlet/LogoutServlet.java`

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    HttpSession session = request.getSession(false);
    
    if (session != null) {
        String username = (String) session.getAttribute("username");
        System.out.println("User '" + username + "' logged out");
        
        // Invalidate (destroy) the session
        session.invalidate();
    }
    
    // Redirect to login page with message
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=logged_out");
}
```

#### STEP 3: Session is destroyed
- All session attributes (`currentUser`, `userId`, etc.) are deleted
- The `JSESSIONID` cookie becomes invalid

#### STEP 4: User sees login page with message
```jsp
<c:if test="${param.message == 'logged_out'}">
    <div class="alert alert-success">
        You have been logged out successfully.
    </div>
</c:if>
```

---

## 🛡️ WALKTHROUGH 6: UNAUTHORIZED ACCESS ATTEMPT

### What happens when a student tries to access `/admin/dashboard`

#### STEP 1: Student (logged in) types URL manually
```
GET /course-management-system-1.0.0/admin/dashboard
```

#### STEP 2: AuthenticationFilter intercepts
**File:** `src/main/java/com/coursemanagement/servlet/AuthenticationFilter.java`

```java
public void doFilter(...) {
    String relativePath = "/admin/dashboard";
    User currentUser = (User) session.getAttribute("currentUser");
    // currentUser.getUserType() = STUDENT
    
    if (!hasAccess(currentUser, relativePath)) {
        // hasAccess returns false for STUDENT accessing /admin/*
        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
        return;
    }
}

private boolean hasAccess(User user, String path) {
    if (user.isAdmin()) return true;  // No
    if (user.isTeacher()) return path.startsWith("/teacher/");  // No
    if (user.isStudent()) return path.startsWith("/student/");  // /admin/* doesn't match
    return false;
}
```

#### STEP 3: User sees 403 Forbidden error
The browser displays:
```
HTTP Status 403 – Forbidden
Access Denied
```

---

## 📤 WALKTHROUGH 7: ADMIN BULK IMPORT COURSES

### What happens when admin uploads an Excel/CSV file to bulk import courses

#### STEP 1: Admin visits Course Management page
**File:** `src/main/webapp/admin/courses.jsp`
**Lines:** 172-211

The page contains a bulk import form:
```html
<div class="card">
    <div class="card-header">
        <h5><i class="bi bi-upload me-2"></i>Bulk Import Courses</h5>
    </div>
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/bulk-import" 
              method="post" enctype="multipart/form-data">
            <input type="hidden" name="type" value="courses">
            <input type="file" name="file" accept=".xlsx,.csv" required>
            <button type="submit">Upload and Import</button>
        </form>
    </div>
</div>
```

**Key points:**
- `enctype="multipart/form-data"` is required for file uploads
- `accept=".xlsx,.csv"` limits file picker to Excel/CSV files
- Hidden `type` field tells servlet which kind of import (courses vs users)

#### STEP 2: Admin clicks "Browse" button
The browser opens a native file picker dialog. User selects an Excel (.xlsx) or CSV file.

**Expected file format (courses):**
| courseCode | courseName | description | credits | maxStudents | teacherId |
|------------|------------|-------------|---------|-------------|-----------|
| CSE-101 | Intro to CS | Basic programming | 3 | 50 | 2 |
| CSE-201 | Data Structures | Advanced topics | 3 | 40 | |

#### STEP 3: Admin clicks "Upload and Import"
```
POST /course-management-system-1.0.0/admin/bulk-import
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary...

------WebKitFormBoundary...
Content-Disposition: form-data; name="type"

courses
------WebKitFormBoundary...
Content-Disposition: form-data; name="file"; filename="courses.xlsx"
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet

[binary file data]
------WebKitFormBoundary...--
```

#### STEP 4: BulkImportServlet.doPost() receives the upload
**File:** `src/main/java/com/coursemanagement/servlet/BulkImportServlet.java`
**Lines:** 36-81

```java
@WebServlet("/admin/bulk-import")
@MultipartConfig  // Required annotation for file uploads
public class BulkImportServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        String type = request.getParameter("type");  // "courses"
        Part filePart = request.getPart("file");     // The uploaded file
        
        if (filePart == null || filePart.getSize() == 0) {
            request.getSession().setAttribute("errorMessage", "Please select a file.");
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }
        
        String fileName = filePart.getSubmittedFileName();  // "courses.xlsx"
        InputStream fileContent = filePart.getInputStream();
        
        if ("courses".equals(type)) {
            List<Course> courses = parseCourses(fileContent, fileName);
            CourseDAO courseDAO = new CourseDAO();
            for (Course course : courses) {
                courseDAO.createCourse(course);
            }
            successMessage = courses.size() + " courses imported successfully.";
        }
    }
}
```

**How to explain @MultipartConfig:**
> "This annotation tells the servlet container that this servlet can handle multipart/form-data requests (file uploads). Without it, `request.getPart()` would fail."

#### STEP 5: parseCourses() reads Excel or CSV file
**Lines:** 128-175

```java
private List<Course> parseCourses(InputStream inputStream, String fileName) {
    List<Course> courses = new ArrayList<>();
    
    if (fileName.endsWith(".xlsx")) {
        // Excel parsing using Apache POI
        Workbook workbook = new XSSFWorkbook(inputStream);
        Sheet sheet = workbook.getSheetAt(0);  // First sheet
        Iterator<Row> iterator = sheet.iterator();
        
        // Skip header row
        if (iterator.hasNext()) iterator.next();
        
        while (iterator.hasNext()) {
            Row currentRow = iterator.next();
            Course course = new Course();
            course.setCourseCode(getCellValue(currentRow.getCell(0)));
            course.setCourseName(getCellValue(currentRow.getCell(1)));
            course.setDescription(getCellValue(currentRow.getCell(2)));
            course.setCredits((int) Double.parseDouble(getCellValue(currentRow.getCell(3))));
            course.setMaxStudents((int) Double.parseDouble(getCellValue(currentRow.getCell(4))));
            // teacherId is optional (column 5)
            courses.add(course);
        }
        workbook.close();
        
    } else if (fileName.endsWith(".csv")) {
        // CSV parsing using Apache Commons CSV
        CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT.withFirstRecordAsHeader());
        for (CSVRecord record : csvParser) {
            Course course = new Course();
            course.setCourseCode(record.get("courseCode"));
            course.setCourseName(record.get("courseName"));
            // ... same pattern
            courses.add(course);
        }
    }
    return courses;
}
```

**How to explain the libraries:**
> "We use Apache POI for Excel files (.xlsx) and Apache Commons CSV for CSV files. POI can read the binary Excel format, while Commons CSV handles text-based comma-separated values."

#### STEP 6: Each course is saved to database
```java
for (Course course : courses) {
    courseDAO.createCourse(course);
}
```

This calls `CourseDAO.createCourse()` for each row in the file, inserting into the database.

#### STEP 7: Redirect with success message
```java
request.getSession().setAttribute("successMessage", "5 courses imported successfully.");
response.sendRedirect(request.getContextPath() + "/admin/courses");
```

Admin sees the Course Management page with a success banner and all new courses in the table.

---

## ✏️ WALKTHROUGH 8: ADMIN EDITS A COURSE

### What happens when admin clicks the Edit button on a course

#### STEP 1: Admin is on Course Management page, sees course list
**File:** `src/main/webapp/admin/courses.jsp`
**Lines:** 387-392

Each course row has an Edit button:
```html
<a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=<%= course.getCourseId() %>" 
   class="btn btn-outline-primary" title="Edit Course">
    <i class="bi bi-pencil"></i>
</a>
```

#### STEP 2: Admin clicks Edit button
```
GET /course-management-system-1.0.0/admin/courses?action=edit&id=5
```

#### STEP 3: CourseManagementServlet.doGet() handles edit action
**File:** `src/main/java/com/coursemanagement/servlet/CourseManagementServlet.java`
**Lines:** 56-58, 271-291

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    String action = request.getParameter("action");  // "edit"
    
    if ("edit".equals(action)) {
        handleEditCourse(request, response);
    }
}

private void handleEditCourse(HttpServletRequest request, HttpServletResponse response) {
    String courseIdStr = request.getParameter("id");  // "5"
    
    int courseId = Integer.parseInt(courseIdStr);
    Course course = courseDAO.findById(courseId);  // Load from DB
    
    if (course != null) {
        request.setAttribute("editCourse", course);  // Pass to JSP
    } else {
        request.setAttribute("errorMessage", "Course not found");
    }
    
    showCourseList(request, response);  // Render page with form pre-filled
}
```

#### STEP 4: JSP detects editCourse and shows pre-filled form
**File:** `src/main/webapp/admin/courses.jsp`
**Lines:** 97-166

```jsp
<%
    Course editCourse = (Course) request.getAttribute("editCourse");
%>

<div class="card-header">
    <h5>
        <%= editCourse != null ? "Edit Course" : "Add New Course" %>
    </h5>
</div>

<form method="post" action="${pageContext.request.contextPath}/admin/courses">
    <!-- Hidden action field changes based on mode -->
    <input type="hidden" name="action" value="<%= editCourse != null ? "update" : "create" %>">
    
    <!-- If editing, include courseId -->
    <% if (editCourse != null) { %>
        <input type="hidden" name="courseId" value="<%= editCourse.getCourseId() %>">
    <% } %>
    
    <!-- Pre-filled inputs -->
    <input type="text" name="courseCode" 
           value="<%= editCourse != null ? editCourse.getCourseCode() : "" %>" required>
    
    <input type="text" name="courseName" 
           value="<%= editCourse != null ? editCourse.getCourseName() : "" %>" required>
    
    <!-- Cancel button (only shows in edit mode) -->
    <% if (editCourse != null) { %>
        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary">Cancel</a>
    <% } %>
    
    <button type="submit">
        <%= editCourse != null ? "Update Course" : "Add Course" %>
    </button>
</form>
```

**Key concept:**
> The same form is used for both creating and editing. The `editCourse` attribute determines which mode it's in. When editing, the form action becomes "update" instead of "create".

#### STEP 5: Admin modifies fields and clicks "Update Course"
```
POST /course-management-system-1.0.0/admin/courses
Content-Type: application/x-www-form-urlencoded

action=update&courseId=5&courseCode=CSE-446&courseName=Web+Engineering+Lab&credits=3&maxStudents=60&description=Updated+description&teacherId=2
```

#### STEP 6: CourseManagementServlet.doPost() handles update
**Lines:** 96-97, 201-235

```java
protected void doPost(...) {
    String action = request.getParameter("action");  // "update"
    
    if ("update".equals(action)) {
        handleUpdateCourse(request, response);
    }
}

private void handleUpdateCourse(HttpServletRequest request, HttpServletResponse response) {
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    String courseCode = request.getParameter("courseCode");
    String courseName = request.getParameter("courseName");
    // ... get all other fields
    
    Course course = new Course(courseId, courseCode, courseName, 
                              description, credits, teacherId, maxStudents);
    
    if (courseDAO.updateCourse(course)) {
        request.setAttribute("successMessage", "Course updated successfully");
    } else {
        request.setAttribute("errorMessage", "Failed to update course");
    }
    
    showCourseList(request, response);
}
```

#### STEP 7: CourseDAO.updateCourse() runs UPDATE query
**File:** `src/main/java/com/coursemanagement/dao/CourseDAO.java`

```java
public boolean updateCourse(Course course) {
    String sql = "UPDATE courses SET course_code = ?, course_name = ?, " +
                "description = ?, credits = ?, max_students = ?, teacher_id = ? " +
                "WHERE course_id = ?";
    
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, course.getCourseCode());
    stmt.setString(2, course.getCourseName());
    stmt.setString(3, course.getDescription());
    stmt.setInt(4, course.getCredits());
    stmt.setInt(5, course.getMaxStudents());
    stmt.setInt(6, course.getTeacherId());
    stmt.setInt(7, course.getCourseId());  // WHERE clause
    
    return stmt.executeUpdate() > 0;
}
```

#### STEP 8: Page reloads with updated course
Admin sees success message and the course table shows the updated values.

---

## 👥 WALKTHROUGH 9: TEACHER CLICKS "MANAGE STUDENTS"

### What happens when teacher clicks "Manage Students" on a course card

#### STEP 1: Teacher is on dashboard, sees course cards
**File:** `src/main/webapp/teacher/dashboard.jsp`
**Lines:** 289-337

Each course card has a "Manage Students" button:
```html
<div class="glass-card course-card-premium">
    <div class="course-header">
        <div class="course-code-badge"><%= course.getCourseCode() %></div>
        <div class="course-actions">
            <a href="${pageContext.request.contextPath}/teacher/students?courseId=<%= course.getCourseId() %>" 
               class="btn-icon">
                <i class="bi bi-people-fill"></i>
            </a>
        </div>
    </div>
    
    <div class="course-content">
        <h4><%= course.getCourseName() %></h4>
        <p><%= course.getDescription() %></p>
    </div>
    
    <div class="course-footer">
        <a href="${pageContext.request.contextPath}/teacher/students?courseId=<%= course.getCourseId() %>" 
           class="btn btn-premium-outline w-100">
            <i class="bi bi-person-lines-fill me-2"></i>Manage Students
        </a>
    </div>
</div>
```

#### STEP 2: Teacher clicks "Manage Students"
```
GET /course-management-system-1.0.0/teacher/students?courseId=5
```

#### STEP 3: ViewStudentsServlet.doGet() processes the request
**File:** `src/main/java/com/coursemanagement/servlet/ViewStudentsServlet.java`
**Lines:** 44-103

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    HttpSession session = request.getSession(false);
    User currentUser = (User) session.getAttribute("currentUser");
    
    // Verify teacher role
    if (!currentUser.getUserType().name().equals("TEACHER")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
        return;
    }
    
    String courseIdParam = request.getParameter("courseId");
    int courseId = Integer.parseInt(courseIdParam);  // 5
    
    // SECURITY: Verify teacher owns this course
    Course course = courseDAO.findById(courseId);
    if (course == null || course.getTeacherId() != currentUser.getUserId()) {
        request.setAttribute("errorMessage", "You are not assigned to this course.");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
        return;
    }
    
    // Load enrolled students
    List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByCourse(courseId);
    
    request.setAttribute("course", course);
    request.setAttribute("enrollments", enrollments);
    request.setAttribute("currentUser", currentUser);
    
    request.getRequestDispatcher("/teacher/view-students.jsp").forward(request, response);
}
```

**Security check explained:**
> "We verify `course.getTeacherId() == currentUser.getUserId()` to ensure a teacher can only view students in their OWN courses. This prevents URL manipulation attacks."

#### STEP 4: view-students.jsp renders the student list
**File:** `src/main/webapp/teacher/view-students.jsp`

```jsp
<h3>Students in <%= course.getCourseName() %> (<%= course.getCourseCode() %>)</h3>

<table class="table">
    <thead>
        <tr>
            <th>Student Name</th>
            <th>Email</th>
            <th>Status</th>
            <th>Enrolled Date</th>
        </tr>
    </thead>
    <tbody>
        <% for (Enrollment e : enrollments) { %>
            <tr>
                <td><%= e.getStudentName() %></td>
                <td><%= e.getStudentEmail() %></td>
                <td><span class="badge bg-success"><%= e.getStatus() %></span></td>
                <td><%= e.getEnrollmentDate() %></td>
            </tr>
        <% } %>
    </tbody>
</table>
```

Teacher now sees all students enrolled in this specific course with their details.

---

## 🔍 WALKTHROUGH 10: STUDENT CLICKS "BROWSE COURSES" AND "REGISTER"

### What happens when student navigates to browse available courses and registers

#### STEP 1: Student is on dashboard, clicks "Available Courses" card
**File:** `src/main/webapp/student/dashboard.jsp`
**Lines:** 162-187

The "Available Courses" stat card is clickable:
```html
<a href="${pageContext.request.contextPath}/student/register" 
   class="glass-card stat-card-premium student-stat">
    <div class="stat-icon-container">
        <div class="stat-icon bg-gradient-success">
            <i class="bi bi-plus-circle"></i>
        </div>
    </div>
    <div class="stat-content">
        <span class="stat-number">${availableCourses.size()}</span>
        <h3 class="stat-title">Available Courses</h3>
        <p class="stat-subtitle">Ready to enroll</p>
    </div>
</a>
```

#### STEP 2: Student clicks the card (Browse Courses)
```
GET /course-management-system-1.0.0/student/register
```

#### STEP 3: CourseRegistrationServlet.doGet() loads courses
**File:** `src/main/java/com/coursemanagement/servlet/CourseRegistrationServlet.java`
**Lines:** 42-79

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    HttpSession session = request.getSession(false);
    User currentUser = (User) session.getAttribute("currentUser");
    
    // Verify student role
    if (!currentUser.getUserType().name().equals("STUDENT")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
        return;
    }
    
    // Get all available courses (courses with open slots)
    List<Course> availableCourses = courseDAO.getAvailableCourses();
    
    // Get student's already enrolled courses (to show "Already Enrolled" badge)
    List<Enrollment> enrolledCourses = enrollmentDAO.getEnrollmentsByStudent(currentUser.getUserId());
    
    request.setAttribute("availableCourses", availableCourses);
    request.setAttribute("enrolledCourses", enrolledCourses);
    request.setAttribute("currentUser", currentUser);
    
    request.getRequestDispatcher("/student/register.jsp").forward(request, response);
}
```

#### STEP 4: register.jsp displays available courses
**File:** `src/main/webapp/student/register.jsp`

```jsp
<h2>Browse Available Courses</h2>

<div class="course-grid">
    <% for (Course course : availableCourses) { 
        // Check if student already enrolled
        boolean alreadyEnrolled = enrolledCourses.stream()
            .anyMatch(e -> e.getCourseId() == course.getCourseId());
    %>
        <div class="course-card">
            <div class="course-header">
                <span class="badge"><%= course.getCourseCode() %></span>
                <span class="credits"><%= course.getCredits() %> credits</span>
            </div>
            <h4><%= course.getCourseName() %></h4>
            <p><%= course.getDescription() %></p>
            <p class="teacher">
                <i class="bi bi-person"></i> 
                <%= course.getTeacherName() != null ? course.getTeacherName() : "TBA" %>
            </p>
            <p class="capacity">
                <i class="bi bi-people"></i>
                <%= course.getEnrolledStudents() %>/<%= course.getMaxStudents() %> enrolled
            </p>
            
            <% if (alreadyEnrolled) { %>
                <button class="btn btn-secondary" disabled>
                    <i class="bi bi-check-circle"></i> Already Enrolled
                </button>
            <% } else if (course.getEnrolledStudents() >= course.getMaxStudents()) { %>
                <button class="btn btn-warning" disabled>
                    <i class="bi bi-x-circle"></i> Course Full
                </button>
            <% } else { %>
                <form method="post" action="${pageContext.request.contextPath}/student/register">
                    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Register
                    </button>
                </form>
            <% } %>
        </div>
    <% } %>
</div>
```

**Key logic:**
- Courses the student is already enrolled in show "Already Enrolled" (disabled)
- Full courses show "Course Full" (disabled)
- Available courses show active "Register" button

#### STEP 5: Student clicks "Register" button
```
POST /course-management-system-1.0.0/student/register
Content-Type: application/x-www-form-urlencoded

courseId=5
```

#### STEP 6: CourseRegistrationServlet.doPost() processes registration
**Lines:** 84-134

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    User currentUser = (User) session.getAttribute("currentUser");
    
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    
    // Check if already enrolled (server-side validation)
    List<Enrollment> existingEnrollments = enrollmentDAO.getEnrollmentsByStudent(currentUser.getUserId());
    boolean alreadyEnrolled = existingEnrollments.stream()
        .anyMatch(enrollment -> enrollment.getCourseId() == courseId);
    
    if (alreadyEnrolled) {
        request.setAttribute("errorMessage", "You are already enrolled in this course.");
    } else {
        // Create enrollment
        Enrollment enrollment = new Enrollment();
        enrollment.setStudentId(currentUser.getUserId());
        enrollment.setCourseId(courseId);
        
        boolean success = enrollmentDAO.createEnrollment(enrollment);
        if (success) {
            request.setAttribute("successMessage", "Successfully enrolled in the course!");
        } else {
            request.setAttribute("errorMessage", "Failed to enroll. Please try again.");
        }
    }
    
    // Reload the page with updated data
    doGet(request, response);
}
```

#### STEP 7: EnrollmentDAO.createEnrollment() inserts into database
```java
public boolean createEnrollment(Enrollment enrollment) {
    String sql = "INSERT INTO enrollments (student_id, course_id, status) VALUES (?, ?, 'ENROLLED')";
    
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setInt(1, enrollment.getStudentId());
    stmt.setInt(2, enrollment.getCourseId());
    
    return stmt.executeUpdate() > 0;
}
```

#### STEP 8: Page reloads with success message
Student sees:
- Success message: "Successfully enrolled in the course!"
- The course now shows "Already Enrolled" button (disabled)
- Enrolled count updated: "26/50 enrolled" → "27/50 enrolled"

---

## 🔄 QUICK REFERENCE: DATA FLOW DIAGRAM

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           USER ACTION                                    │
│                    (click button, submit form)                           │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        HTTP REQUEST                                      │
│              GET/POST /student/dashboard?action=register                 │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    FILTER (AuthenticationFilter)                         │
│         Check: Is user logged in? Does role match URL?                   │
│         If NO → redirect to login or 403 error                           │
│         If YES → continue                                                │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         SERVLET (Controller)                             │
│                    StudentDashboardServlet.doPost()                      │
│                                                                          │
│  1. Read parameters: request.getParameter("courseId")                    │
│  2. Validate input                                                       │
│  3. Call DAO methods                                                     │
│  4. Set success/error message                                            │
│  5. Forward to JSP or redirect                                           │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           DAO (Data Access)                              │
│                    EnrollmentDAO.createEnrollment()                      │
│                                                                          │
│  1. Build SQL: INSERT INTO enrollments (...)                             │
│  2. Create PreparedStatement                                             │
│  3. Set parameters safely                                                │
│  4. Execute query                                                        │
│  5. Return success/failure                                               │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         DATABASE (MySQL)                                 │
│                                                                          │
│  INSERT INTO enrollments (student_id, course_id, status)                 │
│  VALUES (3, 5, 'ENROLLED')                                               │
│                                                                          │
│  → Returns: 1 row affected                                               │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      SERVLET (back)                                      │
│                                                                          │
│  request.setAttribute("successMessage", "Enrolled!");                    │
│  request.setAttribute("enrolledCourses", updatedList);                   │
│  request.getRequestDispatcher("/student/dashboard.jsp").forward(...)     │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           JSP (View)                                     │
│                      student/dashboard.jsp                               │
│                                                                          │
│  <c:if test="${not empty successMessage}">                               │
│      <div class="alert alert-success">${successMessage}</div>            │
│  </c:if>                                                                 │
│                                                                          │
│  <c:forEach items="${enrolledCourses}" var="e">                          │
│      <tr><td>${e.courseName}</td>...</tr>                                │
│  </c:forEach>                                                            │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        HTML RESPONSE                                     │
│              Rendered page sent back to browser                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

*Generated for CSE-446 Web Engineering Lab - Viva Preparation*
