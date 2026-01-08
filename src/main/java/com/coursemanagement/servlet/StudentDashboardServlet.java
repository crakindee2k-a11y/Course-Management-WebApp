package com.coursemanagement.servlet;

import com.coursemanagement.dao.CourseDAO;
import com.coursemanagement.dao.EnrollmentDAO;
import com.coursemanagement.model.Course;
import com.coursemanagement.model.Enrollment;
import com.coursemanagement.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Student Dashboard Servlet to handle student-specific functionality.
 * 
 * This servlet provides the main dashboard for students, showing their
 * enrolled courses and available courses for registration.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class StudentDashboardServlet extends HttpServlet {
    
    private CourseDAO courseDAO;
    private EnrollmentDAO enrollmentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        enrollmentDAO = new EnrollmentDAO();
        System.out.println("StudentDashboardServlet initialized successfully");
    }
    
    /**
     * Handles GET requests - displays the student dashboard
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (!currentUser.getUserType().name().equals("STUDENT")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
            return;
        }
        
        try {
            // Get student's enrolled courses
            List<Enrollment> enrolledCourses = enrollmentDAO.getEnrollmentsByStudent(currentUser.getUserId());
            
            // Get all available courses
            List<Course> availableCourses = courseDAO.getAvailableCourses();
            
            // Get recent activity (limit to last 5 enrollments)
            List<Enrollment> recentActivity = enrolledCourses.stream()
                .sorted((e1, e2) -> e2.getEnrollmentDate().compareTo(e1.getEnrollmentDate()))
                .limit(5)
                .collect(java.util.stream.Collectors.toList());
            
            // Set attributes for JSP
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("availableCourses", availableCourses);
            request.setAttribute("recentActivity", recentActivity);
            request.setAttribute("currentUser", currentUser);
            
            // Forward to student dashboard JSP
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in StudentDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading the dashboard. Please try again.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests - processes course registration
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (!currentUser.getUserType().name().equals("STUDENT")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("register".equals(action)) {
            try {
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
                    } else {
                        request.setAttribute("errorMessage", "Failed to enroll in the course. Please try again.");
                    }
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid course ID.");
            } catch (Exception e) {
                System.err.println("Error during course registration: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMessage", "An error occurred during registration. Please try again.");
            }
        }
        
        // Redirect back to dashboard
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Student Dashboard Servlet for Course Management System";
    }
}

