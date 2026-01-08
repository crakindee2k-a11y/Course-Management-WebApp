# 🚀 How to Run This Project on Linux (Clean Setup)

Follow these simple steps to run the Course Management System on any Linux computer.

## ✅ Prerequisites

Make sure the computer has:
1. **Java JDK 11 or higher** (Run `java -version` to check)
2. **MySQL Server** (Run `mysql --version` to check)
3. **Eclipse IDE for Enterprise Java** (optional, but recommended)
4. **Apache Tomcat 9** (optional, if not using Eclipse)

---

## 1️⃣ Prepare the Database

Since this is a fresh start, you just need to create the database. The application will automatically create the tables for you.

Open your terminal and run these commands one by one:

```bash
# Log in to MySQL as root
sudo mysql -u root -p

# (Enter your root password when asked)
```

Copy and paste these lines into the MySQL shell:

```sql
CREATE DATABASE course_management_db;
CREATE USER IF NOT EXISTS 'courseapp'@'localhost' IDENTIFIED BY 'MyApp123@';
GRANT ALL PRIVILEGES ON course_management_db.* TO 'courseapp'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

**Note:** The application is configured to use the username `courseapp` and password `MyApp123@`. Creating this specific user avoids the need to change any code!

---

## 2️⃣ Import Project into Eclipse

1. **Open Eclipse IDE.**
2. Go to **File** → **Import...**
3. Select **Maven** → **Existing Maven Projects** and click **Next**.
4. Click **Browse** and select the `Web Lab Project` folder (the one you unzipped).
5. Ensure the `pom.xml` file is checked and click **Finish**.
6. Wait for Eclipse to download the dependencies (look at the bottom right corner).

---

## 3️⃣ Configure the Server (Tomcat)

1. If you don't have a "Servers" tab at the bottom, go to:
   **Window** → **Show View** → **Other...** → Type "Servers" → Select it → **Open**.
2. Click the link **"No servers are available. Click this link to create a new server..."**
3. Select **Apache** → **Tomcat v9.0 Server**.
4. Click **Next**.
5. If "Tomcat installation directory" is empty, click **Download and Install** (or browse to where you installed it).
6. Click **Finish**.

---

## 4️⃣ Run the Application

1. In the **Servers** tab, you will see "Tomcat v9.0 Server at localhost".
2. **Right-click** on the server → **Add and Remove...**
3. Select `course-management-system` from the left list and click **Add >** to move it to the right.
4. Click **Finish**.
5. **Right-click** the server again → **Start**.
6. Once started, open your web browser and go to:
   👉 **http://localhost:8080/course-management-system/**

---

## 🔑 Login Credentials

Use these default accounts to test the system:

| Role | Username | Password |
|:-----|:---------|:---------|
| **Admin** | `admin` | `password123` |
| **Teacher** | `teacher1` | `password123` |
| **Student** | `student1` | `password123` |

---

## ❓ Troubleshooting

### Error: "Port 8080 already in use"
- Double-click the Tomcat server in Eclipse.
- Change "HTTP/1.1" port from `8080` to `8081`.
- Save (`Ctrl+S`) and restart the server.
- New URL: `http://localhost:8081/course-management-system/`

### Error: "Database connection failed"
- Ensure MySQL service is running: `sudo systemctl start mysql`
- Verify the user was created correctly in step 1.
- Check that MySQL is listening on port 3306: `sudo netstat -tuln | grep 3306`

### Error: "404 Not Found"
- Make sure you're accessing the correct URL with the context path
- Verify the server started successfully (check Console tab in Eclipse)
- Ensure the project was properly added to the server

### Error: "Maven dependencies not downloading"
- Check your internet connection
- Right-click project → **Maven** → **Update Project** → Check "Force Update"
- Try: **Maven** → **Update Maven Project** with "Force Update of Snapshots/Releases" checked

### Database Tables Not Created
- The application uses JPA/Hibernate to auto-create tables
- Check `persistence.xml` has `hibernate.hbm2ddl.auto` set to `update` or `create`
- Look at server logs for any database errors

---

## 📝 Additional Information

### Project Structure
```
Web Lab Project/
├── src/
│   ├── main/
│   │   ├── java/          # Java source code
│   │   ├── resources/     # Configuration files
│   │   └── webapp/        # JSP, CSS, JS files
│   └── test/              # Test files
├── pom.xml                # Maven configuration
└── README.md              # Project documentation
```

### Technology Stack
- **Backend:** Java 11, Servlets, JPA/Hibernate
- **Frontend:** JSP, Bootstrap 5, JavaScript
- **Database:** MySQL 8.0
- **Build Tool:** Maven
- **Server:** Apache Tomcat 9

### Database Configuration
The database settings are configured in `src/main/resources/META-INF/persistence.xml`:
```xml
<property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/course_management_db"/>
<property name="javax.persistence.jdbc.user" value="courseapp"/>
<property name="javax.persistence.jdbc.password" value="MyApp123@"/>
```

If you need to change these, edit the `persistence.xml` file.

---

## 🎯 Features

This Course Management System includes:

### Admin Features
- ✅ User management (Create, Edit, Delete students, teachers, admins)
- ✅ Course management (Add, Edit, Delete courses)
- ✅ Assign teachers to courses
- ✅ Bulk import users and courses via Excel/CSV
- ✅ View all enrollments
- ✅ Dashboard with statistics

### Teacher Features
- ✅ View assigned courses
- ✅ View enrolled students per course
- ✅ View all students in the system
- ✅ Dashboard with teaching statistics

### Student Features
- ✅ Browse available courses
- ✅ Register for courses
- ✅ View enrolled courses
- ✅ Dashboard with enrollment statistics

### General Features
- ✅ Secure login/logout
- ✅ Role-based access control
- ✅ Dark/Light theme toggle
- ✅ Responsive design
- ✅ Profile management

---

## 🔧 Development Tips

### Running with Maven (Without Eclipse)
```bash
# Build the project
mvn clean package

# Deploy the WAR file to Tomcat manually
# Copy target/course-management-system-1.0.0.war to Tomcat's webapps folder
cp target/course-management-system-1.0.0.war /path/to/tomcat/webapps/
```

### Viewing Logs
- **Eclipse Console:** Shows application logs in real-time
- **Tomcat Logs:** Usually in `$TOMCAT_HOME/logs/catalina.out`

### Database Management
```bash
# Access MySQL to view data
mysql -u courseapp -p course_management_db

# View all tables
SHOW TABLES;

# View users
SELECT * FROM users;

# View courses
SELECT * FROM courses;
```

---

## 📚 Next Steps

After successfully running the application:

1. **Explore the Admin Panel** - Login as admin and try creating users and courses
2. **Test Student Enrollment** - Register students for courses
3. **Assign Teachers** - Link teachers to specific courses
4. **Try Bulk Import** - Use the bulk import feature with CSV/Excel files
5. **Customize** - Modify the code to add your own features

---

## 🐛 Common Issues & Solutions

### Issue: Maven Build Fails
**Solution:**
```bash
# Clean Maven cache
rm -rf ~/.m2/repository

# Rebuild
mvn clean install -U
```

### Issue: Hibernate Error "Table doesn't exist"
**Solution:**
- Check `persistence.xml` has: `<property name="hibernate.hbm2ddl.auto" value="update"/>`
- Verify database connection is working
- Check MySQL user has proper permissions

### Issue: CSS/JS Files Not Loading
**Solution:**
- Clear browser cache (Ctrl + Shift + Delete)
- Check browser console (F12) for 404 errors
- Verify files exist in `src/main/webapp/css/` and `src/main/webapp/js/`

### Issue: Login Fails
**Solution:**
- Check database has default users
- Verify `password123` is correctly hashed in the database
- Look at server logs for authentication errors

---

## 🔒 Security Notes

**⚠️ IMPORTANT FOR PRODUCTION:**

This is a development/educational project. For production use:

1. **Change default passwords** - Don't use `password123`
2. **Use environment variables** - Don't hardcode database credentials
3. **Enable HTTPS** - Use SSL/TLS certificates
4. **Add input validation** - Prevent SQL injection and XSS
5. **Implement CSRF protection** - Add tokens to forms
6. **Use prepared statements** - JPA/Hibernate already does this
7. **Hash passwords properly** - Use bcrypt with salt
8. **Add rate limiting** - Prevent brute force attacks
9. **Sanitize file uploads** - Validate file types in bulk import
10. **Regular updates** - Keep dependencies up to date

---

## 📞 Support

If you encounter issues not covered in this guide:

1. Check the **server logs** in Eclipse Console
2. Look at **browser console** (F12) for JavaScript errors
3. Verify **database connection** using MySQL Workbench or command line
4. Review **Maven dependencies** in `pom.xml`
5. Search for error messages online (Stack Overflow is your friend!)

---

## 📄 License

This project is for educational purposes. Feel free to modify and use it for learning.

---

**Last Updated:** December 13, 2025
**Version:** 1.0.0
**Compatible with:** Linux (Ubuntu, Debian, Fedora, etc.)

---

## 🎉 Success!

If you followed all the steps correctly, you should now have a fully functional Course Management System running on your Linux machine!

**Access the application at:** http://localhost:8080/course-management-system/

**Default login:** admin / password123

Happy coding! 🚀
