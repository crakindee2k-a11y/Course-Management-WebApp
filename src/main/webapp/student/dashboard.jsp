<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Enrollment> enrolledCourses = (List<Enrollment>) request.getAttribute("enrolledCourses");
    List<Course> availableCourses = (List<Course>) request.getAttribute("availableCourses");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/jspf/html-head.jspf" %>
    <title>Student Dashboard - Course Management System</title>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/student/dashboard">
                <i class="bi bi-mortarboard-fill me-2"></i>Course Management System
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/student/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i>Dashboard
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-1"></i>
                            <%= currentUser.getFullName() %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                <i class="bi bi-person me-2"></i>Profile
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Logout
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4 student-dashboard-premium">
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
                                    <span class="hero-name"><%= currentUser.getFullName() %></span>
                                </h1>
                                <p class="hero-subtitle">
                                    Your learning journey continues here. Track your progress, explore new courses, and achieve your academic goals.
                                </p>
                                <div class="hero-stats-mini">
                                    <div class="mini-stat">
                                        <span class="mini-stat-number">${enrolledCourses.size()}</span>
                                        <span class="mini-stat-label">Enrolled</span>
                                    </div>
                                    <div class="mini-stat">
                                        <span class="mini-stat-number">${availableCourses.size()}</span>
                                        <span class="mini-stat-label">Available</span>
                                    </div>
                                    <div class="mini-stat">
                                        <span class="mini-stat-number">4th</span>
                                        <span class="mini-stat-label">Semester</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="hero-visual">
                                <div class="student-globe">
                                    <div class="globe-ring ring-1"></div>
                                    <div class="globe-ring ring-2"></div>
                                    <div class="globe-ring ring-3"></div>
                                    <div class="globe-center">
                                        <i class="bi bi-person-circle"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Messages -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i><%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Premium Statistics Cards -->
        <div class="container mb-5">
            <div class="stats-grid">
                <a href="#enrolled-courses" class="glass-card stat-card-premium student-stat" data-stat="enrolled">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-primary">
                            <i class="bi bi-book-fill"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number" data-target="${enrolledCourses.size()}">0</span>
                            <div class="stat-trend up">
                                <i class="bi bi-arrow-up"></i>
                                <span>Active</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Enrolled Courses</h3>
                        <p class="stat-subtitle">Currently studying</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 85"/>
                        </svg>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/student/register" class="glass-card stat-card-premium student-stat" data-stat="available">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-success">
                            <i class="bi bi-plus-circle"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number" data-target="${availableCourses.size()}">0</span>
                            <div class="stat-trend up">
                                <i class="bi bi-arrow-up"></i>
                                <span>New</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Available Courses</h3>
                        <p class="stat-subtitle">Ready to enroll</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 70"/>
                        </svg>
                    </div>
                </a>

                <div class="glass-card stat-card-premium student-stat" data-stat="status">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-info">
                            <i class="bi bi-person-check"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number">Active</span>
                            <div class="stat-trend up">
                                <i class="bi bi-check-circle"></i>
                                <span>Good</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Account Status</h3>
                        <p class="stat-subtitle">All systems go</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 100"/>
                        </svg>
                    </div>
                </div>

                <div class="glass-card stat-card-premium student-stat" data-stat="semester">
                    <div class="glass-card-glow"></div>
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-warning">
                            <i class="bi bi-calendar-week"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <span class="stat-number">4th</span>
                            <div class="stat-trend up">
                                <i class="bi bi-arrow-up"></i>
                                <span>Progress</span>
                            </div>
                        </div>
                        <h3 class="stat-title">Current Semester</h3>
                        <p class="stat-subtitle">Academic term</p>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"/>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="--progress: 60"/>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Row -->
        <div class="row">
            <!-- Left Column - Main Content -->
            <div class="col-lg-8">
                <!-- My Courses -->
                <div class="row mb-4" id="enrolled-courses">
                    <div class="col-12">
                        <div class="card card-organic">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="bi bi-book-fill me-2"></i>My Enrolled Courses
                                </h5>
                            </div>
                            <div class="card-body">
                                <% if (enrolledCourses != null && !enrolledCourses.isEmpty()) { %>
                                    <div class="table-responsive premium-table-container">
                                        <table class="table premium-table">
                                            <thead>
                                                <tr>
                                                    <th>Course Code</th>
                                                    <th>Course Name</th>
                                                    <th>Teacher</th>
                                                    <th>Status</th>
                                                    <th>Enrolled Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Enrollment enrollment : enrolledCourses) { %>
                                                    <tr>
                                                        <td><strong><%= enrollment.getCourseCode() %></strong></td>
                                                        <td><%= enrollment.getCourseName() %></td>
                                                        <td><%= enrollment.getTeacherName() != null ? enrollment.getTeacherName() : "TBD" %></td>
                                                        <td>
                                                            <span class="badge <%= "ENROLLED".equalsIgnoreCase(enrollment.getStatus().toString()) || "ACTIVE".equalsIgnoreCase(enrollment.getStatus().toString()) ? "badge-status-enrolled" : 
                                                                                   "COMPLETED".equalsIgnoreCase(enrollment.getStatus().toString()) ? "badge-status-completed" : 
                                                                                   "DROPPED".equalsIgnoreCase(enrollment.getStatus().toString()) ? "badge-status-dropped" : "bg-secondary" %>">
                                                                <%= enrollment.getStatus() %>
                                                            </span>
                                                        </td>
                                                        <td><%= enrollment.getEnrollmentDate() != null ? enrollment.getEnrollmentDate().toString().split(" ")[0] : "N/A" %></td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-4">
                                        <i class="bi bi-book display-4 text-muted"></i>
                                        <h5 class="mt-3 text-muted">No Enrolled Courses</h5>
                                        <p class="text-muted">You haven't enrolled in any courses yet.</p>
                                        <a href="${pageContext.request.contextPath}/student/register" class="btn btn-primary">
                                            <i class="bi bi-plus-circle me-1"></i>Browse Courses
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Available Courses -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card card-organic">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="bi bi-plus-circle-fill me-2"></i>Available Courses
                                </h5>
                            </div>
                            <div class="card-body">
                                <% if (availableCourses != null && !availableCourses.isEmpty()) { %>
                                    <div class="table-responsive premium-table-container">
                                        <table class="table premium-table">
                                            <thead>
                                                <tr>
                                                    <th>Course Code</th>
                                                    <th>Course Name</th>
                                                    <th>Teacher</th>
                                                    <th>Credits</th>
                                                    <th>Available Seats</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Course course : availableCourses) { %>
                                                    <tr>
                                                        <td><strong><%= course.getCourseCode() %></strong></td>
                                                        <td><%= course.getCourseName() %></td>
                                                        <td><%= course.getTeacherName() %></td>
                                                        <td><%= course.getCredits() %></td>
                                                        <td>
                                                            <% if (course.getEnrolledStudents() < course.getMaxStudents()) { %>
                                                                <span class="badge bg-success">
                                                                    <%= course.getEnrolledStudents() %>/<%= course.getMaxStudents() %>
                                                                </span>
                                                            <% } else { %>
                                                                <span class="badge bg-danger">
                                                                    <%= course.getEnrolledStudents() %>/<%= course.getMaxStudents() %>
                                                                </span>
                                                            <% } %>
                                                        </td>
                                                        <td>
                                                            <% 
                                                                // Check if student is already enrolled in this course
                                                                boolean alreadyEnrolled = false;
                                                                if (enrolledCourses != null) {
                                                                    for (Enrollment enrollment : enrolledCourses) {
                                                                        if (enrollment.getCourseId() == course.getCourseId()) {
                                                                            alreadyEnrolled = true;
                                                                            break;
                                                                        }
                                                                    }
                                                                }
                                                            %>
                                                            <% if (alreadyEnrolled) { %>
                                                                <button class="btn btn-sm btn-outline-secondary" disabled>
                                                                    <i class="bi bi-check-circle me-1"></i>Enrolled
                                                                </button>
                                                            <% } else if (course.getEnrolledStudents() < course.getMaxStudents()) { %>
                                                                <form method="post" action="${pageContext.request.contextPath}/student/dashboard" class="d-inline">
                                                                    <input type="hidden" name="action" value="register">
                                                                    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                                                                    <button type="submit" class="btn btn-sm btn-primary">
                                                                        <i class="bi bi-plus-circle me-1"></i>Register
                                                                    </button>
                                                                </form>
                                                            <% } else { %>
                                                                <button class="btn btn-sm btn-secondary" disabled>
                                                                    <i class="bi bi-x-circle me-1"></i>Full
                                                                </button>
                                                            <% } %>
                                                        </td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-4">
                                        <i class="bi bi-book display-4 text-muted"></i>
                                        <h5 class="mt-3 text-muted">No Available Courses</h5>
                                        <p class="text-muted">Check back later for new course offerings.</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column - Quick Actions -->
            <div class="col-lg-4">
                <!-- Quick Actions -->
                <div class="card card-organic">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-lightning-fill me-2"></i>Quick Actions
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/student/register" class="btn btn-primary quick-action-btn" data-shortcut="r">
                                <i class="bi bi-plus-circle me-2"></i>Register for Courses
                                <span class="keyboard-shortcut">R</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary quick-action-btn" data-shortcut="p">
                                <i class="bi bi-person-circle me-2"></i>My Profile
                                <span class="keyboard-shortcut">P</span>
                            </a>
                            <button type="button" class="btn btn-info quick-action-btn" onclick="showShortcutHelp()" data-shortcut="h">
                                <i class="bi bi-question-circle me-2"></i>Shortcuts Help
                                <span class="keyboard-shortcut">H</span>
                            </button>
                        </div>
                        
                        <hr>
                        
                        <h6 class="text-primary mb-3">Quick Info</h6>
                        <div class="quick-info-box rounded p-3">
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-book text-primary me-2"></i>
                                <small class="quick-info-text fw-medium">
                                    ${enrolledCourses.size()} courses enrolled
                                </small>
                            </div>
                            <div class="d-flex align-items-center">
                                <i class="bi bi-plus-circle text-success me-2"></i>
                                <small class="quick-info-text fw-medium">
                                    ${availableCourses.size()} courses available
                                </small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity Feed -->
                <div class="card card-organic mt-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-clock-history me-2"></i>Recent Activity
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="activity-feed">
                            <% 
                                List<Enrollment> recentActivity = (List<Enrollment>) request.getAttribute("recentActivity");
                                if (recentActivity != null && !recentActivity.isEmpty()) {
                                    for (Enrollment activity : recentActivity) {
                            %>
                                <div class="activity-item activity-enrollment d-flex">
                                    <div class="activity-icon icon-enrollment">
                                        <% if ("ENROLLED".equals(activity.getStatus().toString())) { %>
                                            <i class="bi bi-plus-circle"></i>
                                        <% } else if ("COMPLETED".equals(activity.getStatus().toString())) { %>
                                            <i class="bi bi-check-circle"></i>
                                        <% } else if ("DROPPED".equals(activity.getStatus().toString())) { %>
                                            <i class="bi bi-x-circle"></i>
                                        <% } else { %>
                                            <i class="bi bi-clock"></i>
                                        <% } %>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">
                                            <% if ("ENROLLED".equals(activity.getStatus().toString())) { %>
                                                Course Enrollment
                                            <% } else if ("COMPLETED".equals(activity.getStatus().toString())) { %>
                                                Course Completed
                                            <% } else if ("DROPPED".equals(activity.getStatus().toString())) { %>
                                                Course Dropped
                                            <% } else { %>
                                                Course Status Update
                                            <% } %>
                                        </div>
                                        <div class="activity-description">
                                            <% if ("ENROLLED".equals(activity.getStatus().toString())) { %>
                                                You enrolled in <%= activity.getCourseName() %> (<%= activity.getCourseCode() %>)
                                            <% } else if ("COMPLETED".equals(activity.getStatus().toString())) { %>
                                                You completed <%= activity.getCourseName() %> (<%= activity.getCourseCode() %>)
                                            <% } else if ("DROPPED".equals(activity.getStatus().toString())) { %>
                                                You dropped <%= activity.getCourseName() %> (<%= activity.getCourseCode() %>)
                                            <% } else { %>
                                                Status updated for <%= activity.getCourseName() %> (<%= activity.getCourseCode() %>)
                                            <% } %>
                                        </div>
                                        <div class="activity-time">
                                            <%
                                                java.sql.Timestamp enrollmentDate = activity.getEnrollmentDate();
                                                if (enrollmentDate != null) {
                                                    long timeDiff = System.currentTimeMillis() - enrollmentDate.getTime();
                                                    long hours = timeDiff / (1000 * 60 * 60);
                                                    long days = hours / 24;
                                                    
                                                    if (hours < 1) {
                                                        out.print("Just now");
                                                    } else if (hours < 24) {
                                                        out.print(hours + " hour" + (hours == 1 ? "" : "s") + " ago");
                                                    } else if (days < 7) {
                                                        out.print(days + " day" + (days == 1 ? "" : "s") + " ago");
                                                    } else {
                                                        out.print("1 week ago");
                                                    }
                                                } else {
                                                    out.print("Recently");
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                            <% 
                                    }
                                } else {
                            %>
                                <div class="text-center py-4">
                                    <i class="bi bi-clock-history display-4 text-muted"></i>
                                    <h6 class="mt-3 text-muted">No Recent Activity</h6>
                                    <p class="text-muted">Your enrollment activities will appear here.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </div>

    <!-- Keyboard Shortcut Help Modal -->
    <div class="shortcut-help-backdrop" id="shortcutBackdrop" onclick="hideShortcutHelp()"></div>
    <div class="shortcut-help" id="shortcutHelp">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0"><i class="bi bi-keyboard me-2"></i>Keyboard Shortcuts</h5>
            <button type="button" class="btn-close" onclick="hideShortcutHelp()"></button>
        </div>
        <div class="shortcut-item">
            <span>Register for Courses</span>
            <span class="shortcut-key">R</span>
        </div>
        <div class="shortcut-item">
            <span>My Profile</span>
            <span class="shortcut-key">P</span>
        </div>
        <div class="shortcut-item">
            <span>Show Shortcuts</span>
            <span class="shortcut-key">H</span>
        </div>
        <div class="shortcut-item">
            <span>Toggle Dark Mode</span>
            <span class="shortcut-key">D</span>
        </div>
        <div class="shortcut-item">
            <span>Close Modal</span>
            <span class="shortcut-key">ESC</span>
        </div>
        <div class="text-center mt-3">
            <small class="text-muted">Press any key to activate shortcuts</small>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/html-footer.jspf" %>
    
    <!-- Custom JavaScript -->
    <script>
        // Smooth scrolling function
        function scrollToSection(sectionId) {
            const element = document.getElementById(sectionId);
            if (element) {
                element.scrollIntoView({ 
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        }

        // Keyboard Shortcuts functionality
        function showShortcutHelp() {
            document.getElementById('shortcutHelp').classList.add('show');
            document.getElementById('shortcutBackdrop').classList.add('show');
        }

        function hideShortcutHelp() {
            document.getElementById('shortcutHelp').classList.remove('show');
            document.getElementById('shortcutBackdrop').classList.remove('show');
        }

        // Keyboard shortcut handler
        document.addEventListener('keydown', function(e) {
            // Don't trigger shortcuts if user is typing in an input
            if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
                return;
            }

            const key = e.key.toLowerCase();
            
            switch(key) {
                case 'r':
                    e.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/student/register';
                    break;
                case 'p':
                    e.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/profile';
                    break;
                case 'h':
                    e.preventDefault();
                    showShortcutHelp();
                    break;
                case 'd':
                    e.preventDefault();
                    // Trigger dark mode toggle
                    const themeToggle = document.getElementById('theme-toggle');
                    if (themeToggle) {
                        themeToggle.click();
                    }
                    break;
                case 'escape':
                    hideShortcutHelp();
                    break;
            }
        });

        // Show shortcut hints on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Add a subtle notification about shortcuts
            setTimeout(function() {
                const shortcutNotification = document.createElement('div');
                shortcutNotification.className = 'alert alert-info alert-dismissible fade show position-fixed';
                shortcutNotification.style.cssText = 'top: 20px; right: 20px; z-index: 1000; max-width: 300px;';
                shortcutNotification.innerHTML = `
                    <i class="bi bi-keyboard me-2"></i>
                    <strong>Tip:</strong> Press <kbd>H</kbd> for keyboard shortcuts!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;
                document.body.appendChild(shortcutNotification);
                
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    if (shortcutNotification.parentNode) {
                        shortcutNotification.remove();
                    }
                }, 5000);
            }, 2000);
        });
        
    </script>
    
    <!-- Premium Dashboard JavaScript -->
    <script>
        // Animated Counter Function
        function animateCounters() {
            const counters = document.querySelectorAll('.stat-number[data-target]');
            
            counters.forEach(counter => {
                const target = parseInt(counter.getAttribute('data-target'));
                // Make sure target is a valid number
                if (isNaN(target)) {
                    return;
                }
                
                const duration = 1500; // Animation duration in milliseconds
                let startTimestamp = null;

                const step = (timestamp) => {
                    if (!startTimestamp) startTimestamp = timestamp;
                    const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                    counter.textContent = Math.floor(progress * target);
                    if (progress < 1) {
                        window.requestAnimationFrame(step);
                    }
                };

                window.requestAnimationFrame(step);
            });
        }
        
        // Progress Ring Animation
        function animateProgressRings() {
            const rings = document.querySelectorAll('.progress-ring-fill');
            rings.forEach(ring => {
                const progress = ring.style.getPropertyValue('--progress');
                ring.style.setProperty('--progress', 0); // Reset to 0
                
                // Animate to the target value
                setTimeout(() => {
                    ring.style.setProperty('--progress', progress);
                }, 500); // Delay to ensure transition is visible
            });
        }
        
        // Initialize animations when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Use a slight delay to ensure all elements are rendered
            setTimeout(() => {
                animateCounters();
                animateProgressRings();
            }, 300);
        });
    </script>
</body>
</html>
