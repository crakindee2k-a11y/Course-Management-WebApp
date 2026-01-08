package com.coursemanagement.servlet;

import com.coursemanagement.dao.UserDAO;
import com.coursemanagement.model.User;
import com.coursemanagement.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Login servlet to handle user authentication.
 * 
 * This servlet processes login requests, authenticates users, and creates
 * user sessions. It also handles initialization of the database connection.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        
        // Initialize database connection with servlet context
        DatabaseConnection.initialize(getServletContext());
        
        // Initialize database tables and default data
        DatabaseConnection.initializeDatabase();
        
        // Initialize DAO
        userDAO = new UserDAO();
        
        System.out.println("LoginServlet initialized successfully");
    }
    
    /**
     * Handles GET requests - displays the login form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            redirectToDashboard(request, response, currentUser);
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    /**
     * Handles POST requests - processes login form submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String redirectUrl = request.getParameter("redirect");
        
        // Clear any existing error messages
        request.removeAttribute("errorMessage");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Username and password are required");
            request.setAttribute("username", username); // Preserve username
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Attempt authentication
            User user = userDAO.authenticateUser(username.trim(), password);
            
            if (user != null) {
                // Authentication successful - create session
                HttpSession session = request.getSession(true);
                session.setAttribute("currentUser", user);
                session.setAttribute("userType", user.getUserType().name());
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("fullName", user.getFullName());
                
                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);
                
                System.out.println("User '" + username + "' logged in successfully as " + user.getUserType());
                
                // Redirect to appropriate dashboard or requested page
                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                } else {
                    redirectToDashboard(request, response, user);
                }
                
            } else {
                // Authentication failed
                System.out.println("Authentication failed for username: " + username);
                request.setAttribute("errorMessage", "Invalid username or password");
                request.setAttribute("username", username); // Preserve username
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error during authentication: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during login. Please try again.");
            request.setAttribute("username", username); // Preserve username
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Redirects user to appropriate dashboard based on their role
     * 
     * @param response The HTTP response
     * @param user The authenticated user
     * @throws IOException if redirect fails
     */
    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        String contextPath = request != null ? request.getContextPath() : "";

        switch (user.getUserType()) {
            case ADMIN:
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case TEACHER:
                response.sendRedirect(contextPath + "/teacher/dashboard");
                break;
            case STUDENT:
                response.sendRedirect(contextPath + "/student/dashboard");
                break;
            default:
                response.sendRedirect(contextPath + "/login.jsp?error=invalid_role");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Login Servlet for Course Management System";
    }
}
