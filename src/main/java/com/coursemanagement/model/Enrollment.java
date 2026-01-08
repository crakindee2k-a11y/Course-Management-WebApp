package com.coursemanagement.model;

/**
 * Enrollment model class representing student enrollments in courses.
 * 
 * This class represents the many-to-many relationship between students and courses.
 * It tracks when students register for courses and their enrollment status.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class Enrollment {
    
    /**
     * Enumeration for enrollment status
     */
    public enum EnrollmentStatus {
        ENROLLED, DROPPED, COMPLETED, PENDING
    }
    
    private int enrollmentId;
    private int studentId; // Foreign key to User table
    private int courseId; // Foreign key to Course table
    private EnrollmentStatus status;
    private java.sql.Timestamp enrollmentDate;
    private java.sql.Timestamp lastUpdated;
    
    // Additional fields for display purposes (cached data)
    private String studentName;
    private String studentEmail;
    private String courseCode;
    private String courseName;
    private String teacherName;
    
    /**
     * Default constructor
     */
    public Enrollment() {
        this.status = EnrollmentStatus.ENROLLED;
    }
    
    /**
     * Constructor with main fields
     * 
     * @param enrollmentId The unique enrollment ID
     * @param studentId The ID of the enrolled student
     * @param courseId The ID of the course
     * @param status The enrollment status
     */
    public Enrollment(int enrollmentId, int studentId, int courseId, EnrollmentStatus status) {
        this.enrollmentId = enrollmentId;
        this.studentId = studentId;
        this.courseId = courseId;
        this.status = status;
    }
    
    /**
     * Constructor without enrollmentId (for creating new enrollments)
     */
    public Enrollment(int studentId, int courseId) {
        this.studentId = studentId;
        this.courseId = courseId;
        this.status = EnrollmentStatus.ENROLLED;
    }
    
    /**
     * Constructor with status
     */
    public Enrollment(int studentId, int courseId, EnrollmentStatus status) {
        this.studentId = studentId;
        this.courseId = courseId;
        this.status = status;
    }
    
    // Getter and Setter methods
    
    /**
     * Gets the enrollment ID
     * @return The enrollment ID
     */
    public int getEnrollmentId() {
        return enrollmentId;
    }
    
    /**
     * Sets the enrollment ID
     * @param enrollmentId The enrollment ID to set
     */
    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }
    
    /**
     * Gets the student ID
     * @return The student ID
     */
    public int getStudentId() {
        return studentId;
    }
    
    /**
     * Sets the student ID
     * @param studentId The student ID to set
     */
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    /**
     * Gets the course ID
     * @return The course ID
     */
    public int getCourseId() {
        return courseId;
    }
    
    /**
     * Sets the course ID
     * @param courseId The course ID to set
     */
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
    
    /**
     * Gets the enrollment status
     * @return The enrollment status
     */
    public EnrollmentStatus getStatus() {
        return status;
    }
    
    /**
     * Sets the enrollment status
     * @param status The enrollment status to set
     */
    public void setStatus(EnrollmentStatus status) {
        this.status = status;
    }
    
    /**
     * Gets the enrollment date
     * @return The enrollment date
     */
    public java.sql.Timestamp getEnrollmentDate() {
        return enrollmentDate;
    }
    
    /**
     * Sets the enrollment date
     * @param enrollmentDate The enrollment date to set
     */
    public void setEnrollmentDate(java.sql.Timestamp enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }
    
    /**
     * Gets the last updated timestamp
     * @return The last updated timestamp
     */
    public java.sql.Timestamp getLastUpdated() {
        return lastUpdated;
    }
    
    /**
     * Sets the last updated timestamp
     * @param lastUpdated The last updated timestamp to set
     */
    public void setLastUpdated(java.sql.Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    /**
     * Gets the student name (cached for display)
     * @return The student name
     */
    public String getStudentName() {
        return studentName;
    }
    
    /**
     * Sets the student name
     * @param studentName The student name to set
     */
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    /**
     * Gets the student email (cached for display)
     * @return The student email
     */
    public String getStudentEmail() {
        return studentEmail;
    }
    
    /**
     * Sets the student email
     * @param studentEmail The student email to set
     */
    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }
    
    /**
     * Gets the course code (cached for display)
     * @return The course code
     */
    public String getCourseCode() {
        return courseCode;
    }
    
    /**
     * Sets the course code
     * @param courseCode The course code to set
     */
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
    
    /**
     * Gets the course name (cached for display)
     * @return The course name
     */
    public String getCourseName() {
        return courseName;
    }
    
    /**
     * Sets the course name
     * @param courseName The course name to set
     */
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    /**
     * Gets the teacher name
     * 
     * @return The teacher name
     */
    public String getTeacherName() {
        return teacherName;
    }
    
    /**
     * Sets the teacher name
     * 
     * @param teacherName The teacher name
     */
    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
    
    /**
     * Checks if the enrollment is active
     * @return true if the enrollment is active, false otherwise
     */
    public boolean isActive() {
        return status == EnrollmentStatus.ENROLLED || status == EnrollmentStatus.PENDING;
    }
    
    /**
     * Checks if the enrollment is completed
     * @return true if the enrollment is completed, false otherwise
     */
    public boolean isCompleted() {
        return status == EnrollmentStatus.COMPLETED;
    }
    
    /**
     * Checks if the enrollment is dropped
     * @return true if the enrollment is dropped, false otherwise
     */
    public boolean isDropped() {
        return status == EnrollmentStatus.DROPPED;
    }
    
    /**
     * Gets the status as a display-friendly string
     * @return The status as a string
     */
    public String getStatusDisplay() {
        switch (status) {
            case ENROLLED:
                return "Enrolled";
            case DROPPED:
                return "Dropped";
            case COMPLETED:
                return "Completed";
            case PENDING:
                return "Pending";
            default:
                return status.toString();
        }
    }
    
    @Override
    public String toString() {
        return "Enrollment{" +
                "enrollmentId=" + enrollmentId +
                ", studentId=" + studentId +
                ", courseId=" + courseId +
                ", status=" + status +
                ", enrollmentDate=" + enrollmentDate +
                ", lastUpdated=" + lastUpdated +
                ", studentName='" + studentName + '\'' +
                ", studentEmail='" + studentEmail + '\'' +
                ", courseCode='" + courseCode + '\'' +
                ", courseName='" + courseName + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Enrollment that = (Enrollment) obj;
        return studentId == that.studentId && 
               courseId == that.courseId;
    }
    
    @Override
    public int hashCode() {
        int result = studentId;
        result = 31 * result + courseId;
        return result;
    }
}
