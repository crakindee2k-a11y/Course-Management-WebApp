<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Course> assignedCourses = (List<Course>) request.getAttribute("assignedCourses");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - Course Management System</title>
    
    <!-- Apply theme before CSS to prevent flash -->
    <%@ include file="/WEB-INF/jspf/theme-init.jspf" %>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css?v=<%="2024"%>" rel="stylesheet">
    
    <!-- Theme System Script -->
    <script src="${pageContext.request.contextPath}/js/theme-system.js"></script>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/teacher/dashboard">
                <i class="bi bi-mortarboard-fill me-2"></i>Course Management System
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/teacher/dashboard">
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

    <div class="container-fluid teacher-dashboard-premium">
        <!-- Hero Section -->
        <div class="hero-section">
            <div class="hero-background">
                <div class="floating-element fe-1"></div>
                <div class="floating-element fe-2"></div>
                <div class="floating-element fe-3"></div>
                <div class="floating-element fe-4"></div>
            </div>
            
            <div class="container">
                <div class="row align-items-center min-vh-50">
                    <div class="col-lg-8">
                        <div class="hero-content">
                            <div class="hero-text">
                                <h1 class="hero-title">
                                    Welcome back,
                                    <span class="gradient-text hero-name"><%= currentUser.getFullName() %></span>
                                </h1>
                                <p class="hero-subtitle">
                                    Manage your courses and track student progress with our advanced teaching tools
                                </p>
                                
                                <div class="hero-stats-mini">
                                    <div class="mini-stat">
                                        <div class="mini-stat-number"><%= assignedCourses != null ? assignedCourses.size() : 0 %></div>
                                        <div class="mini-stat-label">Courses</div>
                                    </div>
                                    <div class="mini-stat">
                                        <div class="mini-stat-number">
                                            <% 
                                            int totalCreditsHero = 0;
                                            if (assignedCourses != null) {
                                                for (Course course : assignedCourses) {
                                                    totalCreditsHero += course.getCredits();
                                                }
                                            }
                                            %>
                                            <%= totalCreditsHero %>
                                        </div>
                                        <div class="mini-stat-label">Credits</div>
                                    </div>
                                    <div class="mini-stat">
                                        <div class="mini-stat-number">4th</div>
                                        <div class="mini-stat-label">Semester</div>
                                    </div>
                                </div>
                </div>
            </div>
        </div>

                    <div class="col-lg-4 text-end">
                        <div class="hero-visual">
                            <div class="teacher-globe">
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

        <!-- Premium Statistics Cards -->
        <div class="container mb-5">
            <div class="stats-grid">
                <a href="#my-courses" class="glass-card stat-card-premium teacher-stat text-decoration-none">
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-primary">
                            <i class="bi bi-book-fill"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <div class="stat-number"><%= assignedCourses != null ? assignedCourses.size() : 0 %></div>
                            <div class="stat-trend">
                                <i class="bi bi-arrow-up text-success"></i>
                                <span class="text-success">Active</span>
                            </div>
                        </div>
                        <div class="stat-title">My Courses</div>
                        <div class="stat-subtitle">Currently teaching</div>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"></circle>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="stroke-dasharray: 157; stroke-dashoffset: 47;"></circle>
                        </svg>
                    </div>
                </a>

                <a href="#my-courses" class="glass-card stat-card-premium teacher-stat text-decoration-none">
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-success">
                            <i class="bi bi-award-fill"></i>
                        </div>
                        <div class="stat-pulse"></div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <div class="stat-number">
                                <% 
                                int totalCreditsDisplay = 0;
                                if (assignedCourses != null) {
                                for (Course course : assignedCourses) {
                                        totalCreditsDisplay += course.getCredits();
                                    }
                                }
                                %>
                                <%= totalCreditsDisplay %>
                            </div>
                            <div class="stat-trend">
                                <i class="bi bi-star-fill text-warning"></i>
                                <span class="text-success">Credits</span>
                            </div>
                        </div>
                        <div class="stat-title">Total Credits</div>
                        <div class="stat-subtitle">Academic weight</div>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"></circle>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="stroke-dasharray: 157; stroke-dashoffset: 39;"></circle>
                        </svg>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/teacher/students?all=true" class="glass-card stat-card-premium teacher-stat text-decoration-none">
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-info">
                            <i class="bi bi-people-fill"></i>
                </div>
                        <div class="stat-pulse"></div>
            </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                            <div class="stat-number">
                                <% 
                                int totalCapacity = 0;
                                if (assignedCourses != null) {
                                for (Course course : assignedCourses) {
                                    totalCapacity += course.getMaxStudents();
                                    }
                                }
                                %>
                                <%= totalCapacity %>
                            </div>
                            <div class="stat-trend">
                                <i class="bi bi-graph-up text-info"></i>
                                <span class="text-info">Capacity</span>
                            </div>
                        </div>
                        <div class="stat-title">Student Capacity</div>
                        <div class="stat-subtitle">Maximum enrollment</div>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"></circle>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="stroke-dasharray: 157; stroke-dashoffset: 31;"></circle>
                        </svg>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/teacher/students?all=true" class="glass-card stat-card-premium teacher-stat text-decoration-none">
                    <div class="stat-icon-container">
                        <div class="stat-icon bg-gradient-warning">
                            <i class="bi bi-eye-fill"></i>
                </div>
                        <div class="stat-pulse"></div>
            </div>
                    <div class="stat-content">
                        <div class="stat-number-container">
                                <div class="stat-number">View</div>
                            <div class="stat-trend">
                                <i class="bi bi-arrow-right text-warning"></i>
                                <span class="text-warning">Access</span>
                            </div>
                        </div>
                        <div class="stat-title">All Students</div>
                        <div class="stat-subtitle">Manage enrollments</div>
                    </div>
                    <div class="stat-chart">
                        <svg class="progress-ring" width="60" height="60">
                            <circle class="progress-ring-bg" cx="30" cy="30" r="25"></circle>
                            <circle class="progress-ring-fill" cx="30" cy="30" r="25" style="stroke-dasharray: 157; stroke-dashoffset: 0;"></circle>
                        </svg>
                    </div>
                </a>
            </div>
        </div>

        <!-- Premium Course Management Section -->
        <div class="container">
            <div id="my-courses" class="glass-card data-table-card">
                <div class="table-header">
                    <div>
                        <h3 class="table-title">
                            <i class="bi bi-journal-text me-2"></i>
                            My Assigned Courses
                        </h3>
                        <p class="table-subtitle">Manage and monitor your teaching assignments</p>
                    </div>
                    <div class="table-actions">
                        <a href="${pageContext.request.contextPath}/teacher/students?all=true" class="btn btn-premium">
                            <i class="bi bi-people me-2"></i>View All Students
                        </a>
                    </div>
                </div>
                
                <div class="premium-table-container">
                        <% if (assignedCourses != null && !assignedCourses.isEmpty()) { %>
                        <div class="row course-grid">
                                <% for (Course course : assignedCourses) { %>
                                <div class="col-lg-4 col-md-6 mb-4">
                                    <div class="glass-card course-card-premium">
                                        <div class="course-header">
                                            <div class="course-code-badge">
                                                <%= course.getCourseCode() %>
                                            </div>
                                            <div class="course-actions">
                                                <a href="${pageContext.request.contextPath}/teacher/students?courseId=<%= course.getCourseId() %>" class="btn-icon">
                                                    <i class="bi bi-people-fill"></i>
                                                </a>
                                            </div>
                                        </div>
                                        
                                        <div class="course-content">
                                            <h4 class="course-title"><%= course.getCourseName() %></h4>
                                            <p class="course-description"><%= course.getDescription() %></p>
                                            
                                            <div class="course-stats">
                                                <div class="course-stat">
                                                    <div class="stat-icon">
                                                        <i class="bi bi-award-fill"></i>
                                                    </div>
                                                    <div class="stat-info">
                                                        <div class="stat-value"><%= course.getCredits() %></div>
                                                        <div class="stat-label">Credits</div>
                                                    </div>
                                                </div>
                                                
                                                <div class="course-stat">
                                                    <div class="stat-icon">
                                                        <i class="bi bi-people-fill"></i>
                                                    </div>
                                                    <div class="stat-info">
                                                        <div class="stat-value"><%= course.getMaxStudents() %></div>
                                                        <div class="stat-label">Max Students</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="course-footer">
                                            <a href="${pageContext.request.contextPath}/teacher/students?courseId=<%= course.getCourseId() %>" class="btn btn-premium-outline w-100">
                                                <i class="bi bi-person-lines-fill me-2"></i>Manage Students
                                            </a>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="bi bi-journal-x"></i>
                            </div>
                            <h4 class="empty-title">No Assigned Courses</h4>
                            <p class="empty-description">You haven't been assigned to any courses yet.</p>
                            <p class="empty-help">Contact the administrator to get assigned to courses.</p>
                            </div>
                        <% } %>
                </div>
            </div>
        </div>

        <!-- Premium Quick Actions -->
        <div class="container mt-5">
            <div class="glass-card">
                <div class="table-header">
                    <div>
                        <h3 class="table-title">
                            <i class="bi bi-lightning-fill me-2"></i>
                            Quick Actions
                        </h3>
                        <p class="table-subtitle">Streamline your teaching workflow</p>
                    </div>
                </div>
                
                <div class="quick-actions-grid">
                    <a href="${pageContext.request.contextPath}/teacher/students?all=true" class="quick-action-card">
                        <div class="action-icon bg-gradient-info">
                            <i class="bi bi-people"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">View All Students</h4>
                            <p class="action-description">Access complete student directory</p>
                        </div>
                        <div class="action-arrow">
                            <i class="bi bi-arrow-right"></i>
                        </div>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/teacher/dashboard" class="quick-action-card">
                        <div class="action-icon bg-gradient-secondary">
                            <i class="bi bi-arrow-clockwise"></i>
                        </div>
                        <div class="action-content">
                            <h4 class="action-title">Refresh Dashboard</h4>
                            <p class="action-description">Update all statistics and data</p>
                            </div>
                        <div class="action-arrow">
                            <i class="bi bi-arrow-right"></i>
                            </div>
                                </a>
                    
                    <a href="${pageContext.request.contextPath}/logout" class="quick-action-card">
                        <div class="action-icon bg-gradient-danger">
                            <i class="bi bi-box-arrow-right"></i>
                            </div>
                        <div class="action-content">
                            <h4 class="action-title">Logout</h4>
                            <p class="action-description">Securely end your session</p>
                        </div>
                        <div class="action-arrow">
                            <i class="bi bi-arrow-right"></i>
                    </div>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


