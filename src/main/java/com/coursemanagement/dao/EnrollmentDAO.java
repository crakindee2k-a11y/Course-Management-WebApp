package com.coursemanagement.dao;

import com.coursemanagement.model.Enrollment;
import com.coursemanagement.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for Enrollment entity.
 * 
 * This class handles all database operations related to student enrollments
 * including registration, dropping courses, and enrollment management.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class EnrollmentDAO {
    
    /**
     * Enrolls a student in a course
     * 
     * @param studentId The student's user ID
     * @param courseId The course ID
     * @return The enrollment ID if successful, -1 if failed
     */
    public int enrollStudent(int studentId, int courseId) {
        // First check if student is already enrolled
        if (isStudentEnrolled(studentId, courseId)) {
            System.out.println("Student is already enrolled in this course");
            return -1;
        }
        
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Check if course has available slots
            String checkSql = "SELECT max_students, enrolled_students FROM courses WHERE course_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, courseId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        int maxStudents = rs.getInt("max_students");
                        int enrolledStudents = rs.getInt("enrolled_students");
                        
                        if (enrolledStudents >= maxStudents) {
                            System.out.println("Course is full, cannot enroll student");
                            conn.rollback();
                            return -1;
                        }
                    } else {
                        System.out.println("Course not found");
                        conn.rollback();
                        return -1;
                    }
                }
            }
            
            // Insert enrollment record
            String insertSql = "INSERT INTO enrollments (student_id, course_id, status) VALUES (?, ?, 'ENROLLED')";
            int enrollmentId = -1;
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                insertStmt.setInt(1, studentId);
                insertStmt.setInt(2, courseId);
                
                int affectedRows = insertStmt.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = insertStmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            enrollmentId = generatedKeys.getInt(1);
                        }
                    }
                }
            }
            
            // Update course enrollment count
            if (enrollmentId > 0) {
                String updateSql = "UPDATE courses SET enrolled_students = enrolled_students + 1 WHERE course_id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, courseId);
                    updateStmt.executeUpdate();
                }
            }
            
            conn.commit(); // Commit transaction
            return enrollmentId;
            
        } catch (SQLException e) {
            System.err.println("Error enrolling student: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
        
        return -1;
    }
    
    /**
     * Drops a student from a course
     * 
     * @param studentId The student's user ID
     * @param courseId The course ID
     * @return true if successful, false otherwise
     */
    public boolean dropStudent(int studentId, int courseId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Update enrollment status to DROPPED
            String updateSql = "UPDATE enrollments SET status = 'DROPPED', last_updated = CURRENT_TIMESTAMP " +
                              "WHERE student_id = ? AND course_id = ? AND status = 'ENROLLED'";
            int affectedRows = 0;
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setInt(1, studentId);
                updateStmt.setInt(2, courseId);
                affectedRows = updateStmt.executeUpdate();
            }
            
            // If enrollment was updated, decrease course enrollment count
            if (affectedRows > 0) {
                String decreaseSql = "UPDATE courses SET enrolled_students = enrolled_students - 1 WHERE course_id = ?";
                try (PreparedStatement decreaseStmt = conn.prepareStatement(decreaseSql)) {
                    decreaseStmt.setInt(1, courseId);
                    decreaseStmt.executeUpdate();
                }
            }
            
            conn.commit(); // Commit transaction
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error dropping student: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
        
        return false;
    }
    
    /**
     * Gets all enrolled courses for a student
     * 
     * @param studentId The student's user ID
     * @return List of enrollments for the student
     */
    public List<Enrollment> getEnrollmentsByStudent(int studentId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.enrollment_id, e.student_id, e.course_id, e.status, " +
                    "e.enrollment_date, e.last_updated, " +
                    "c.course_code, c.course_name, " +
                    "u.full_name as student_name, u.email as student_email, " +
                    "t.full_name as teacher_name " +
                    "FROM enrollments e " +
                    "JOIN courses c ON e.course_id = c.course_id " +
                    "LEFT JOIN users u ON e.student_id = u.user_id " +
                    "LEFT JOIN users t ON c.teacher_id = t.user_id " +
                    "WHERE e.student_id = ? AND e.status IN ('ENROLLED', 'COMPLETED', 'DROPPED') " +
                    "ORDER BY e.enrollment_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    enrollments.add(mapResultSetToEnrollment(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting enrollments by student: " + e.getMessage());
            e.printStackTrace();
        }
        
        return enrollments;
    }
    
    /**
     * Gets all enrolled students for a course
     * 
     * @param courseId The course ID
     * @return List of enrollments for the course
     */
    public List<Enrollment> getEnrollmentsByCourse(int courseId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.enrollment_id, e.student_id, e.course_id, e.status, " +
                    "e.enrollment_date, e.last_updated, " +
                    "c.course_code, c.course_name, " +
                    "u.full_name as student_name, u.email as student_email, " +
                    "t.full_name as teacher_name " +
                    "FROM enrollments e " +
                    "JOIN courses c ON e.course_id = c.course_id " +
                    "LEFT JOIN users u ON e.student_id = u.user_id " +
                    "LEFT JOIN users t ON c.teacher_id = t.user_id " +
                    "WHERE e.course_id = ? AND e.status = 'ENROLLED' " +
                    "ORDER BY u.full_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    enrollments.add(mapResultSetToEnrollment(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting enrollments by course: " + e.getMessage());
            e.printStackTrace();
        }
        
        return enrollments;
    }
    
    /**
     * Checks if a student is enrolled in a specific course
     * 
     * @param studentId The student's user ID
     * @param courseId The course ID
     * @return true if student is enrolled, false otherwise
     */
    public boolean isStudentEnrolled(int studentId, int courseId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND course_id = ? AND status = 'ENROLLED'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking enrollment status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Gets the enrollment count for a specific course
     * 
     * @param courseId The course ID
     * @return The number of enrolled students
     */
    public int getEnrollmentCount(int courseId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ? AND status = 'ENROLLED'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting enrollment count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Gets all enrollments for admin view
     * 
     * @return List of all enrollments
     */
    public List<Enrollment> getAllEnrollments() {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.enrollment_id, e.student_id, e.course_id, e.status, " +
                    "e.enrollment_date, e.last_updated, " +
                    "c.course_code, c.course_name, " +
                    "u.full_name as student_name, u.email as student_email, " +
                    "t.full_name as teacher_name " +
                    "FROM enrollments e " +
                    "JOIN courses c ON e.course_id = c.course_id " +
                    "LEFT JOIN users u ON e.student_id = u.user_id " +
                    "LEFT JOIN users t ON c.teacher_id = t.user_id " +
                    "ORDER BY e.enrollment_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                enrollments.add(mapResultSetToEnrollment(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all enrollments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return enrollments;
    }
    
    /**
     * Updates enrollment status
     * 
     * @param enrollmentId The enrollment ID
     * @param status The new status
     * @return true if update was successful, false otherwise
     */
    public boolean updateEnrollmentStatus(int enrollmentId, Enrollment.EnrollmentStatus status) {
        String sql = "UPDATE enrollments SET status = ?, last_updated = CURRENT_TIMESTAMP WHERE enrollment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status.name());
            stmt.setInt(2, enrollmentId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating enrollment status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Deletes an enrollment record
     * 
     * @param enrollmentId The enrollment ID to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteEnrollment(int enrollmentId) {
        String sql = "DELETE FROM enrollments WHERE enrollment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, enrollmentId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting enrollment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Creates a new enrollment from an Enrollment object
     * 
     * @param enrollment The enrollment object to create
     * @return true if successful, false otherwise
     */
    public boolean createEnrollment(Enrollment enrollment) {
        return enrollStudent(enrollment.getStudentId(), enrollment.getCourseId()) > 0;
    }
    
    /**
     * Updates enrollment status
     * 
     * @param enrollmentId The enrollment ID
     * @param newStatus The new status
     * @return true if update was successful, false otherwise
     */
    public boolean updateEnrollmentStatus(int enrollmentId, String newStatus) {
        String sql = "UPDATE enrollments SET status = ?, last_updated = CURRENT_TIMESTAMP WHERE enrollment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStatus);
            stmt.setInt(2, enrollmentId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating enrollment status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Maps a ResultSet row to an Enrollment object
     * 
     * @param rs The ResultSet positioned at a valid row
     * @return Enrollment object
     * @throws SQLException if there's an error reading from the ResultSet
     */
    private Enrollment mapResultSetToEnrollment(ResultSet rs) throws SQLException {
        Enrollment enrollment = new Enrollment();
        enrollment.setEnrollmentId(rs.getInt("enrollment_id"));
        enrollment.setStudentId(rs.getInt("student_id"));
        enrollment.setCourseId(rs.getInt("course_id"));
        enrollment.setStatus(Enrollment.EnrollmentStatus.valueOf(rs.getString("status")));
        enrollment.setEnrollmentDate(rs.getTimestamp("enrollment_date"));
        enrollment.setLastUpdated(rs.getTimestamp("last_updated"));
        enrollment.setCourseCode(rs.getString("course_code"));
        enrollment.setCourseName(rs.getString("course_name"));
        
        String studentName = rs.getString("student_name");
        enrollment.setStudentName(studentName == null ? "Unknown Student" : studentName);
        
        String studentEmail = rs.getString("student_email");
        enrollment.setStudentEmail(studentEmail == null ? "N/A" : studentEmail);
        
        // Handle cases where a course might not have an assigned teacher yet
        String teacherName = rs.getString("teacher_name");
        enrollment.setTeacherName(teacherName == null ? "Not Assigned" : teacherName);
        
        return enrollment;
    }
}
