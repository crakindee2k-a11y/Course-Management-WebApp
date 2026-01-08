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
    <title>View Students - Course Management System</title>
    
    <!-- Apply theme before CSS to prevent flash -->
    <%@ include file="/WEB-INF/jspf/theme-init.jspf" %>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/premium-nav.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="bi bi-mortarboard-fill me-2"></i>Course Management System
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    <i class="bi bi-person-circle me-1"></i>Welcome, <%= currentUser.getFullName() %>
                </span>
                <a class="btn btn-nav-premium btn-dashboard" href="${pageContext.request.contextPath}/teacher/dashboard">
                    <i class="bi bi-house me-1"></i>Dashboard
                </a>
                <a class="btn btn-nav-premium btn-logout" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right me-1"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col">
                <h2><i class="bi bi-people-fill me-2"></i>View Students</h2>
                <p class="text-muted">Select a course to view enrolled students</p>
            </div>
        </div>

        <div class="row">
            <!-- Course Selection -->
            <div class="col-12 mb-4">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-book-fill me-2"></i>Select Course
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (assignedCourses != null && !assignedCourses.isEmpty()) { %>
                            <div class="row">
                                <% for (Course course : assignedCourses) { %>
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <div class="card h-100 d-flex flex-column">
                                            <div class="card-body d-flex flex-column">
                                                <h6 class="card-title">
                                                    <%= course.getCourseCode() %> - <%= course.getCourseName() %>
                                                </h6>
                                                <p class="card-text text-muted small flex-grow-1">
                                                    <%= course.getDescription() %>
                                                </p>
                                                <div class="mb-2">
                                                    <small class="text-muted d-block">
                                                        <i class="bi bi-credit-card me-1"></i><%= course.getCredits() %> credits
                                                    </small>
                                                    <small class="text-muted d-block">
                                                        <i class="bi bi-people me-1"></i>Max: <%= course.getMaxStudents() %> students
                                                    </small>
                                                </div>
                                                <div class="d-grid gap-2 mt-auto">
                                                    <a href="${pageContext.request.contextPath}/teacher/students?courseId=<%= course.getCourseId() %>" 
                                                       class="btn btn-primary btn-sm">
                                                        <i class="bi bi-people-fill me-1"></i>View Students
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="text-center text-muted py-5">
                                <i class="bi bi-book display-1"></i>
                                <h5 class="mt-3">No Assigned Courses</h5>
                                <p>You haven't been assigned to any courses yet.</p>
                                <p class="small">Contact the administrator to get assigned to courses.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Back to Dashboard -->
        <div class="row mt-4">
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Dark Mode Script -->
    <script src="${pageContext.request.contextPath}/js/theme-system.js"></script>
</body>
</html>

