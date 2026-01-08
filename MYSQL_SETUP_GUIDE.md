# 🗄️ MySQL Setup Guide for Course Management System

**Complete guide for setting up MySQL database for the Course Management application**

---

## 🔍 **Current Database Configuration**

Your application is configured with these database credentials:

### 📊 **Primary Configuration** (from `web.xml`):
```
Database: course_management_db
Username: courseapp  
Password: MyApp123@
Host: localhost:3306
```

### 🔄 **Fallback Configuration** (from `DatabaseConnection.java`):
```
Database: course_management_db
Username: root
Password: password
Host: localhost:3306
```

---

## 🛠️ **Complete MySQL Setup Process**

### Step 1: Access MySQL as Root
```bash
sudo mysql -u root -p
```
*Enter your MySQL root password when prompted*

### Step 2: Create Database and User
```sql
-- Create the course management database
CREATE DATABASE IF NOT EXISTS course_management_db 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create the dedicated user for the application
CREATE USER IF NOT EXISTS 'courseapp'@'localhost' IDENTIFIED BY 'MyApp123@';

-- Grant all privileges on the course_management_db to courseapp user
GRANT ALL PRIVILEGES ON course_management_db.* TO 'courseapp'@'localhost';

-- Apply the changes
FLUSH PRIVILEGES;

-- Verify user creation
SELECT User, Host FROM mysql.user WHERE User='courseapp';

-- Exit MySQL
EXIT;
```

### Step 3: Test the New User Connection
```bash
mysql -u courseapp -p course_management_db
```
*Enter password: `MyApp123@`*

### Step 4: Verify Database Structure
```sql
USE course_management_db;
SHOW TABLES;
DESCRIBE users;
DESCRIBE courses;
DESCRIBE enrollments;
EXIT;
```

---

## 🚀 **Alternative: Quick Setup Script**

Create and run this setup script:

```bash
#!/bin/bash
# Save as: setup_mysql.sh

echo "🗄️ Setting up MySQL for Course Management System..."

# Prompt for MySQL root password
read -s -p "Enter MySQL root password: " ROOT_PASSWORD
echo

# Create database and user
mysql -u root -p$ROOT_PASSWORD << 'EOF'
CREATE DATABASE IF NOT EXISTS course_management_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'courseapp'@'localhost' IDENTIFIED BY 'MyApp123@';
GRANT ALL PRIVILEGES ON course_management_db.* TO 'courseapp'@'localhost';
FLUSH PRIVILEGES;
SELECT 'Database and user created successfully!' AS Status;
EOF

echo "✅ MySQL setup complete!"
echo "📊 Database: course_management_db"
echo "👤 Username: courseapp"
echo "🔑 Password: MyApp123@"
```

---

## 🔧 **Database Schema Auto-Creation**

Your application will **automatically create tables** when it first runs:

### 📋 **Tables Created:**
1. **`users`** - Stores user accounts (admin, teachers, students)
2. **`courses`** - Stores course information  
3. **`enrollments`** - Stores student-course relationships

### 👥 **Default Users Created:**
| Username | Password | Role | Full Name |
|----------|----------|------|-----------|
| `admin` | `password123` | ADMIN | System Administrator |
| `teacher1` | `password123` | TEACHER | Dr. John Smith |
| `teacher2` | `password123` | TEACHER | Prof. Sarah Johnson |
| `student1` | `password123` | STUDENT | Alice Cooper |
| `student2` | `password123` | STUDENT | Bob Wilson |
| `student3` | `password123` | STUDENT | Carol Davis |

---

## 🔍 **Troubleshooting Common Issues**

### Issue 1: "Access denied for user 'courseapp'"
**Solution:** The `courseapp` user doesn't exist yet
```bash
# Run the setup commands from Step 2 above
sudo mysql -u root -p
# Then create user and database
```

### Issue 2: "Unknown database 'course_management_db'"
**Solution:** Database hasn't been created yet
```sql
CREATE DATABASE course_management_db;
```

### Issue 3: "Can't connect to MySQL server"
**Solution:** MySQL service isn't running
```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```

### Issue 4: MySQL root password unknown
**Solution:** Reset MySQL root password
```bash
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_new_password';
FLUSH PRIVILEGES;
EXIT;
```

---

## 🎯 **Verification Steps**

### ✅ **Check if MySQL User Exists:**
```sql
SELECT User, Host FROM mysql.user WHERE User='courseapp';
```

### ✅ **Check if Database Exists:**
```sql
SHOW DATABASES LIKE 'course_management_db';
```

### ✅ **Check User Permissions:**
```sql
SHOW GRANTS FOR 'courseapp'@'localhost';
```

### ✅ **Test Application Connection:**
1. Start your application
2. Check Tomcat logs for "Database initialized successfully"
3. Try logging in at: `http://localhost:8080/course-management-system-1.0.0/`

---

## 🔐 **Security Notes**

1. **Password Policy**: The password `MyApp123@` meets MySQL's default policy
2. **User Privileges**: `courseapp` user only has access to `course_management_db`
3. **Network Access**: User is restricted to `localhost` connections only
4. **Production Setup**: For production, use environment variables for credentials

---

## 📱 **Quick Commands Reference**

```bash
# Start MySQL
sudo systemctl start mysql

# Stop MySQL  
sudo systemctl stop mysql

# Check MySQL status
sudo systemctl status mysql

# Connect as courseapp user
mysql -u courseapp -p course_management_db

# Connect as root
sudo mysql -u root -p

# View MySQL error log
sudo tail -f /var/log/mysql/error.log
```

---

## 🎉 **Success!**

Once MySQL is properly configured:
- ✅ Application connects automatically
- ✅ Tables are created on first run
- ✅ Default users are populated
- ✅ Ready for development and testing

**Your Course Management System database is ready! 🚀**
