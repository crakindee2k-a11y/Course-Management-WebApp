package com.coursemanagement.servlet;

import com.coursemanagement.dao.UserDAO;
import com.coursemanagement.model.User;
import com.coursemanagement.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * User Management Servlet for admin operations.
 * 
 * This servlet handles user management operations including viewing all users,
 * creating new users, and managing user accounts.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class UserManagementServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        System.out.println("UserManagementServlet initialized successfully");
    }
    
    /**
     * Handles GET requests - displays the user management page
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
            // Get all users
            List<User> allUsers = userDAO.getAllUsers();
            
            // Separate users by type
            List<User> students = userDAO.findByUserType(User.UserType.STUDENT);
            List<User> teachers = userDAO.findByUserType(User.UserType.TEACHER);
            List<User> admins = userDAO.findByUserType(User.UserType.ADMIN);
            
            // Set attributes for JSP
            request.setAttribute("allUsers", allUsers);
            request.setAttribute("students", students);
            request.setAttribute("teachers", teachers);
            request.setAttribute("admins", admins);
            request.setAttribute("totalUsers", allUsers.size());
            request.setAttribute("totalStudents", students.size());
            request.setAttribute("totalTeachers", teachers.size());
            request.setAttribute("totalAdmins", admins.size());
            
            // Forward to user management JSP
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in UserManagementServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading user management. Please try again.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests - processes user management operations
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
            if ("createUser".equals(action)) {
                handleCreateUser(request, response);
            } else if ("deleteUser".equals(action)) {
                handleDeleteUser(request, response);
            } else if ("bulkDelete".equals(action)) {
                handleBulkDeleteUsers(request, response);
            } else if ("bulkChangeType".equals(action)) {
                handleBulkChangeUserType(request, response);
            } else {
                request.setAttribute("errorMessage", "Invalid action specified.");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error in UserManagementServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing the request. Please try again.");
            doGet(request, response);
        }
    }
    
    /**
     * Handles user creation
     */
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String userType = request.getParameter("userType");
        
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            userType == null || userType.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            doGet(request, response);
            return;
        }
        
        // Check if username already exists
        if (userDAO.findByUsername(username.trim()) != null) {
            request.setAttribute("errorMessage", "Username already exists. Please choose a different username.");
            doGet(request, response);
            return;
        }
        
        // Create new user
        User newUser = new User();
        newUser.setUsername(username.trim());

        String trimmedPassword = password.trim();
        String passwordValidationError = PasswordUtil.getPasswordValidationError(trimmedPassword);
        if (passwordValidationError != null) {
            request.setAttribute("errorMessage", passwordValidationError);
            doGet(request, response);
            return;
        }

        newUser.setPassword(PasswordUtil.hashPassword(trimmedPassword));
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim());
        newUser.setUserType(User.UserType.valueOf(userType.toUpperCase()));
        
        int userId = userDAO.createUser(newUser);
        if (userId > 0) {
            request.setAttribute("successMessage", "User created successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to create user. Please try again.");
        }
        
        doGet(request, response);
    }
    
    /**
     * Handles user deletion
     */
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "User ID is required.");
            doGet(request, response);
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            // Prevent admin from deleting themselves
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            if (userId == currentUser.getUserId()) {
                request.setAttribute("errorMessage", "You cannot delete your own account.");
                doGet(request, response);
                return;
            }
            
            if (userDAO.deleteUser(userId)) {
                request.setAttribute("successMessage", "User deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete user. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid user ID.");
        }
        
        doGet(request, response);
    }
    
    /**
     * Bulk delete users selected in the admin UI.
     */
    private void handleBulkDeleteUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get array of user IDs to delete
        String[] userIds = request.getParameterValues("userIds");
        
        if (userIds == null || userIds.length == 0) {
            request.setAttribute("errorMessage", "No users selected for deletion");
            doGet(request, response);
            return;
        }
        
        int successCount = 0;
        int failureCount = 0;
        StringBuilder errorDetails = new StringBuilder();
        
        // Process each user ID
        for (String userIdStr : userIds) {
            try {
                int userId = Integer.parseInt(userIdStr);
                User user = userDAO.findById(userId);
                
                if (user != null) {
                    // Safety check - don't delete admin users
                    if (user.isAdmin()) {
                        failureCount++;
                        errorDetails.append("Cannot delete admin user ")
                                  .append(user.getUsername()).append(". ");
                    } else {
                        // Safe to delete
                        if (userDAO.deleteUser(userId)) {
                            successCount++;
                        } else {
                            failureCount++;
                            errorDetails.append("Failed to delete user ")
                                      .append(user.getUsername()).append(". ");
                        }
                    }
                } else {
                    failureCount++;
                    errorDetails.append("User with ID ").append(userId)
                              .append(" not found. ");
                }
                
            } catch (NumberFormatException e) {
                failureCount++;
                errorDetails.append("Invalid user ID: ").append(userIdStr).append(". ");
            }
        }
        
        // Set appropriate success/error messages
        if (successCount > 0 && failureCount == 0) {
            request.setAttribute("successMessage", 
                successCount + " user(s) deleted successfully");
        } else if (successCount > 0 && failureCount > 0) {
            request.setAttribute("warningMessage", 
                successCount + " user(s) deleted successfully, " + 
                failureCount + " failed. " + errorDetails.toString());
        } else {
            request.setAttribute("errorMessage", 
                "Failed to delete users: " + errorDetails.toString());
        }
        
        doGet(request, response);
    }
    
    /**
     * Bulk change user type for selected users.
     */
    private void handleBulkChangeUserType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String[] userIds = request.getParameterValues("userIds");
        String newUserTypeStr = request.getParameter("newUserType");
        
        if (userIds == null || userIds.length == 0) {
            request.setAttribute("errorMessage", "No users selected");
            doGet(request, response);
            return;
        }
        
        if (newUserTypeStr == null || newUserTypeStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No user type specified");
            doGet(request, response);
            return;
        }
        
        try {
            User.UserType newUserType = User.UserType.valueOf(newUserTypeStr.toUpperCase());
            
            int successCount = 0;
            int failureCount = 0;
            StringBuilder errorDetails = new StringBuilder();
            
            // Update user type for each selected user
            for (String userIdStr : userIds) {
                try {
                    int userId = Integer.parseInt(userIdStr);
                    User user = userDAO.findById(userId);
                    
                    if (user != null) {
                        // Safety check - don't change admin users
                        if (user.isAdmin()) {
                            failureCount++;
                            errorDetails.append("Cannot change admin user ")
                                      .append(user.getUsername()).append(". ");
                        } else {
                            // Update the user type
                            user.setUserType(newUserType);
                            if (userDAO.updateUser(user)) {
                                successCount++;
                            } else {
                                failureCount++;
                                errorDetails.append("Failed to update user ")
                                          .append(user.getUsername()).append(". ");
                            }
                        }
                    } else {
                        failureCount++;
                        errorDetails.append("User with ID ").append(userId)
                                  .append(" not found. ");
                    }
                    
                } catch (NumberFormatException e) {
                    failureCount++;
                    errorDetails.append("Invalid user ID: ").append(userIdStr).append(". ");
                }
            }
            
            if (successCount > 0 && failureCount == 0) {
                request.setAttribute("successMessage", 
                    successCount + " user(s) changed to " + newUserType.name() + " successfully");
            } else if (successCount > 0) {
                request.setAttribute("warningMessage", 
                    successCount + " users updated successfully, " + failureCount + 
                    " failed. " + errorDetails.toString());
            } else {
                request.setAttribute("errorMessage", 
                    "Failed to update user types: " + errorDetails.toString());
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Invalid user type: " + newUserTypeStr);
            doGet(request, response);
        }
        
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "User Management Servlet for Course Management System";
    }
}
