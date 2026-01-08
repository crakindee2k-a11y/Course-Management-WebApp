package com.coursemanagement.servlet;

import com.coursemanagement.dao.CourseDAO;
import com.coursemanagement.dao.EnrollmentDAO;
import com.coursemanagement.dao.UserDAO;
import com.coursemanagement.model.Course;
import com.coursemanagement.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Admin Dashboard Servlet to handle admin dashboard functionality.
 * 
 * This servlet provides the main admin interface with system statistics
 * and management options.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class AdminDashboardServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private CourseDAO courseDAO;
    private EnrollmentDAO enrollmentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        courseDAO = new CourseDAO();
        enrollmentDAO = new EnrollmentDAO();
    }
    
    /**
     * Handles GET requests - displays the admin dashboard
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
        
        try {
            // Get system statistics
            List<User> allStudents = userDAO.getUsersByType(User.UserType.STUDENT);
            List<User> allTeachers = userDAO.getUsersByType(User.UserType.TEACHER);
            List<Course> allCourses = courseDAO.getAllCourses();
            
            // Calculate total enrollments
            int totalEnrollments = 0;
            for (Course course : allCourses) {
                totalEnrollments += course.getEnrolledStudents();
            }
            
            // Get recent courses (last 5)
            List<Course> recentCourses = allCourses.size() > 5 ? 
                allCourses.subList(0, 5) : allCourses;
            
            // Set attributes for JSP
            request.setAttribute("totalStudents", allStudents.size());
            request.setAttribute("totalTeachers", allTeachers.size());
            request.setAttribute("totalCourses", allCourses.size());
            request.setAttribute("totalEnrollments", totalEnrollments);
            
            request.setAttribute("students", allStudents);
            request.setAttribute("teachers", allTeachers);
            request.setAttribute("courses", allCourses);
            request.setAttribute("recentCourses", recentCourses);
            
            // Calculate detailed statistics with actionable data
            int coursesWithTeachers = 0;
            int fullCourses = 0;
            List<Course> unassignedCourses = new ArrayList<>();
            List<Course> fullCapacityCourses = new ArrayList<>();
            List<Course> lowCapacityCourses = new ArrayList<>();
            
            for (Course course : allCourses) {
                // Check teacher assignment
                if (course.getTeacherId() > 0) {
                    coursesWithTeachers++;
                } else {
                    unassignedCourses.add(course);
                }
                
                // Check capacity issues
                int enrolled = course.getEnrolledStudents();
                int maxStudents = course.getMaxStudents();
                double capacityRatio = (double) enrolled / maxStudents;
                
                if (enrolled >= maxStudents) {
                    fullCourses++;
                    fullCapacityCourses.add(course);
                } else if (capacityRatio >= 0.8) { // 80% or more capacity
                    lowCapacityCourses.add(course);
                }
            }
            
            // Set basic statistics
            request.setAttribute("coursesWithTeachers", coursesWithTeachers);
            request.setAttribute("coursesWithoutTeachers", allCourses.size() - coursesWithTeachers);
            request.setAttribute("fullCourses", fullCourses);
            request.setAttribute("availableCourses", allCourses.size() - fullCourses);
            
            // Set actionable data lists
            request.setAttribute("unassignedCourses", unassignedCourses);
            request.setAttribute("fullCapacityCourses", fullCapacityCourses);
            request.setAttribute("lowCapacityCourses", lowCapacityCourses);
            
            // Calculate urgency indicators
            request.setAttribute("hasUnassignedCourses", !unassignedCourses.isEmpty());
            request.setAttribute("hasCapacityIssues", !fullCapacityCourses.isEmpty() || !lowCapacityCourses.isEmpty());
            
            // Forward to admin dashboard JSP
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading the dashboard.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests - currently not used but can be extended for admin actions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Admin dashboard post actions can be handled here
        // For now, redirect to GET
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Admin Dashboard Servlet for Course Management System";
    }
}
