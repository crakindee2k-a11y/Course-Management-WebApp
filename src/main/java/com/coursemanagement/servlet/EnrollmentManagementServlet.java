package com.coursemanagement.servlet;

import com.coursemanagement.dao.EnrollmentDAO;
import com.coursemanagement.dao.CourseDAO;
import com.coursemanagement.dao.UserDAO;
import com.coursemanagement.model.Enrollment;
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
 * Enrollment Management Servlet for admin operations.
 * 
 * This servlet handles enrollment management operations including viewing all enrollments,
 * managing enrollment status, and enrollment statistics.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class EnrollmentManagementServlet extends HttpServlet {
    
    private EnrollmentDAO enrollmentDAO;
    private CourseDAO courseDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        enrollmentDAO = new EnrollmentDAO();
        courseDAO = new CourseDAO();
        userDAO = new UserDAO();
        System.out.println("EnrollmentManagementServlet initialized successfully");
    }
    
    /**
     * Handles GET requests - displays the enrollment management page
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
        if (currentUser.getUserType() != User.UserType.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }
        
        try {
            // Get all enrollments
            List<Enrollment> allEnrollments = enrollmentDAO.getAllEnrollments();
            
            // Get enrollment statistics
            long totalEnrollments = allEnrollments.size();
            long activeEnrollments = allEnrollments.stream()
                .filter(e -> e.getStatus() == Enrollment.EnrollmentStatus.ENROLLED)
                .count();
            long completedEnrollments = allEnrollments.stream()
                .filter(e -> e.getStatus() == Enrollment.EnrollmentStatus.COMPLETED)
                .count();
            long droppedEnrollments = allEnrollments.stream()
                .filter(e -> e.getStatus() == Enrollment.EnrollmentStatus.DROPPED)
                .count();
            
            // Get all courses and students for dropdowns
            List<Course> allCourses = courseDAO.getAllCourses();
            List<User> allStudents = userDAO.findByUserType(User.UserType.STUDENT);
            
            // Set attributes for JSP
            request.setAttribute("allEnrollments", allEnrollments);
            request.setAttribute("allCourses", allCourses);
            request.setAttribute("allStudents", allStudents);
            request.setAttribute("totalEnrollments", totalEnrollments);
            request.setAttribute("activeEnrollments", activeEnrollments);
            request.setAttribute("completedEnrollments", completedEnrollments);
            request.setAttribute("droppedEnrollments", droppedEnrollments);
            
            // Forward to enrollment management JSP
            request.getRequestDispatcher("/admin/enrollments.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in EnrollmentManagementServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading enrollment management. Please try again.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests - processes enrollment management operations
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
        if (currentUser.getUserType() != User.UserType.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("updateStatus".equals(action)) {
                handleUpdateStatus(request, response);
            } else if ("deleteEnrollment".equals(action)) {
                handleDeleteEnrollment(request, response);
            } else {
                request.setAttribute("errorMessage", "Invalid action specified.");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error in EnrollmentManagementServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing the request. Please try again.");
            doGet(request, response);
        }
    }
    
    /**
     * Handles enrollment status update
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String enrollmentIdStr = request.getParameter("enrollmentId");
        String newStatus = request.getParameter("newStatus");
        
        if (enrollmentIdStr == null || enrollmentIdStr.trim().isEmpty() ||
            newStatus == null || newStatus.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Enrollment ID and status are required.");
            doGet(request, response);
            return;
        }
        
        try {
            int enrollmentId = Integer.parseInt(enrollmentIdStr);
            
            if (enrollmentDAO.updateEnrollmentStatus(enrollmentId, newStatus.trim())) {
                request.setAttribute("successMessage", "Enrollment status updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update enrollment status. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid enrollment ID.");
        }
        
        doGet(request, response);
    }
    
    /**
     * Handles enrollment deletion
     */
    private void handleDeleteEnrollment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String enrollmentIdStr = request.getParameter("enrollmentId");
        
        if (enrollmentIdStr == null || enrollmentIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Enrollment ID is required.");
            doGet(request, response);
            return;
        }
        
        try {
            int enrollmentId = Integer.parseInt(enrollmentIdStr);
            
            if (enrollmentDAO.deleteEnrollment(enrollmentId)) {
                request.setAttribute("successMessage", "Enrollment deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete enrollment. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid enrollment ID.");
        }
        
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Enrollment Management Servlet for Course Management System";
    }
}
