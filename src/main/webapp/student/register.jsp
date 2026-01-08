<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Course> availableCourses = (List<Course>) request.getAttribute("availableCourses");
    List<Enrollment> enrolledCourses = (List<Enrollment>) request.getAttribute("enrolledCourses");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Registration - Course Management System</title>
    
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
                <a class="btn btn-nav-premium btn-dashboard" href="${pageContext.request.contextPath}/student/dashboard">
                    <i class="bi bi-house me-1"></i>Dashboard
                </a>
                <a class="btn btn-nav-premium" href="${pageContext.request.contextPath}/profile">
                    <i class="bi bi-person-circle me-1"></i>Profile
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
                <h2><i class="bi bi-plus-circle me-2"></i>Course Registration</h2>
                <p class="text-muted">Browse and register for available courses</p>
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

        <div class="row">
            <!-- Available Courses -->
            <div class="col-lg-8 mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-book-fill me-2"></i>Available Courses
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (availableCourses != null && !availableCourses.isEmpty()) { %>
                            <div class="row">
                                <% for (Course course : availableCourses) { %>
                                    <div class="col-md-6 mb-3">
                                        <div class="course-card h-100">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h6 class="card-title text-primary">
                                                        <%= course.getCourseCode() %>
                                                    </h6>
                                                    <h5 class="card-title">
                                                        <%= course.getCourseName() %>
                                                    </h5>
                                                    <p class="card-text text-muted">
                                                        <%= course.getDescription() %>
                                                    </p>
                                                    <div class="course-info mb-3">
                                                        <div class="row">
                                                            <div class="col-6">
                                                                <small class="text-muted">
                                                                    <i class="bi bi-person me-1"></i>
                                                                    <%= course.getTeacherName() %>
                                                                </small>
                                                            </div>
                                                            <div class="col-6">
                                                                <small class="text-muted">
                                                                    <i class="bi bi-award me-1"></i>
                                                                    <%= course.getCredits() %> Credits
                                                                </small>
                                                            </div>
                                                        </div>
                                                        <div class="row mt-1">
                                                            <div class="col-6">
                                                                <small class="text-muted">
                                                                    <i class="bi bi-people me-1"></i>
                                                                    <%= course.getEnrolledStudents() %>/<%= course.getMaxStudents() %> Students
                                                                </small>
                                                            </div>
                                                            <div class="col-6">
                                                                <% if (course.getEnrolledStudents() < course.getMaxStudents()) { %>
                                                                    <span class="badge bg-success">Available</span>
                                                                <% } else { %>
                                                                    <span class="badge bg-danger">Full</span>
                                                                <% } %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Check if student is already enrolled -->
                                                    <% 
                                                        boolean isEnrolled = false;
                                                        if (enrolledCourses != null) {
                                                            for (Enrollment enrollment : enrolledCourses) {
                                                                if (enrollment.getCourseId() == course.getCourseId()) {
                                                                    isEnrolled = true;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                    %>
                                                    
                                                    <% if (isEnrolled) { %>
                                                        <button class="btn btn-success w-100" disabled>
                                                            <i class="bi bi-check-circle me-1"></i>Already Enrolled
                                                        </button>
                                                    <% } else if (course.getEnrolledStudents() < course.getMaxStudents()) { %>
                                                        <form method="post" action="${pageContext.request.contextPath}/student/register" style="display: inline;">
                                                            <input type="hidden" name="action" value="enroll">
                                                            <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                                                            <button type="submit" class="btn btn-primary w-100">
                                                                <i class="bi bi-plus-circle me-1"></i>Register
                                                            </button>
                                                        </form>
                                                    <% } else { %>
                                                        <button class="btn btn-secondary w-100" disabled>
                                                            <i class="bi bi-x-circle me-1"></i>Course Full
                                                        </button>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="text-center text-muted py-5">
                                <i class="bi bi-book display-4"></i>
                                <h4 class="mt-3">No Available Courses</h4>
                                <p>There are currently no courses available for registration.</p>
                                <p class="small">Please check back later or contact your administrator.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- My Enrollments -->
            <div class="col-lg-4 mb-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-list-check me-2"></i>My Enrollments
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (enrolledCourses != null && !enrolledCourses.isEmpty()) { %>
                            <div class="list-group list-group-flush enrollment-list">
                                <% for (Enrollment enrollment : enrolledCourses) { %>
                                    <div class="list-group-item border-0 px-0">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="mb-1 text-primary">
                                                    <%= enrollment.getCourseCode() %>
                                                </h6>
                                                <p class="mb-1">
                                                    <%= enrollment.getCourseName() %>
                                                </p>
                                                <small class="text-muted">
                                                    <i class="bi bi-person me-1"></i>
                                                    <%= enrollment.getTeacherName() %>
                                                </small>
                                            </div>
                                            <span class="badge bg-success">
                                                <%= enrollment.getStatus() %>
                                            </span>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-muted">
                                                Enrolled: <%= enrollment.getEnrollmentDate() %>
                                            </small>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="text-center text-muted py-4">
                                <i class="bi bi-book display-4"></i>
                                <p class="mt-2">No Enrollments</p>
                                <p class="small">You haven't enrolled in any courses yet.</p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="card mt-3">
                    <div class="card-header bg-info text-white">
                        <h6 class="card-title mb-0">
                            <i class="bi bi-graph-up me-2"></i>Registration Stats
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-6">
                                <div class="stat-item">
                                    <div class="stat-number text-primary">
                                        <%= enrolledCourses != null ? enrolledCourses.size() : 0 %>
                                    </div>
                                    <div class="stat-label">Enrolled</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stat-item">
                                    <div class="stat-number text-success">
                                        <%= availableCourses != null ? availableCourses.size() : 0 %>
                                    </div>
                                    <div class="stat-label">Available</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Dark Mode Script -->
    <script src="${pageContext.request.contextPath}/js/theme-system.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Add animation to course cards
        document.addEventListener('DOMContentLoaded', function() {
            const courseCards = document.querySelectorAll('.course-card');
            
            courseCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>
