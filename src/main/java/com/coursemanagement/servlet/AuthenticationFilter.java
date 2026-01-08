package com.coursemanagement.servlet;

import com.coursemanagement.model.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication filter to protect secured areas of the application.
 * 
 * This filter checks if a user is authenticated before allowing access to
 * protected resources. It redirects unauthenticated users to the login page.
 * 
 * @author CSE-446 Web Engineering Lab Group
 * @version 1.0
 */
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
        System.out.println("AuthenticationFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Get the requested URI
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path from URI to get the relative path
        String relativePath = requestURI.substring(contextPath.length());
        
        // Check if user is authenticated
        HttpSession session = httpRequest.getSession(false);
        User currentUser = null;
        
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
        }
        
        // If user is not authenticated, redirect to login
        if (currentUser == null) {
            System.out.println("Unauthenticated access attempt to: " + relativePath);
            httpResponse.sendRedirect(contextPath + "/login.jsp?redirect=" + 
                                    java.net.URLEncoder.encode(relativePath, "UTF-8"));
            return;
        }
        
        // Check role-based access
        if (!hasAccess(currentUser, relativePath)) {
            System.out.println("Access denied for user " + currentUser.getUsername() + 
                             " to: " + relativePath);
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // User is authenticated and has access, continue with the request
        chain.doFilter(request, response);
    }
    
    /**
     * Checks if a user has access to a specific path based on their role
     * 
     * @param user The authenticated user
     * @param path The requested path
     * @return true if user has access, false otherwise
     */
    private boolean hasAccess(User user, String path) {
        // Admin can access everything
        if (user.isAdmin()) {
            return true;
        }
        
        // Check teacher access
        if (user.isTeacher()) {
            return path.startsWith("/teacher/");
        }
        
        // Check student access
        if (user.isStudent()) {
            return path.startsWith("/student/");
        }
        
        // Default deny
        return false;
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
        System.out.println("AuthenticationFilter destroyed");
    }
}
