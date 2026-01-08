<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    Course course = (Course) request.getAttribute("course");
    List<Enrollment> enrollments = (List<Enrollment>) request.getAttribute("enrollments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students in <%= course != null ? course.getCourseCode() : "Course" %> - Course Management System</title>
    
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
                <h2><i class="bi bi-people-fill me-2"></i>Enrolled Students</h2>
                <% if (course != null) { %>
                    <p class="text-muted"><%= course.getCourseCode() %> - <%= course.getCourseName() %></p>
                <% } %>
            </div>
        </div>

        <!-- Course Information -->
        <% if (course != null) { %>
            <div class="row mb-4">
                <div class="col">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-book-fill me-2"></i>Course Information
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Course Code:</strong> <%= course.getCourseCode() %></p>
                                    <p><strong>Course Name:</strong> <%= course.getCourseName() %></p>
                                    <p><strong>Credits:</strong> <%= course.getCredits() %></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Description:</strong> <%= course.getDescription() %></p>
                                    <p><strong>Max Students:</strong> <%= course.getMaxStudents() %></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Students List -->
        <div class="row">
            <div class="col-12 mb-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-people-fill me-2"></i>Enrolled Students
                            <% if (enrollments != null) { %>
                                <span class="badge bg-light text-dark ms-2"><%= enrollments.size() %></span>
                            <% } %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (enrollments != null && !enrollments.isEmpty()) { %>
                            <div class="table-responsive premium-table-container">
                                <table class="table premium-table">
                                    <thead>
                                        <tr>
                                            <th>Student ID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Enrollment Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Enrollment enrollment : enrollments) { %>
                                            <tr>
                                                <td><%= enrollment.getStudentId() %></td>
                                                <td>
                                                    <i class="bi bi-person-circle me-2"></i>
                                                    <%= enrollment.getStudentName() %>
                                                </td>
                                                <td>
                                                    <i class="bi bi-envelope me-2"></i>
                                                    <%= enrollment.getStudentEmail() %>
                                                </td>
                                                <td>
                                                    <i class="bi bi-calendar me-2"></i>
                                                    <%= enrollment.getEnrollmentDate() %>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center text-muted py-5">
                                <i class="bi bi-people display-1"></i>
                                <h5 class="mt-3">No Students Enrolled</h5>
                                <p>No students have enrolled in this course yet.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation -->
        <div class="row mt-4">
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <a href="${pageContext.request.contextPath}/teacher/students" class="btn btn-outline-secondary me-2">
                            <i class="bi bi-arrow-left me-2"></i>Back to Course Selection
                        </a>
                        <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-outline-primary">
                            <i class="bi bi-house me-2"></i>Dashboard
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
