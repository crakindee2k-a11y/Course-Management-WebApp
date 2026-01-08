package com.coursemanagement.servlet;

import com.coursemanagement.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Logout servlet to handle user session termination.
 * 
 * This servlet logs out users by invalidating their sessions and
 * redirecting them to the login page.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class LogoutServlet extends HttpServlet {
    
    /**
     * Handles both GET and POST requests for logout
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    /**
     * Handles the logout process
     * 
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws IOException if redirect fails
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Get current session
        HttpSession session = request.getSession(false);
        
        String username = "Unknown";
        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
                username = currentUser.getUsername();
            }
            
            // Invalidate the session
            session.invalidate();
            System.out.println("User '" + username + "' logged out successfully");
        }
        
        // Redirect to login page with logout message
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=logged_out");
    }
    
    @Override
    public String getServletInfo() {
        return "Logout Servlet for Course Management System";
    }
}
