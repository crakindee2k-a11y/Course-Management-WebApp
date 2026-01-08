<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Course Management System</title>
    
    <!-- Apply theme before CSS to prevent flash -->
    <%@ include file="/WEB-INF/jspf/theme-init.jspf" %>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css?v=<%="2024"%>" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/premium-nav.css?v=<%="2024"%>" rel="stylesheet">
    
    <!-- Theme System Script -->
    <script src="${pageContext.request.contextPath}/js/theme-system.js"></script>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-mortarboard-fill me-2"></i>
                Course Management System
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-1"></i>Manage Participants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/courses">
                            <i class="bi bi-book me-1"></i>Manage Courses
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-1"></i>
                            ${sessionScope.fullName}
                        </a>
                        <ul class="dropdown-menu">
                            <li><h6 class="dropdown-header">Logged in as Admin</h6></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="bi bi-person-circle me-2"></i>Profile
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>Logout
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container-fluid mt-4 admin-dashboard-premium">
        <!-- Hero Welcome Section -->
        <div class="hero-section mb-5">
            <div class="hero-content">
                <div class="hero-background">
                    <div class="floating-element fe-1"></div>
                    <div class="floating-element fe-2"></div>
                    <div class="floating-element fe-3"></div>
                    <div class="floating-element fe-4"></div>
                </div>
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <div class="hero-text">
                                <h1 class="hero-title">
                                    <span class="gradient-text">Welcome back,</span>
                                    <br>
                                    <span class="hero-name">${sessionScope.fullName}</span>
                                </h1>
                                <p class="hero-subtitle">
                                    Command center for your educational empire. Monitor, manage, and maximize your course management system's potential.
                                </p>
                                <div class="hero-stats-mini">
                                    <div class="mini-stat">
                                        <span class="mini-stat-number">${totalStudents}</span>
                                        <span class="mini-stat-label">Students</span>
                                    </div>
                                    <div class="mini-stat">
                                        <span class="mini-stat-number">${totalCourses}</span>
                                        <span class="mini-stat-label">Courses</span>
                                    </div>
                                    <div class="mini-stat">
                                        <span class="mini-stat-number">${totalTeachers}</span>
                                        <span class="mini-stat-label">Teachers</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="hero-visual">
                                <div class="dashboard-globe">
                                    <div class="globe-ring ring-1"></div>
                                    <div class="globe-ring ring-2"></div>
                                    <div class="globe-ring ring-3"></div>
                                    <div class="globe-center">
                                        <i class="bi bi-mortarboard-fill"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Statistics Cards - Premium Glass Design -->
        <div class="container mb-5">
            <div class="stats-grid">
                <a href="${pageContext.request.contextPath}/admin/users" class="glass-card stat-card-premium" data-stat="students">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-primary">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number" data-target="${totalStudents}">0</span>
                            <div class="stat-trend up">
                                <i class="bi bi-arrow-up"></i>
                                <span>+12%</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Students</h3>
                        <p class="stat-subtitle">Active learners in system</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 75"/>
                        </svg>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/users" class="glass-card stat-card-premium" data-stat="teachers">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-success">
                            <i class="bi bi-person-workspace"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number" data-target="${totalTeachers}">0</span>
                            <div class="stat-trend up">
                                <i class="bi bi-arrow-up"></i>
                                <span>+5%</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Teachers</h3>
                        <p class="stat-subtitle">Expert instructors</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 90"/>
                        </svg>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/courses" class="glass-card stat-card-premium" data-stat="courses">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-info">
                            <i class="bi bi-book-fill"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number" data-target="${totalCourses}">0</span>
                            <div class="stat-trend up">
                                <i class="bi bi-arrow-up"></i>
                                <span>+8%</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Courses</h3>
                        <p class="stat-subtitle">Learning pathways</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 65"/>
                        </svg>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/enrollments" class="glass-card stat-card-premium" data-stat="enrollments">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-warning">
                            <i class="bi bi-journal-check"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number" data-target="${totalEnrollments}">0</span>
                            <div class="stat-trend up">
                                <i class="bi bi-arrow-up"></i>
                                <span>+15%</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Enrollments</h3>
                        <p class="stat-subtitle">Active registrations</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 85"/>
                        </svg>
                    </div>
                </a>
            </div>
        </div>
        
        <!-- Advanced Analytics Section -->
        <div class="container mb-5">
            <div class="analytics-section">
                <div class="row g-4">
                    <div class="col-lg-6">
                        <div class="glass-card analytics-card interactive-card" id="assignmentCard">
                            <div class="analytics-header">
                                <h3><i class="bi bi-graph-up me-2"></i>Teacher Assignment Analytics
                                    <% if ((Boolean)request.getAttribute("hasUnassignedCourses")) { %>
                                        <span class="badge bg-warning ms-2">Action Required</span>
                                    <% } %>
                                </h3>
                                <div class="analytics-controls">
                                    <button class="btn btn-sm btn-outline-primary" onclick="toggleAssignmentDetails()">
                                        <i class="bi bi-eye me-1"></i>View Details
                                    </button>
                                </div>
                            </div>
                            <div class="analytics-content">
                                <!-- Summary View -->
                                <div class="assignment-visual" id="assignmentSummary">
                                    <div class="circular-progress-container">
                                        <svg class="circular-progress" width="180" height="180">
                                            <defs>
                                                <linearGradient id="assignmentGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                                                    <stop offset="0%" style="stop-color:#10b981;stop-opacity:1" />
                                                    <stop offset="100%" style="stop-color:#059669;stop-opacity:1" />
                                                </linearGradient>
                                            </defs>
                                            <circle class="progress-bg" cx="90" cy="90" r="70"/>
                                            <circle class="progress-fill" cx="90" cy="90" r="70" 
                                                    style="--progress: ${(coursesWithTeachers * 100) / totalCourses}" 
                                                    stroke="url(#assignmentGradient)"/>
                                        </svg>
                                        <div class="progress-center">
                                            <span class="progress-percentage">
                                                <fmt:formatNumber value="${(coursesWithTeachers * 100) / totalCourses}" maxFractionDigits="0"/>%
                                            </span>
                                            <span class="progress-label">Assigned</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="assignment-stats">
                                    <div class="stat-item assigned">
                                        <i class="bi bi-check-circle-fill"></i>
                                        <div class="stat-details">
                                            <span class="stat-value">${coursesWithTeachers}</span>
                                            <span class="stat-label">Assigned Courses</span>
                                        </div>
                                    </div>
                                    <div class="stat-item unassigned">
                                        <i class="bi bi-exclamation-triangle-fill"></i>
                                        <div class="stat-details">
                                            <span class="stat-value">${coursesWithoutTeachers}</span>
                                            <span class="stat-label">Unassigned Courses</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Interactive Details View -->
                                <div class="assignment-details" id="assignmentDetails" style="display: none;">
                                    <% if ((Boolean)request.getAttribute("hasUnassignedCourses")) { %>
                                        <div class="alert alert-warning d-flex align-items-center mb-3">
                                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                            <div>
                                                <strong>${coursesWithoutTeachers} courses need teacher assignment</strong><br>
                                                <small>These courses cannot start without assigned teachers.</small>
                                            </div>
                                        </div>
                                        
                                        <div class="unassigned-courses-list">
                                            <h6 class="mb-3"><i class="bi bi-list-ul me-2"></i>Unassigned Courses</h6>
                                            <% 
                                            java.util.List<com.coursemanagement.model.Course> unassignedCourses = 
                                                (java.util.List<com.coursemanagement.model.Course>) request.getAttribute("unassignedCourses");
                                            int displayCount = 0;
                                            for (com.coursemanagement.model.Course course : unassignedCourses) {
                                                if (displayCount >= 3) break; // Show only first 3
                                                displayCount++;
                                            %>
                                                <div class="course-item d-flex justify-content-between align-items-center mb-2 p-2 border rounded">
                                                    <div>
                                                        <strong><%= course.getCourseCode() %></strong> - <%= course.getCourseName() %>
                                                        <br><small class="text-muted"><%= course.getCredits() %> credits, Max: <%= course.getMaxStudents() %> students</small>
                                                    </div>
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=<%= course.getCourseId() %>" 
                                                           class="btn btn-sm btn-primary">
                                                            <i class="bi bi-person-plus-fill me-1"></i>Assign Teacher
                                                        </a>
                                                    </div>
                                                </div>
                                            <% } %>
                                            
                                            <% if (unassignedCourses.size() > 3) { %>
                                                <div class="text-center mt-3">
                                                    <a href="${pageContext.request.contextPath}/admin/courses?filter=unassigned" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="bi bi-plus-circle me-1"></i>View All <%= unassignedCourses.size() %> Unassigned Courses
                                                    </a>
                                                </div>
                                            <% } %>
                                        </div>
                                        
                                        <div class="quick-actions mt-4 pt-3 border-top">
                                            <h6 class="mb-2">Quick Actions</h6>
                                            <div class="d-grid gap-2 d-md-flex">
                                                <a href="${pageContext.request.contextPath}/admin/courses?action=bulk-assign" class="btn btn-success btn-sm">
                                                    <i class="bi bi-lightning-fill me-1"></i>Auto-Assign Available Teachers
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/users?filter=teachers" class="btn btn-info btn-sm">
                                                    <i class="bi bi-people-fill me-1"></i>Manage Teachers
                                                </a>
                                            </div>
                                        </div>
                                    <% } else { %>
                                        <div class="alert alert-success d-flex align-items-center">
                                            <i class="bi bi-check-circle-fill me-2"></i>
                                            <div>
                                                <strong>All courses have teachers assigned!</strong><br>
                                                <small>Your teacher assignment is complete.</small>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-6">
                        <div class="glass-card analytics-card interactive-card" id="capacityCard">
                            <div class="analytics-header">
                                <h3><i class="bi bi-bar-chart me-2"></i>Course Capacity Overview
                                    <% if ((Boolean)request.getAttribute("hasCapacityIssues")) { %>
                                        <span class="badge bg-danger ms-2">Issues Found</span>
                                    <% } %>
                                </h3>
                                <div class="analytics-controls">
                                    <button class="btn btn-sm btn-outline-info" onclick="toggleCapacityDetails()">
                                        <i class="bi bi-eye me-1"></i>View Details
                                    </button>
                                </div>
                            </div>
                            <div class="analytics-content">
                                <!-- Summary View -->
                                <div class="capacity-visual" id="capacitySummary">
                                    <div class="capacity-bars">
                                        <div class="capacity-bar">
                                            <div class="bar-label">Available</div>
                                            <div class="bar-container">
                                                <div class="bar-fill available" style="--width: ${(availableCourses * 100) / totalCourses}%"></div>
                                                <span class="bar-value">${availableCourses}</span>
                                            </div>
                                        </div>
                                        <div class="capacity-bar">
                                            <div class="bar-label">Full</div>
                                            <div class="bar-container">
                                                <div class="bar-fill full" style="--width: ${(fullCourses * 100) / totalCourses}%"></div>
                                                <span class="bar-value">${fullCourses}</span>
                                            </div>
                                        </div>
                                        <div class="capacity-bar">
                                            <div class="bar-label">Near Full (80%+)</div>
                                            <div class="bar-container">
                                                <div class="bar-fill warning" style="--width: ${(fn:length(lowCapacityCourses) * 100) / totalCourses}%"></div>
                                                <span class="bar-value">${fn:length(lowCapacityCourses)}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="capacity-insights">
                                    <div class="insight-item">
                                        <div class="insight-icon success">
                                            <i class="bi bi-door-open-fill"></i>
                                        </div>
                                        <div class="insight-text">
                                            <span class="insight-title">Availability Rate</span>
                                            <span class="insight-value">
                                                <fmt:formatNumber value="${(availableCourses * 100) / totalCourses}" maxFractionDigits="0"/>%
                                            </span>
                                        </div>
                                    </div>
                                    <div class="insight-item">
                                        <div class="insight-icon warning">
                                            <i class="bi bi-speedometer2"></i>
                                        </div>
                                        <div class="insight-text">
                                            <span class="insight-title">Utilization</span>
                                            <span class="insight-value">
                                                <% if ((Boolean)request.getAttribute("hasCapacityIssues")) { %>
                                                    Critical
                                                <% } else { %>
                                                    Optimal
                                                <% } %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Interactive Details View -->
                                <div class="capacity-details" id="capacityDetails" style="display: none;">
                                    <% if ((Boolean)request.getAttribute("hasCapacityIssues")) { %>
                                        <div class="alert alert-danger d-flex align-items-center mb-3">
                                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                            <div>
                                                <strong>Capacity issues detected!</strong><br>
                                                <small>${fullCourses} courses are full, ${fn:length(lowCapacityCourses)} are near capacity.</small>
                                            </div>
                                        </div>
                                        
                                        <!-- Full Courses -->
                                        <% 
                                        java.util.List<com.coursemanagement.model.Course> fullCapacityCourses = 
                                            (java.util.List<com.coursemanagement.model.Course>) request.getAttribute("fullCapacityCourses");
                                        if (fullCapacityCourses != null && !fullCapacityCourses.isEmpty()) { 
                                        %>
                                            <div class="full-courses-list mb-4">
                                                <h6 class="mb-3 text-danger"><i class="bi bi-x-circle-fill me-2"></i>Full Capacity Courses</h6>
                                                <% 
                                                int fullDisplayCount = 0;
                                                for (com.coursemanagement.model.Course course : fullCapacityCourses) {
                                                    if (fullDisplayCount >= 2) break; // Show only first 2
                                                    fullDisplayCount++;
                                                %>
                                                    <div class="course-item d-flex justify-content-between align-items-center mb-2 p-2 border border-danger rounded">
                                                        <div>
                                                            <strong><%= course.getCourseCode() %></strong> - <%= course.getCourseName() %>
                                                            <br><small class="text-muted"><%= course.getEnrolledStudents() %>/<%= course.getMaxStudents() %> students (100% full)</small>
                                                        </div>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=<%= course.getCourseId() %>" 
                                                               class="btn btn-sm btn-warning">
                                                                <i class="bi bi-plus-square me-1"></i>Edit Course
                                                            </a>
                                                        </div>
                                                    </div>
                                                <% } %>
                                            </div>
                                        <% } %>
                                        
                                        <!-- Near Full Courses -->
                                        <% 
                                        java.util.List<com.coursemanagement.model.Course> lowCapacityCourses = 
                                            (java.util.List<com.coursemanagement.model.Course>) request.getAttribute("lowCapacityCourses");
                                        if (lowCapacityCourses != null && !lowCapacityCourses.isEmpty()) { 
                                        %>
                                            <div class="low-capacity-courses-list mb-4">
                                                <h6 class="mb-3 text-warning"><i class="bi bi-exclamation-triangle me-2"></i>Near Full Courses (80%+)</h6>
                                                <% 
                                                int lowDisplayCount = 0;
                                                for (com.coursemanagement.model.Course course : lowCapacityCourses) {
                                                    if (lowDisplayCount >= 2) break; // Show only first 2
                                                    lowDisplayCount++;
                                                    double capacityPercent = ((double)course.getEnrolledStudents() / course.getMaxStudents()) * 100;
                                                %>
                                                    <div class="course-item d-flex justify-content-between align-items-center mb-2 p-2 border border-warning rounded">
                                                        <div>
                                                            <strong><%= course.getCourseCode() %></strong> - <%= course.getCourseName() %>
                                                            <br><small class="text-muted"><%= course.getEnrolledStudents() %>/<%= course.getMaxStudents() %> students (<fmt:formatNumber value="<%= capacityPercent %>" maxFractionDigits="0"/>% full)</small>
                                                        </div>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/admin/enrollments?courseId=<%= course.getCourseId() %>" 
                                                               class="btn btn-sm btn-info">
                                                                <i class="bi bi-people-fill me-1"></i>Manage Enrollments
                                                            </a>
                                                        </div>
                                                    </div>
                                                <% } %>
                                            </div>
                                        <% } %>
                                        
                                        <div class="quick-actions mt-4 pt-3 border-top">
                                            <h6 class="mb-2">Quick Actions</h6>
                                            <div class="d-grid gap-2 d-md-flex">
                                                <a href="${pageContext.request.contextPath}/admin/courses?action=capacity-report" class="btn btn-success btn-sm">
                                                    <i class="bi bi-file-earmark-text me-1"></i>Generate Capacity Report
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/courses?action=bulk-expand" class="btn btn-warning btn-sm">
                                                    <i class="bi bi-arrows-expand me-1"></i>Bulk Expand Capacity
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/enrollments" class="btn btn-info btn-sm">
                                                    <i class="bi bi-gear-fill me-1"></i>Manage All Enrollments
                                                </a>
                                            </div>
                                        </div>
                                    <% } else { %>
                                        <div class="alert alert-success d-flex align-items-center">
                                            <i class="bi bi-check-circle-fill me-2"></i>
                                            <div>
                                                <strong>Course capacity is well managed!</strong><br>
                                                <small>No immediate capacity issues detected.</small>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Courses - Premium Table -->
        <div class="container">
            <div class="glass-card data-table-card">
                <div class="table-header">
                    <div class="table-title">
                        <h3><i class="bi bi-book me-2"></i>All Courses</h3>
                        <p class="table-subtitle">Complete course catalog and status overview</p>
                    </div>
                    <div class="table-actions">
                        <div class="search-container">
                            <i class="bi bi-search"></i>
                            <input type="text" id="searchInput" placeholder="Search courses..." class="search-input" onkeyup="filterTable()">
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-primary btn-premium">
                            <i class="bi bi-plus-circle me-2"></i>Manage Courses
                        </a>
                    </div>
                </div>
                <div class="table-content">
                        <c:choose>
                            <c:when test="${empty courses}">
                                <div class="text-center py-4">
                                    <i class="bi bi-book text-muted" style="font-size: 3rem;"></i>
                                    <h5 class="mt-3 text-muted">No courses found</h5>
                                    <p class="text-muted">Start by creating your first course.</p>
                                    <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-primary">
                                        <i class="bi bi-plus-circle me-2"></i>Add Course
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="premium-table-container">
                                    <table class="table premium-table">
                                        <thead>
                                            <tr>
                                                <th>Course Code</th>
                                                <th>Course Name</th>
                                                <th>Teacher</th>
                                                <th>Enrolled</th>
                                                <th>Capacity</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="coursesTableBody">
                                            <c:forEach var="course" items="${courses}">
                                                <tr>
                                                    <td>
                                                        <span class="badge bg-primary">${course.courseCode}</span>
                                                    </td>
                                                    <td>
                                                        <strong>${course.courseName}</strong>
                                                        <br>
                                                        <small class="text-muted">${course.credits} credits</small>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty course.teacherName}">
                                                                <i class="bi bi-person-check text-success me-1"></i>
                                                                ${course.teacherName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-danger">
                                                                    <i class="bi bi-person-x me-1"></i>
                                                                    Not assigned
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="fw-bold">${course.enrolledStudents}</span>
                                                    </td>
                                                    <td>
                                                        <span class="text-muted">${course.maxStudents}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${course.enrolledStudents >= course.maxStudents}">
                                                                <span class="badge bg-warning">Full</span>
                                                            </c:when>
                                                            <c:when test="${course.enrolledStudents > 0}">
                                                                <span class="badge bg-success">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Empty</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Premium Dashboard JavaScript -->
    <script>
        // Animated Counter Function
        function animateCounters() {
            const counters = document.querySelectorAll('.stat-number[data-target]');
            
            counters.forEach(counter => {
                const target = parseInt(counter.getAttribute('data-target'));
                const duration = 2000;
                const increment = target / (duration / 16);
                let current = 0;
                
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        counter.textContent = target;
                        clearInterval(timer);
                    } else {
                        counter.textContent = Math.floor(current);
                    }
                }, 16);
            });
        }
        
        // Progress Ring Animation
        function animateProgressRings() {
            const rings = document.querySelectorAll('.progress-ring-fill');
            rings.forEach(ring => {
                const progress = ring.style.getPropertyValue('--progress');
                ring.style.setProperty('--progress', 0);
                
                setTimeout(() => {
                    ring.style.setProperty('--progress', progress);
                }, 500);
            });
        }
        
        // Circular Progress Animation
        function animateCircularProgress() {
            const circles = document.querySelectorAll('.progress-fill');
            circles.forEach(circle => {
                const progress = circle.style.getPropertyValue('--progress');
                const circumference = 2 * Math.PI * 70;
                const offset = circumference - (progress / 100) * circumference;
                
                circle.style.strokeDasharray = circumference;
                circle.style.strokeDashoffset = circumference;
                
                setTimeout(() => {
                    circle.style.strokeDashoffset = offset;
                }, 1000);
            });
        }
        
        // Capacity Bar Animation
        function animateCapacityBars() {
            const bars = document.querySelectorAll('.bar-fill');
            bars.forEach(bar => {
                const width = bar.style.getPropertyValue('--width');
                bar.style.setProperty('--width', '0%');
                
                setTimeout(() => {
                    bar.style.setProperty('--width', width);
                }, 1500);
            });
        }
        
        // Table management variables (copied from enrollment page pattern)
        let allRows = [];
        let filteredRows = [];

        // Initialize animations and table when page loads
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(animateCounters, 500);
            setTimeout(animateProgressRings, 800);
            setTimeout(animateCircularProgress, 1000);
            setTimeout(animateCapacityBars, 1200);
            
            // Initialize table for search
            initializeTable();
        });

        function initializeTable() {
            const tableBody = document.getElementById('coursesTableBody');
            allRows = Array.from(tableBody.querySelectorAll('tr'));
            filteredRows = [...allRows];
        }

        function filterTable() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();

            filteredRows = allRows.filter(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length === 0) return false;

                // Search in course code, course name, and teacher
                const courseCode = cells[0].textContent.toLowerCase();
                const courseName = cells[1].textContent.toLowerCase();
                const teacherName = cells[2].textContent.toLowerCase();

                const matchesSearch = searchTerm === '' || 
                    courseCode.includes(searchTerm) || 
                    courseName.includes(searchTerm) || 
                    teacherName.includes(searchTerm);

                return matchesSearch;
            });

            updateDisplay();
        }

        function updateDisplay() {
            const tableBody = document.getElementById('coursesTableBody');
            const totalRows = filteredRows.length;

            // Clear current table
            tableBody.innerHTML = '';

            if (totalRows === 0) {
                tableBody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">No courses found</td></tr>';
                return;
            }

            // Show all filtered rows (no pagination needed for dashboard)
            for (let i = 0; i < totalRows; i++) {
                tableBody.appendChild(filteredRows[i].cloneNode(true));
            }
        }
        
        // Interactive Analytics Cards Functions
        function toggleAssignmentDetails() {
            const summaryView = document.getElementById('assignmentSummary');
            const detailsView = document.getElementById('assignmentDetails');
            const button = document.querySelector('#assignmentCard .analytics-controls button');
            
            if (detailsView.style.display === 'none') {
                summaryView.style.display = 'none';
                detailsView.style.display = 'block';
                button.innerHTML = '<i class="bi bi-eye-slash me-1"></i>Hide Details';
                button.classList.remove('btn-outline-primary');
                button.classList.add('btn-primary');
            } else {
                summaryView.style.display = 'block';
                detailsView.style.display = 'none';
                button.innerHTML = '<i class="bi bi-eye me-1"></i>View Details';
                button.classList.remove('btn-primary');
                button.classList.add('btn-outline-primary');
            }
        }
        
        function toggleCapacityDetails() {
            const summaryView = document.getElementById('capacitySummary');
            const detailsView = document.getElementById('capacityDetails');
            const button = document.querySelector('#capacityCard .analytics-controls button');
            
            if (detailsView.style.display === 'none') {
                summaryView.style.display = 'none';
                detailsView.style.display = 'block';
                button.innerHTML = '<i class="bi bi-eye-slash me-1"></i>Hide Details';
                button.classList.remove('btn-outline-info');
                button.classList.add('btn-info');
            } else {
                summaryView.style.display = 'block';
                detailsView.style.display = 'none';
                button.innerHTML = '<i class="bi bi-eye me-1"></i>View Details';
                button.classList.remove('btn-info');
                button.classList.add('btn-outline-info');
            }
        }
    </script>
</body>
</html>
