package com.coursemanagement.servlet;

import com.coursemanagement.dao.CourseDAO;
import com.coursemanagement.dao.EnrollmentDAO;
import com.coursemanagement.dao.UserDAO;
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
 * View Students Servlet to handle teacher viewing of enrolled students.
 * 
 * This servlet allows teachers to view students enrolled in their courses.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class ViewStudentsServlet extends HttpServlet {
    
    private CourseDAO courseDAO;
    private EnrollmentDAO enrollmentDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        enrollmentDAO = new EnrollmentDAO();
        userDAO = new UserDAO();
        System.out.println("ViewStudentsServlet initialized successfully");
    }
    
    /**
     * Handles GET requests - displays students for a specific course
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
            String courseIdParam = request.getParameter("courseId");
            
            if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
                // Check if "all" parameter is passed for viewing all students
                String viewAll = request.getParameter("all");
                if ("true".equals(viewAll)) {
                    // Show all students across all teacher's courses
                    List<Course> assignedCourses = courseDAO.getCoursesByTeacher(currentUser.getUserId());
                    request.setAttribute("assignedCourses", assignedCourses);
                    request.setAttribute("viewAllStudents", true);
                    request.setAttribute("currentUser", currentUser);
                    request.getRequestDispatcher("/teacher/all-students.jsp").forward(request, response);
                    return;
                } else {
                    // Show list of teacher's courses for selection
                    List<Course> assignedCourses = courseDAO.getCoursesByTeacher(currentUser.getUserId());
                    request.setAttribute("assignedCourses", assignedCourses);
                    request.setAttribute("currentUser", currentUser);
                    request.getRequestDispatcher("/teacher/students.jsp").forward(request, response);
                    return;
                }
            }
            
            int courseId = Integer.parseInt(courseIdParam);
            
            // Verify that the teacher is assigned to this course
            Course course = courseDAO.findById(courseId);
            if (course == null || course.getTeacherId() != currentUser.getUserId()) {
                request.setAttribute("errorMessage", "You are not assigned to this course.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get enrolled students for this course
            List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByCourse(courseId);
            
            // Set attributes for JSP
            request.setAttribute("course", course);
            request.setAttribute("enrollments", enrollments);
            request.setAttribute("currentUser", currentUser);
            
            // Forward to view students JSP
            request.getRequestDispatcher("/teacher/view-students.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid course ID.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in ViewStudentsServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading students. Please try again.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    public String getServletInfo() {
        return "View Students Servlet for Course Management System";
    }
}

