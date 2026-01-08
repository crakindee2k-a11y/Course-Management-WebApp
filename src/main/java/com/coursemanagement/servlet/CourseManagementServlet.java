package com.coursemanagement.servlet;

import com.coursemanagement.dao.CourseDAO;
import com.coursemanagement.dao.UserDAO;
import com.coursemanagement.model.Course;
import com.coursemanagement.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Course Management Servlet for admin course operations.
 * 
 * This servlet handles course creation, editing, deletion, and teacher assignment
 * for administrators.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class CourseManagementServlet extends HttpServlet {
    
    private CourseDAO courseDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        userDAO = new UserDAO();
    }
    
    /**
     * Handles GET requests - displays course management page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verify user is admin
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                handleEditCourse(request, response);
            } else if ("delete".equals(action)) {
                handleDeleteCourse(request, response);
            } else if ("bulkDelete".equals(action)) {
                handleBulkDeleteCourses(request, response);
            } else {
                // Default: show course list
                showCourseList(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error in CourseManagementServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            showCourseList(request, response);
        }
    }
    
    /**
     * Handles POST requests - processes course operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verify user is admin
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                handleCreateCourse(request, response);
            } else if ("update".equals(action)) {
                handleUpdateCourse(request, response);
            } else if ("assign".equals(action)) {
                handleAssignTeacher(request, response);
            } else if ("bulkDelete".equals(action)) {
                handleBulkDeleteCourses(request, response);
            } else if ("bulkAssignTeacher".equals(action)) {
                handleBulkAssignTeacher(request, response);
            } else if ("bulkUpdateCapacity".equals(action)) {
                handleBulkUpdateCapacity(request, response);
            } else {
                showCourseList(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error in CourseManagementServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            showCourseList(request, response);
        }
    }
    
    /**
     * Shows the course management list
     */
    private void showCourseList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get all courses and teachers
            List<Course> courses = courseDAO.getAllCourses();
            List<User> teachers = userDAO.findByUserType(User.UserType.TEACHER);
            
            request.setAttribute("courses", courses);
            request.setAttribute("teachers", teachers);
            
            request.getRequestDispatcher("/admin/courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error showing course list: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading courses: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles course creation
     */
    private void handleCreateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseCode = request.getParameter("courseCode");
        String courseName = request.getParameter("courseName");
        String description = request.getParameter("description");
        String creditsStr = request.getParameter("credits");
        String teacherIdStr = request.getParameter("teacherId");
        String maxStudentsStr = request.getParameter("maxStudents");
        
        // Validate input
        if (courseCode == null || courseCode.trim().isEmpty() ||
            courseName == null || courseName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Course code and name are required");
            showCourseList(request, response);
            return;
        }
        
        // Check if course code already exists
        if (courseDAO.courseCodeExists(courseCode.trim())) {
            request.setAttribute("errorMessage", "Course code already exists");
            showCourseList(request, response);
            return;
        }
        
        try {
            int credits = creditsStr != null && !creditsStr.isEmpty() ? 
                         Integer.parseInt(creditsStr) : 3;
            int teacherId = teacherIdStr != null && !teacherIdStr.isEmpty() ? 
                           Integer.parseInt(teacherIdStr) : 0;
            int maxStudents = maxStudentsStr != null && !maxStudentsStr.isEmpty() ? 
                             Integer.parseInt(maxStudentsStr) : 50;
            
            Course course = new Course(courseCode.trim(), courseName.trim(), 
                                     description != null ? description.trim() : "", 
                                     credits, teacherId, maxStudents);
            
            int courseId = courseDAO.createCourse(course);
            
            if (courseId > 0) {
                request.setAttribute("successMessage", 
                    "Course '" + courseName + "' created successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to create course");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid numeric values provided");
        }
        
        showCourseList(request, response);
    }
    
    /**
     * Handles course update
     */
    private void handleUpdateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        String courseCode = request.getParameter("courseCode");
        String courseName = request.getParameter("courseName");
        String description = request.getParameter("description");
        String creditsStr = request.getParameter("credits");
        String teacherIdStr = request.getParameter("teacherId");
        String maxStudentsStr = request.getParameter("maxStudents");
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            int credits = Integer.parseInt(creditsStr);
            int teacherId = teacherIdStr != null && !teacherIdStr.isEmpty() ? 
                           Integer.parseInt(teacherIdStr) : 0;
            int maxStudents = Integer.parseInt(maxStudentsStr);
            
            Course course = new Course(courseId, courseCode.trim(), courseName.trim(), 
                                     description != null ? description.trim() : "", 
                                     credits, teacherId, maxStudents);
            
            if (courseDAO.updateCourse(course)) {
                request.setAttribute("successMessage", 
                    "Course '" + courseName + "' updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update course");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid course ID or numeric values");
        }
        
        showCourseList(request, response);
    }
    
    /**
     * Handles teacher assignment
     */
    private void handleAssignTeacher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        String teacherIdStr = request.getParameter("teacherId");
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            int teacherId = Integer.parseInt(teacherIdStr);
            
            if (courseDAO.assignTeacher(courseId, teacherId)) {
                User teacher = userDAO.findById(teacherId);
                Course course = courseDAO.findById(courseId);
                
                request.setAttribute("successMessage", 
                    "Teacher '" + teacher.getFullName() + "' assigned to course '" + 
                    course.getCourseName() + "' successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to assign teacher");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid course or teacher ID");
        }
        
        showCourseList(request, response);
    }
    
    /**
     * Handles course editing (shows edit form)
     */
    private void handleEditCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("id");
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.findById(courseId);
            
            if (course != null) {
                request.setAttribute("editCourse", course);
            } else {
                request.setAttribute("errorMessage", "Course not found");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid course ID");
        }
        
        showCourseList(request, response);
    }
    
    /**
     * Handles course deletion
     */
    private void handleDeleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("id");
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.findById(courseId);
            
            if (course != null) {
                if (course.getEnrolledStudents() > 0) {
                    request.setAttribute("errorMessage", 
                        "Cannot delete course with enrolled students");
                } else if (courseDAO.deleteCourse(courseId)) {
                    request.setAttribute("successMessage", 
                        "Course '" + course.getCourseName() + "' deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete course");
                }
            } else {
                request.setAttribute("errorMessage", "Course not found");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid course ID");
        }
        
        showCourseList(request, response);
    }
    
    /**
     * Bulk delete courses selected in the admin UI.
     */
    private void handleBulkDeleteCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get array of course IDs to delete
        String[] courseIds = request.getParameterValues("courseIds");
        
        if (courseIds == null || courseIds.length == 0) {
            request.setAttribute("errorMessage", "No courses selected for deletion");
            showCourseList(request, response);
            return;
        }
        
        int successCount = 0;
        int failureCount = 0;
        StringBuilder errorDetails = new StringBuilder();
        
        // Process each course ID
        for (String courseIdStr : courseIds) {
            try {
                int courseId = Integer.parseInt(courseIdStr);
                Course course = courseDAO.findById(courseId);
                
                if (course != null) {
                    // Check if course has enrolled students
                    if (course.getEnrolledStudents() > 0) {
                        failureCount++;
                        errorDetails.append("Course ").append(course.getCourseCode())
                                  .append(" has enrolled students. ");
                    } else {
                        // Safe to delete
                        if (courseDAO.deleteCourse(courseId)) {
                            successCount++;
                        } else {
                            failureCount++;
                            errorDetails.append("Failed to delete course ")
                                      .append(course.getCourseCode()).append(". ");
                        }
                    }
                } else {
                    failureCount++;
                    errorDetails.append("Course with ID ").append(courseId)
                              .append(" not found. ");
                }
                
            } catch (NumberFormatException e) {
                failureCount++;
                errorDetails.append("Invalid course ID: ").append(courseIdStr).append(". ");
            }
        }
        
        // Set appropriate success/error messages
        if (successCount > 0 && failureCount == 0) {
            request.setAttribute("successMessage", 
                successCount + " course(s) deleted successfully");
        } else if (successCount > 0 && failureCount > 0) {
            request.setAttribute("warningMessage", 
                successCount + " course(s) deleted successfully, " + 
                failureCount + " failed. " + errorDetails.toString());
        } else {
            request.setAttribute("errorMessage", 
                "Failed to delete courses: " + errorDetails.toString());
        }
        
        showCourseList(request, response);
    }
    
    /**
     * Bulk assign a teacher to selected courses.
     */
    private void handleBulkAssignTeacher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String[] courseIds = request.getParameterValues("courseIds");
        String teacherIdStr = request.getParameter("teacherId");
        
        if (courseIds == null || courseIds.length == 0) {
            request.setAttribute("errorMessage", "No courses selected");
            showCourseList(request, response);
            return;
        }
        
        if (teacherIdStr == null || teacherIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No teacher selected");
            showCourseList(request, response);
            return;
        }
        
        try {
            int teacherId = Integer.parseInt(teacherIdStr);
            User teacher = userDAO.findById(teacherId);
            
            if (teacher == null || !teacher.isTeacher()) {
                request.setAttribute("errorMessage", "Invalid teacher selected");
                showCourseList(request, response);
                return;
            }
            
            int successCount = 0;
            int failureCount = 0;
            
            // Assign teacher to each selected course
            for (String courseIdStr : courseIds) {
                try {
                    int courseId = Integer.parseInt(courseIdStr);
                    if (courseDAO.assignTeacher(courseId, teacherId)) {
                        successCount++;
                    } else {
                        failureCount++;
                    }
                } catch (NumberFormatException e) {
                    failureCount++;
                }
            }
            
            if (successCount > 0 && failureCount == 0) {
                request.setAttribute("successMessage", 
                    "Teacher " + teacher.getFullName() + " assigned to " + 
                    successCount + " course(s) successfully");
            } else if (successCount > 0) {
                request.setAttribute("warningMessage", 
                    successCount + " assignments successful, " + failureCount + " failed");
            } else {
                request.setAttribute("errorMessage", "Failed to assign teacher to courses");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid teacher ID");
        }
        
        showCourseList(request, response);
    }
    
    /**
     * Bulk update maximum student capacity for selected courses.
     */
    private void handleBulkUpdateCapacity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String[] courseIds = request.getParameterValues("courseIds");
        String newCapacityStr = request.getParameter("newCapacity");
        
        if (courseIds == null || courseIds.length == 0) {
            request.setAttribute("errorMessage", "No courses selected");
            showCourseList(request, response);
            return;
        }
        
        if (newCapacityStr == null || newCapacityStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No capacity value provided");
            showCourseList(request, response);
            return;
        }
        
        try {
            int newCapacity = Integer.parseInt(newCapacityStr);
            
            if (newCapacity < 1) {
                request.setAttribute("errorMessage", "Capacity must be at least 1");
                showCourseList(request, response);
                return;
            }
            
            int successCount = 0;
            int failureCount = 0;
            StringBuilder errorDetails = new StringBuilder();
            
            // Update capacity for each selected course
            for (String courseIdStr : courseIds) {
                try {
                    int courseId = Integer.parseInt(courseIdStr);
                    Course course = courseDAO.findById(courseId);
                    
                    if (course != null) {
                        // Check if new capacity is less than current enrollments
                        if (newCapacity < course.getEnrolledStudents()) {
                            failureCount++;
                            errorDetails.append("Course ").append(course.getCourseCode())
                                      .append(" has ").append(course.getEnrolledStudents())
                                      .append(" enrolled students, cannot reduce capacity to ")
                                      .append(newCapacity).append(". ");
                        } else {
                            // Update the course capacity
                            course.setMaxStudents(newCapacity);
                            if (courseDAO.updateCourse(course)) {
                                successCount++;
                            } else {
                                failureCount++;
                                errorDetails.append("Failed to update course ")
                                          .append(course.getCourseCode()).append(". ");
                            }
                        }
                    } else {
                        failureCount++;
                        errorDetails.append("Course with ID ").append(courseId)
                                  .append(" not found. ");
                    }
                    
                } catch (NumberFormatException e) {
                    failureCount++;
                    errorDetails.append("Invalid course ID: ").append(courseIdStr).append(". ");
                }
            }
            
            if (successCount > 0 && failureCount == 0) {
                request.setAttribute("successMessage", 
                    successCount + " course(s) capacity updated to " + newCapacity);
            } else if (successCount > 0) {
                request.setAttribute("warningMessage", 
                    successCount + " courses updated successfully, " + failureCount + 
                    " failed. " + errorDetails.toString());
            } else {
                request.setAttribute("errorMessage", 
                    "Failed to update course capacities: " + errorDetails.toString());
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid capacity value");
        }
        
        showCourseList(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Course Management Servlet for Course Management System";
    }
}
