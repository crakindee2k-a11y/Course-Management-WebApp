package com.coursemanagement.model;

/**
 * User model class representing users in the system.
 * Stores user data: credentials, profile info, and role.
 */
public class User {
    
    /** User roles in the system */
    public enum UserType {
        STUDENT,
        TEACHER,
        ADMIN
    }
    
    private int userId;
    private String username;
    private String password;  // BCrypt hashed
    private String fullName;
    private String email;
    private UserType userType;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;
    
    /** Default constructor */
    public User() {}
    
    /** Full constructor with all fields */
    public User(int userId, String username, String password, String fullName, 
                String email, UserType userType) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.userType = userType;
    }
    
    /** Constructor for new users (no userId yet) */
    public User(String username, String password, String fullName, 
                String email, UserType userType) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.userType = userType;
    }
    
    // Getters and Setters
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public UserType getUserType() { return userType; }
    public void setUserType(UserType userType) { this.userType = userType; }
    
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    // Role check helpers
    public boolean isAdmin() { return this.userType == UserType.ADMIN; }
    public boolean isTeacher() { return this.userType == UserType.TEACHER; }
    public boolean isStudent() { return this.userType == UserType.STUDENT; }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", userType=" + userType +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        User user = (User) obj;
        return userId == user.userId && username.equals(user.username);
    }
    
    @Override
    public int hashCode() {
        return username != null ? username.hashCode() : 0;
    }
}
