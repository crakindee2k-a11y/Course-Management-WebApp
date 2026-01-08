package com.coursemanagement.servlet;

import com.coursemanagement.dao.UserDAO;
import com.coursemanagement.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Profile Servlet for user profile management.
 * 
 * This servlet handles user profile operations including password changes,
 * username changes (for teachers and students), and profile updates.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        System.out.println("ProfileServlet initialized successfully");
    }
    
    /**
     * Handles GET requests - displays the profile page
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
        
        try {
            // Set current user for JSP
            request.setAttribute("currentUser", currentUser);
            
            // Forward to appropriate profile JSP based on user type
            String userType = currentUser.getUserType().name().toLowerCase();
            request.getRequestDispatcher("/" + userType + "/profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in ProfileServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading profile. Please try again.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests - processes profile updates
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
        String action = request.getParameter("action");
        
        try {
            if ("changePassword".equals(action)) {
                handleChangePassword(request, response, currentUser);
            } else if ("changeUsername".equals(action)) {
                handleChangeUsername(request, response, currentUser);
            } else if ("updateProfile".equals(action)) {
                handleUpdateProfile(request, response, currentUser);
            } else {
                request.setAttribute("errorMessage", "Invalid action specified.");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error in ProfileServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating profile. Please try again.");
            doGet(request, response);
        }
    }
    
    /**
     * Handles password change
     */
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All password fields are required.");
            doGet(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirmation do not match.");
            doGet(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "New password must be at least 6 characters long.");
            doGet(request, response);
            return;
        }
        
        // Verify current password
        if (!com.coursemanagement.util.PasswordUtil.verifyPassword(currentPassword, currentUser.getPassword())) {
            request.setAttribute("errorMessage", "Current password is incorrect.");
            doGet(request, response);
            return;
        }
        
        // Change password
        if (userDAO.changePassword(currentUser.getUserId(), newPassword)) {
            // Update the user object in session
            currentUser.setPassword(com.coursemanagement.util.PasswordUtil.hashPassword(newPassword));
            request.setAttribute("successMessage", "Password changed successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to change password. Please try again.");
        }
        
        doGet(request, response);
    }
    
    /**
     * Handles username change (only for teachers and students)
     */
    private void handleChangeUsername(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        // Check if user is allowed to change username (teachers and students only)
        if (currentUser.getUserType() == User.UserType.ADMIN) {
            request.setAttribute("errorMessage", "Admins cannot change their username.");
            doGet(request, response);
            return;
        }
        
        String newUsername = request.getParameter("newUsername");
        
        // Validate input
        if (newUsername == null || newUsername.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username is required.");
            doGet(request, response);
            return;
        }
        
        newUsername = newUsername.trim();
        
        if (newUsername.length() < 3) {
            request.setAttribute("errorMessage", "Username must be at least 3 characters long.");
            doGet(request, response);
            return;
        }
        
        if (newUsername.equals(currentUser.getUsername())) {
            request.setAttribute("errorMessage", "New username must be different from current username.");
            doGet(request, response);
            return;
        }
        
        // Change username
        if (userDAO.changeUsername(currentUser.getUserId(), newUsername)) {
            // Update the user object in session
            currentUser.setUsername(newUsername);
            request.setAttribute("successMessage", "Username changed successfully!");
        } else {
            request.setAttribute("errorMessage", "Username already exists or failed to change. Please try a different username.");
        }
        
        doGet(request, response);
    }
    
    /**
     * Handles profile information update
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        
        // Validate input
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Full name and email are required.");
            doGet(request, response);
            return;
        }
        
        fullName = fullName.trim();
        email = email.trim();
        
        // Basic email validation
        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("errorMessage", "Please enter a valid email address.");
            doGet(request, response);
            return;
        }
        
        // Update user profile
        currentUser.setFullName(fullName);
        currentUser.setEmail(email);
        
        if (userDAO.updateUserProfile(currentUser)) {
            request.setAttribute("successMessage", "Profile updated successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
        }
        
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Profile Servlet for Course Management System";
    }
}

