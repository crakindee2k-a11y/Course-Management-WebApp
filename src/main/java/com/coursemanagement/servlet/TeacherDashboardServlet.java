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

/**
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class TeacherDashboardServlet extends HttpServlet {
    
    private CourseDAO courseDAO;
    private EnrollmentDAO enrollmentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        enrollmentDAO = new EnrollmentDAO();
        System.out.println("TeacherDashboardServlet initialized successfully");
    }
    
    /**
     * Handles GET requests - displays the teacher dashboard
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
        if (!currentUser.getUserType().name().equals("TEACHER")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
            return;
        }
        
        try {
            // Get teacher's assigned courses
            List<Course> assignedCourses = courseDAO.getCoursesByTeacher(currentUser.getUserId());
            
            // Set attributes for JSP
            request.setAttribute("assignedCourses", assignedCourses);
            request.setAttribute("currentUser", currentUser);
            
            // Forward to teacher dashboard JSP
            request.getRequestDispatcher("/teacher/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in TeacherDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading the dashboard. Please try again.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Teacher Dashboard Servlet for Course Management System";
    }
}

