package com.coursemanagement.util;

import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletContext;

/**
 * Database connection utility for MySQL.
 * Loads configuration from servlet context and provides pooled connections.
 */
public class DatabaseConnection {
    
    private static final String DEFAULT_DB_URL = "jdbc:mysql://localhost:3306/course_management_db";
    private static final String DEFAULT_USERNAME = "root";
    private static final String DEFAULT_PASSWORD = "password";
    
    // Database configuration
    private static String dbUrl;
    private static String dbUsername;
    private static String dbPassword;
    
    /**
     * Initialize database configuration from servlet context
     * 
     * @param context The servlet context containing database parameters
     */
    public static void initialize(ServletContext context) {
        loadConfiguration(context);
        
        // Load MySQL JDBC driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            throw new RuntimeException("Failed to load MySQL JDBC driver", e);
        }
    }
    
    /**
     * Loads configuration from environment variables (Railway, Docker, etc.)
     * with servlet context and project defaults as fallbacks.
     */
    private static void loadConfiguration(ServletContext context) {
        // Highest priority: environment variables / DATABASE_URL style strings
        applyDatabaseUrlFromEnv();
        
        // Direct environment overrides for URL, username, and password
        if (dbUrl == null) {
            String directUrl = getFirstNonEmptyEnv(
                "JDBC_DATABASE_URL",
                "DB_URL"
            );
            if (directUrl != null) {
                dbUrl = normalizeJdbcUrl(directUrl);
            }
        }
        
        if (dbUrl == null) {
            String host = getFirstNonEmptyEnv("MYSQLHOST", "MYSQL_HOST");
            String database = getFirstNonEmptyEnv("MYSQLDATABASE", "MYSQL_DB", "DB_NAME");
            String port = getFirstNonEmptyEnv("MYSQLPORT", "MYSQL_PORT");
            if (host != null && database != null) {
                dbUrl = buildJdbcUrl(host, port != null ? port : "3306", database);
            }
        }
        
        if (dbUsername == null) {
            dbUsername = getFirstNonEmptyEnv(
                "JDBC_DATABASE_USERNAME",
                "DB_USERNAME",
                "DATABASE_USERNAME",
                "MYSQLUSER",
                "MYSQL_USER"
            );
        }
        
        if (dbPassword == null) {
            dbPassword = getFirstNonEmptyEnv(
                "JDBC_DATABASE_PASSWORD",
                "DB_PASSWORD",
                "DATABASE_PASSWORD",
                "MYSQLPASSWORD",
                "MYSQL_PASSWORD"
            );
        }
        
        // Fallback to servlet context parameters if still missing
        if (context != null) {
            if (dbUrl == null) {
                dbUrl = context.getInitParameter("DB_URL");
            }
            if (dbUsername == null) {
                dbUsername = context.getInitParameter("DB_USERNAME");
            }
            if (dbPassword == null) {
                dbPassword = context.getInitParameter("DB_PASSWORD");
            }
        }
        
        // Project defaults as last resort
        if (dbUrl == null) dbUrl = DEFAULT_DB_URL;
        if (dbUsername == null) dbUsername = DEFAULT_USERNAME;
        if (dbPassword == null) dbPassword = DEFAULT_PASSWORD;
    }
    
    /**
     * Reads DATABASE_URL style environment variables and maps them to JDBC.
     */
    private static void applyDatabaseUrlFromEnv() {
        String[] databaseUrlKeys = {"DATABASE_URL"};
        String rawUrl = getFirstNonEmptyEnv(databaseUrlKeys);
        
        if (rawUrl == null) {
            return;
        }
        
        if (rawUrl.startsWith("jdbc:")) {
            dbUrl = rawUrl;
            return;
        }
        
        try {
            URI uri = new URI(rawUrl);
            if ("mysql".equalsIgnoreCase(uri.getScheme())) {
                String host = uri.getHost();
                int port = uri.getPort();
                String path = uri.getPath() != null ? uri.getPath() : "";
                String query = uri.getQuery();
                
                StringBuilder jdbc = new StringBuilder("jdbc:mysql://");
                jdbc.append(host != null ? host : "localhost");
                if (port > 0) {
                    jdbc.append(":").append(port);
                }
                jdbc.append(path);
                if (query != null && !query.isEmpty()) {
                    jdbc.append("?").append(query);
                }
                dbUrl = jdbc.toString();
                
                String userInfo = uri.getUserInfo();
                if (userInfo != null) {
                    String[] parts = userInfo.split(":", 2);
                    if (dbUsername == null) {
                        dbUsername = parts[0];
                    }
                    if (parts.length > 1 && dbPassword == null) {
                        dbPassword = parts[1];
                    }
                }
            } else {
                dbUrl = rawUrl;
            }
        } catch (URISyntaxException e) {
            dbUrl = rawUrl;
        }
    }
    
    private static String normalizeJdbcUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.isEmpty()) {
            return null;
        }
        if (rawUrl.startsWith("jdbc:")) {
            return rawUrl;
        }
        if (rawUrl.startsWith("mysql://")) {
            return rawUrl.replaceFirst("mysql://", "jdbc:mysql://");
        }
        return rawUrl;
    }
    
    private static String buildJdbcUrl(String host, String port, String database) {
        StringBuilder builder = new StringBuilder("jdbc:mysql://").append(host);
        if (port != null && !port.isEmpty()) {
            builder.append(":").append(port);
        }
        builder.append("/").append(database);
        return builder.toString();
    }
    
    private static String getFirstNonEmptyEnv(String... keys) {
        for (String key : keys) {
            String value = System.getenv(key);
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return null;
    }
    
    /**
     * Gets a connection to the database using connection pooling
     * 
     * @return A database connection from the pool
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        if (dbUrl == null) {
            // Initialize with default values if not already initialized
            dbUrl = DEFAULT_DB_URL;
            dbUsername = DEFAULT_USERNAME;
            dbPassword = DEFAULT_PASSWORD;
        }
        
        // Use connection pool for better performance
        ConnectionPool pool = ConnectionPool.getInstance(dbUrl, dbUsername, dbPassword);
        return pool.getConnection();
    }
    
    /**
     * Creates the database and tables if they don't exist
     * This method should be called during application startup
     */
    public static void initializeDatabase() {
        try {
            // First, connect to MySQL server without specifying database
            String serverUrl = dbUrl.substring(0, dbUrl.lastIndexOf('/'));
            Connection serverConn = DriverManager.getConnection(serverUrl, dbUsername, dbPassword);
            
            // Create database if it doesn't exist
            createDatabaseIfNotExists(serverConn);
            serverConn.close();
            
            // Now connect to the specific database and create tables
            Connection dbConn = getConnection();
            createTablesIfNotExist(dbConn);
            insertDefaultData(dbConn);
            dbConn.close();
            
            System.out.println("Database initialized successfully");
            
        } catch (SQLException e) {
            System.err.println("Failed to initialize database: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Creates the database if it doesn't exist
     * 
     * @param connection Connection to MySQL server
     * @throws SQLException if database creation fails
     */
    private static void createDatabaseIfNotExists(Connection connection) throws SQLException {
        String databaseName = dbUrl.substring(dbUrl.lastIndexOf('/') + 1);
        Statement stmt = connection.createStatement();
        
        String createDbSql = "CREATE DATABASE IF NOT EXISTS " + databaseName + 
                           " CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
        
        stmt.executeUpdate(createDbSql);
        stmt.close();
        
        System.out.println("Database '" + databaseName + "' created or already exists");
    }
    
    /**
     * Creates the necessary tables if they don't exist
     * 
     * @param connection Database connection
     * @throws SQLException if table creation fails
     */
    private static void createTablesIfNotExist(Connection connection) throws SQLException {
        Statement stmt = connection.createStatement();
        
        // Create users table
        String createUsersTable = "CREATE TABLE IF NOT EXISTS users (" +
            "user_id INT PRIMARY KEY AUTO_INCREMENT, " +
            "username VARCHAR(50) UNIQUE NOT NULL, " +
            "password VARCHAR(255) NOT NULL, " +
            "full_name VARCHAR(100) NOT NULL, " +
            "email VARCHAR(100) UNIQUE NOT NULL, " +
            "user_type ENUM('STUDENT', 'TEACHER', 'ADMIN') NOT NULL, " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
            ")";
        
        // Create courses table
        String createCoursesTable = "CREATE TABLE IF NOT EXISTS courses (" +
            "course_id INT PRIMARY KEY AUTO_INCREMENT, " +
            "course_code VARCHAR(20) UNIQUE NOT NULL, " +
            "course_name VARCHAR(100) NOT NULL, " +
            "description TEXT, " +
            "credits INT DEFAULT 3, " +
            "teacher_id INT, " +
            "max_students INT DEFAULT 50, " +
            "enrolled_students INT DEFAULT 0, " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
            "FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE SET NULL" +
            ")";
        
        // Create enrollments table
        String createEnrollmentsTable = "CREATE TABLE IF NOT EXISTS enrollments (" +
            "enrollment_id INT PRIMARY KEY AUTO_INCREMENT, " +
            "student_id INT NOT NULL, " +
            "course_id INT NOT NULL, " +
            "status ENUM('ENROLLED', 'DROPPED', 'COMPLETED', 'PENDING') DEFAULT 'ENROLLED', " +
            "enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
            "FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE, " +
            "FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE, " +
            "UNIQUE KEY unique_enrollment (student_id, course_id)" +
            ")";
        
        // Execute table creation
        stmt.executeUpdate(createUsersTable);
        System.out.println("Users table created or already exists");
        
        stmt.executeUpdate(createCoursesTable);
        System.out.println("Courses table created or already exists");
        
        stmt.executeUpdate(createEnrollmentsTable);
        System.out.println("Enrollments table created or already exists");
        
        stmt.close();
    }
    
    /**
     * Inserts default data for testing purposes
     * 
     * @param connection Database connection
     * @throws SQLException if data insertion fails
     */
    private static void insertDefaultData(Connection connection) throws SQLException {
        Statement stmt = connection.createStatement();
        
        // Insert default users (passwords are BCrypt hashed version of "password123")
        String defaultPasswordHash = PasswordUtil.hashPassword("password123");
        String insertDefaultUsers = "INSERT IGNORE INTO users (username, password, full_name, email, user_type) VALUES " +
            "('admin', '" + defaultPasswordHash + "', 'System Administrator', 'admin@coursemanagement.com', 'ADMIN'), " +
            "('teacher1', '" + defaultPasswordHash + "', 'Dr. John Smith', 'john.smith@university.edu', 'TEACHER'), " +
            "('teacher2', '" + defaultPasswordHash + "', 'Prof. Sarah Johnson', 'sarah.johnson@university.edu', 'TEACHER'), " +
            "('student1', '" + defaultPasswordHash + "', 'Alice Cooper', 'alice.cooper@student.edu', 'STUDENT'), " +
            "('student2', '" + defaultPasswordHash + "', 'Bob Wilson', 'bob.wilson@student.edu', 'STUDENT'), " +
            "('student3', '" + defaultPasswordHash + "', 'Carol Davis', 'carol.davis@student.edu', 'STUDENT')";
        
        // Insert sample courses
        String insertSampleCourses = "INSERT IGNORE INTO courses (course_code, course_name, description, credits, teacher_id, max_students) VALUES " +
            "('CSE-446', 'Web Engineering', 'Introduction to web development technologies including HTML, CSS, JavaScript, and server-side programming', 3, 2, 30), " +
            "('CSE-101', 'Programming Fundamentals', 'Basic programming concepts using Java programming language', 4, 2, 40), " +
            "('CSE-201', 'Data Structures', 'Implementation and analysis of fundamental data structures and algorithms', 3, 3, 35), " +
            "('CSE-301', 'Database Systems', 'Design and implementation of database management systems', 3, 3, 25)";
        
        stmt.executeUpdate(insertDefaultUsers);
        System.out.println("Default users inserted");

        String ensureDefaultPasswords = "UPDATE users SET password = '" + defaultPasswordHash + "' " +
            "WHERE username IN ('admin','teacher1','teacher2','student1','student2','student3')";
        stmt.executeUpdate(ensureDefaultPasswords);
        
        stmt.executeUpdate(insertSampleCourses);
        System.out.println("Sample courses inserted");
        
        stmt.close();
    }
    
    /**
     * Tests the database connection
     * 
     * @return true if connection is successful, false otherwise
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Gets the current database URL
     * @return The database URL
     */
    public static String getDbUrl() {
        return dbUrl;
    }
    
    /**
     * Gets the current database username
     * @return The database username
     */
    public static String getDbUsername() {
        return dbUsername;
    }
}
