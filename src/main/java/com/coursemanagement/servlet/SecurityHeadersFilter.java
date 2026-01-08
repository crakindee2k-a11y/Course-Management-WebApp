package com.coursemanagement.servlet;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Security Headers Filter to add security headers to all HTTP responses.
 * 
 * This filter adds various security headers to prevent common web security
 * vulnerabilities like XSS, clickjacking, and MIME type sniffing.
 * 
 * @author Course Management System
 * @version 2.0
 */
public class SecurityHeadersFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Content Security Policy - Helps prevent XSS attacks
        httpResponse.setHeader("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; " +
            "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; " +
            "font-src 'self' https://cdn.jsdelivr.net; " +
            "img-src 'self' data:; " +
            "connect-src 'self'");
        
        // X-Frame-Options - Prevents clickjacking
        httpResponse.setHeader("X-Frame-Options", "DENY");
        
        // X-Content-Type-Options - Prevents MIME type sniffing
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        
        // X-XSS-Protection - Legacy XSS protection for older browsers
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
        
        // Referrer-Policy - Controls how much referrer information is sent
        httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        
        // Strict-Transport-Security - Enforces HTTPS (only add if using HTTPS)
        // httpResponse.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        
        // Cache control for sensitive pages
        String requestURI = ((javax.servlet.http.HttpServletRequest) request).getRequestURI();
        if (requestURI.contains("/admin/") || requestURI.contains("/student/") || requestURI.contains("/teacher/")) {
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setHeader("Expires", "0");
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
