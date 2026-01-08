package com.coursemanagement.model;

/**
 * Course model class representing courses in the system.
 */
public class Course {
    
    private int courseId;
    private String courseCode;
    private String courseName;
    private String description;
    private int credits;
    private int teacherId;
    private String teacherName;  // Cached for display
    private int maxStudents;
    private int enrolledStudents;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;
    
    /** Default constructor */
    public Course() {}
    
    /** Full constructor */
    public Course(int courseId, String courseCode, String courseName, 
                  String description, int credits, int teacherId, int maxStudents) {
        this.courseId = courseId;
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.description = description;
        this.credits = credits;
        this.teacherId = teacherId;
        this.maxStudents = maxStudents;
        this.enrolledStudents = 0;
    }
    
    /** Constructor for new courses (no courseId) */
    public Course(String courseCode, String courseName, String description, 
                  int credits, int teacherId, int maxStudents) {
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.description = description;
        this.credits = credits;
        this.teacherId = teacherId;
        this.maxStudents = maxStudents;
        this.enrolledStudents = 0;
    }
    
    // Getters and Setters
    
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    
    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }
    
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }
    
    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }
    
    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }
    
    public int getMaxStudents() { return maxStudents; }
    public void setMaxStudents(int maxStudents) { this.maxStudents = maxStudents; }
    
    public int getEnrolledStudents() { return enrolledStudents; }
    public void setEnrolledStudents(int enrolledStudents) { this.enrolledStudents = enrolledStudents; }
    
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    // Utility methods
    
    public boolean hasAvailableSlots() { return enrolledStudents < maxStudents; }
    public int getAvailableSlots() { return maxStudents - enrolledStudents; }
    public double getEnrollmentPercentage() {
        if (maxStudents == 0) return 0.0;
        return ((double) enrolledStudents / maxStudents) * 100.0;
    }
    
    @Override
    public String toString() {
        return "Course{" +
                "courseId=" + courseId +
                ", courseCode='" + courseCode + '\'' +
                ", courseName='" + courseName + '\'' +
                ", credits=" + credits +
                ", teacherId=" + teacherId +
                ", maxStudents=" + maxStudents +
                ", enrolledStudents=" + enrolledStudents +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Course course = (Course) obj;
        return courseId == course.courseId && courseCode.equals(course.courseCode);
    }
    
    @Override
    public int hashCode() {
        return courseCode != null ? courseCode.hashCode() : 0;
    }
}
