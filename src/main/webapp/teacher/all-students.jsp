<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="com.coursemanagement.dao.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Course> assignedCourses = (List<Course>) request.getAttribute("assignedCourses");
    
    // Get all enrollments for teacher's courses
    EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    List<Enrollment> allEnrollments = new ArrayList<>();
    int totalStudents = 0;
    int totalCapacity = 0;
    
    if (assignedCourses != null) {
        for (Course course : assignedCourses) {
            List<Enrollment> courseEnrollments = enrollmentDAO.getEnrollmentsByCourse(course.getCourseId());
            allEnrollments.addAll(courseEnrollments);
            totalStudents += courseEnrollments.size();
            totalCapacity += course.getMaxStudents();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Students - Course Management System</title>
    
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

    <div class="container mt-4 modern-spacing">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col">
                <div class="dashboard-card">
                    <h2 class="h3 mb-3">
                        <i class="bi bi-people-fill text-primary me-2"></i>
                        All My Students
                    </h2>
                    <p class="text-muted mb-0">
                        Overview of all students enrolled in your courses
                    </p>
                </div>
            </div>
        </div>

        <!-- Summary Stats -->
        <div class="dashboard-grid row">
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center clickable-card">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-people-fill text-primary" style="font-size: 1.5rem; margin-bottom: 0.75rem;"></i>
                            <div class="stat-number"><%= totalStudents %></div>
                            <div class="stat-label">Total Students</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center clickable-card">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-book-fill text-success" style="font-size: 1.5rem; margin-bottom: 0.75rem;"></i>
                            <div class="stat-number"><%= assignedCourses != null ? assignedCourses.size() : 0 %></div>
                            <div class="stat-label">My Courses</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center clickable-card">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-mortarboard-fill text-info" style="font-size: 1.5rem; margin-bottom: 0.75rem;"></i>
                            <div class="stat-number"><%= totalCapacity %></div>
                            <div class="stat-label">Total Capacity</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center clickable-card">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-percent text-warning" style="font-size: 1.5rem; margin-bottom: 0.75rem;"></i>
                            <div class="stat-number">
                                <%= totalCapacity > 0 ? Math.round((totalStudents * 100.0) / totalCapacity) : 0 %>%
                            </div>
                            <div class="stat-label">Utilization</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Students by Course -->
        <% if (assignedCourses != null && !assignedCourses.isEmpty()) { %>
            <% for (Course course : assignedCourses) { %>
                <%
                    List<Enrollment> courseEnrollments = enrollmentDAO.getEnrollmentsByCourse(course.getCourseId());
                %>
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span>
                                        <i class="bi bi-book me-2"></i>
                                        <%= course.getCourseCode() %> - <%= course.getCourseName() %>
                                    </span>
                                    <span class="badge bg-primary">
                                        <%= courseEnrollments.size() %>/<%= course.getMaxStudents() %> students
                                    </span>
                                </div>
                            </div>
                            <div class="card-body">
                                <% if (!courseEnrollments.isEmpty()) { %>
                                    <div class="table-responsive premium-table-container">
                                        <table class="table premium-table">
                                            <thead>
                                                <tr>
                                                    <th>Student ID</th>
                                                    <th>Name</th>
                                                    <th>Email</th>
                                                    <th>Enrolled Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Enrollment enrollment : courseEnrollments) { %>
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
                                    <div class="text-center text-muted py-3">
                                        <i class="bi bi-people"></i>
                                        <small>No students enrolled in this course yet</small>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body text-center py-5">
                            <i class="bi bi-book display-1 text-muted"></i>
                            <h5 class="mt-3">No Assigned Courses</h5>
                            <p class="text-muted">You haven't been assigned to any courses yet.</p>
                            <p class="small text-muted">Contact the administrator to get assigned to courses.</p>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Navigation -->
        <div class="row mt-4">
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <a href="${pageContext.request.contextPath}/teacher/students" class="btn btn-outline-secondary me-2">
                            <i class="bi bi-list me-2"></i>View by Course
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
