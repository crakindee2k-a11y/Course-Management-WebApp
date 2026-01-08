package com.coursemanagement.dao;

import com.coursemanagement.model.Course;
import com.coursemanagement.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for Course entity.
 * 
 * This class handles all database operations related to courses including
 * course creation, assignment to teachers, and course management.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class CourseDAO {
    
    /**
     * Gets all courses with their teacher information
     * 
     * @return List of all courses
     */
    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.course_id, c.course_code, c.course_name, c.description, c.credits, " +
                    "c.teacher_id, c.max_students, c.enrolled_students, c.created_at, c.updated_at, " +
                    "u.full_name as teacher_name " +
                    "FROM courses c " +
                    "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                    "ORDER BY c.course_code";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all courses: " + e.getMessage());
            e.printStackTrace();
        }
        
        return courses;
    }
    
    /**
     * Gets courses assigned to a specific teacher
     * 
     * @param teacherId The ID of the teacher
     * @return List of courses assigned to the teacher
     */
    public List<Course> getCoursesByTeacher(int teacherId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.course_id, c.course_code, c.course_name, c.description, c.credits, " +
                    "c.teacher_id, c.max_students, c.enrolled_students, c.created_at, c.updated_at, " +
                    "u.full_name as teacher_name " +
                    "FROM courses c " +
                    "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                    "WHERE c.teacher_id = ? " +
                    "ORDER BY c.course_code";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapResultSetToCourse(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting courses by teacher: " + e.getMessage());
            e.printStackTrace();
        }
        
        return courses;
    }
    
    /**
     * Gets available courses for student registration
     * 
     * @return List of courses that have available slots
     */
    public List<Course> getAvailableCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.course_id, c.course_code, c.course_name, c.description, c.credits, " +
                    "c.teacher_id, c.max_students, c.enrolled_students, c.created_at, c.updated_at, " +
                    "u.full_name as teacher_name " +
                    "FROM courses c " +
                    "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                    "WHERE c.enrolled_students < c.max_students " +
                    "ORDER BY c.course_code";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available courses: " + e.getMessage());
            e.printStackTrace();
        }
        
        return courses;
    }
    
    /**
     * Finds a course by its ID
     * 
     * @param courseId The course ID to search for
     * @return Course object if found, null otherwise
     */
    public Course findById(int courseId) {
        String sql = "SELECT c.course_id, c.course_code, c.course_name, c.description, c.credits, " +
                    "c.teacher_id, c.max_students, c.enrolled_students, c.created_at, c.updated_at, " +
                    "u.full_name as teacher_name " +
                    "FROM courses c " +
                    "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                    "WHERE c.course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCourse(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding course by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Finds a course by its course code
     * 
     * @param courseCode The course code to search for
     * @return Course object if found, null otherwise
     */
    public Course findByCourseCode(String courseCode) {
        String sql = "SELECT c.course_id, c.course_code, c.course_name, c.description, c.credits, " +
                    "c.teacher_id, c.max_students, c.enrolled_students, c.created_at, c.updated_at, " +
                    "u.full_name as teacher_name " +
                    "FROM courses c " +
                    "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                    "WHERE c.course_code = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseCode);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCourse(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding course by code: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Creates a new course
     * 
     * @param course The course to create
     * @return The course ID of the created course, or -1 if creation failed
     */
    public int createCourse(Course course) {
        String sql = "INSERT INTO courses (course_code, course_name, description, credits, teacher_id, max_students, enrolled_students) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 0)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getDescription());
            stmt.setInt(4, course.getCredits());
            
            if (course.getTeacherId() > 0) {
                stmt.setInt(5, course.getTeacherId());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            stmt.setInt(6, course.getMaxStudents());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating course failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int courseId = generatedKeys.getInt(1);
                    course.setCourseId(courseId);
                    return courseId;
                } else {
                    throw new SQLException("Creating course failed, no ID obtained.");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating course: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Updates an existing course
     * 
     * @param course The course to update
     * @return true if update was successful, false otherwise
     */
    public boolean updateCourse(Course course) {
        String sql = "UPDATE courses " +
                    "SET course_code = ?, course_name = ?, description = ?, credits = ?, " +
                    "teacher_id = ?, max_students = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getDescription());
            stmt.setInt(4, course.getCredits());
            
            if (course.getTeacherId() > 0) {
                stmt.setInt(5, course.getTeacherId());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            stmt.setInt(6, course.getMaxStudents());
            stmt.setInt(7, course.getCourseId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating course: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Assigns a teacher to a course
     * 
     * @param courseId The course ID
     * @param teacherId The teacher ID
     * @return true if assignment was successful, false otherwise
     */
    public boolean assignTeacher(int courseId, int teacherId) {
        String sql = "UPDATE courses SET teacher_id = ?, updated_at = CURRENT_TIMESTAMP WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            stmt.setInt(2, courseId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error assigning teacher to course: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Updates the enrolled student count for a course
     * 
     * @param courseId The course ID
     * @param enrolledCount The new enrolled student count
     * @return true if update was successful, false otherwise
     */
    public boolean updateEnrollmentCount(int courseId, int enrolledCount) {
        String sql = "UPDATE courses SET enrolled_students = ?, updated_at = CURRENT_TIMESTAMP WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, enrolledCount);
            stmt.setInt(2, courseId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating enrollment count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Deletes a course
     * 
     * @param courseId The ID of the course to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteCourse(int courseId) {
        String sql = "DELETE FROM courses WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting course: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Checks if a course code already exists
     * 
     * @param courseCode The course code to check
     * @return true if course code exists, false otherwise
     */
    public boolean courseCodeExists(String courseCode) {
        String sql = "SELECT COUNT(*) FROM courses WHERE course_code = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseCode);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking course code existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Maps a ResultSet row to a Course object
     * 
     * @param rs The ResultSet positioned at a valid row
     * @return Course object
     * @throws SQLException if there's an error reading from the ResultSet
     */
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setCourseCode(rs.getString("course_code"));
        course.setCourseName(rs.getString("course_name"));
        course.setDescription(rs.getString("description"));
        course.setCredits(rs.getInt("credits"));
        course.setTeacherId(rs.getInt("teacher_id"));
        course.setMaxStudents(rs.getInt("max_students"));
        course.setEnrolledStudents(rs.getInt("enrolled_students"));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        course.setUpdatedAt(rs.getTimestamp("updated_at"));
        course.setTeacherName(rs.getString("teacher_name"));
        
        return course;
    }
}
