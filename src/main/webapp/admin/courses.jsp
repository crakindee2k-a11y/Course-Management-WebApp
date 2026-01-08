<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<User> teachers = (List<User>) request.getAttribute("teachers");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    Course editCourse = (Course) request.getAttribute("editCourse");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management - Course Management System</title>
    
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
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="bi bi-mortarboard-fill me-2"></i>Course Management System
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    <i class="bi bi-person-circle me-1"></i>Welcome, <%= currentUser.getFullName() %>
                </span>
                <a class="btn btn-nav-premium btn-dashboard" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-house me-1"></i>Dashboard
                </a>
                <a class="btn btn-nav-premium btn-logout" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right me-1"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4 admin-page">
        <!-- Breadcrumb Navigation -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-house me-1"></i>Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="bi bi-book-fill me-1"></i>Course Management
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col">
                <h2><i class="bi bi-book-fill me-2"></i>Course Management</h2>
                <p class="text-muted">Manage courses, assign teachers, and monitor enrollments</p>
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

        <!-- Add Course Form -->
        <div class="row mb-4">
            <div class="col">
                <div class="card admin-form-section">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-plus-circle me-2"></i>
                            <%= editCourse != null ? "Edit Course" : "Add New Course" %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/admin/courses">
                            <input type="hidden" name="action" value="<%= editCourse != null ? "update" : "create" %>">
                            <% if (editCourse != null) { %>
                                <input type="hidden" name="courseId" value="<%= editCourse.getCourseId() %>">
                            <% } %>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="courseCode" class="form-label">Course Code</label>
                                    <input type="text" class="form-control" id="courseCode" name="courseCode" 
                                           value="<%= editCourse != null ? editCourse.getCourseCode() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="courseName" class="form-label">Course Name</label>
                                    <input type="text" class="form-control" id="courseName" name="courseName" 
                                           value="<%= editCourse != null ? editCourse.getCourseName() : "" %>" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="credits" class="form-label">Credits</label>
                                    <input type="number" class="form-control" id="credits" name="credits" 
                                           value="<%= editCourse != null ? editCourse.getCredits() : "3" %>" min="1" max="6" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="maxStudents" class="form-label">Max Students</label>
                                    <input type="number" class="form-control" id="maxStudents" name="maxStudents" 
                                           value="<%= editCourse != null ? editCourse.getMaxStudents() : "50" %>" min="1" max="200" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3" required><%= editCourse != null ? editCourse.getDescription() : "" %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="teacherId" class="form-label">Assign Teacher</label>
                                <select class="form-select" id="teacherId" name="teacherId">
                                    <option value="">Select a teacher</option>
                                    <% if (teachers != null) { %>
                                        <% for (User teacher : teachers) { %>
                                            <option value="<%= teacher.getUserId() %>" 
                                                    <%= editCourse != null && editCourse.getTeacherId() == teacher.getUserId() ? "selected" : "" %>>
                                                <%= teacher.getFullName() %>
                                            </option>
                                        <% } %>
                                    <% } %>
                                </select>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <% if (editCourse != null) { %>
                                    <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary me-md-2">Cancel</a>
                                <% } %>
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-check-circle me-1"></i>
                                    <%= editCourse != null ? "Update Course" : "Add Course" %>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bulk Import -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-upload me-2"></i>Bulk Import Courses
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text text-muted">
                            Upload an Excel (.xlsx) or CSV (.csv) file with course data. The file should contain the following columns in order:
                            <code>courseCode</code>, <code>courseName</code>, <code>description</code>, <code>credits</code>, <code>maxStudents</code>, <code>teacherId</code> (optional).
                        </p>
                        <form action="${pageContext.request.contextPath}/admin/bulk-import" method="post" enctype="multipart/form-data" id="coursesBulkImportForm">
                            <input type="hidden" name="type" value="courses">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <div class="custom-file-input-wrapper">
                                        <input type="file" class="custom-file-input" name="file" id="courseFileInput" accept=".xlsx,.csv" required>
                                        <label for="courseFileInput" class="custom-file-label" id="courseFileLabel">
                                            <i class="bi bi-cloud-upload custom-file-icon"></i>
                                            <div class="custom-file-text">
                                                <div class="custom-file-title">Choose file to upload</div>
                                                <div class="custom-file-subtitle">Excel (.xlsx) or CSV (.csv) files only</div>
                                            </div>
                                            <div class="custom-file-button">Browse</div>
                                        </label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <button class="btn btn-primary w-100 h-100" type="submit" style="min-height: 3rem;">
                                        <i class="bi bi-upload me-2"></i>Upload and Import
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Courses List -->
        <div class="row">
            <div class="col">
                <div class="card admin-table-section premium-data-table">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-list-ul me-2"></i>All Courses (<span id="courseCount"><%= courses != null ? courses.size() : 0 %></span>)
                        </h5>
                        <div class="d-flex align-items-center gap-2">
                            <span id="selectedCourseCount" class="badge bg-light text-dark" style="display: none;">0 selected</span>
                            <button class="btn btn-light btn-sm" onclick="toggleCourseView()" id="toggleCourseViewBtn">
                                <i class="bi bi-grid-3x3-gap"></i> Grid View
                            </button>
                        </div>
                    </div>
                    
                    <!-- Table Controls -->
                    <div class="card-body border-bottom">
                        <div class="row g-3 align-items-center">
                            <!-- Search and Filter -->
                            <div class="col-md-4">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" id="searchCourses" placeholder="Search courses...">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" id="filterCourseStatus">
                                    <option value="">All Courses</option>
                                    <option value="assigned">With Teacher</option>
                                    <option value="unassigned">No Teacher</option>
                                    <option value="full">Full Capacity</option>
                                    <option value="available">Available</option>
                                </select>
                            </div>
                            
                            <!-- Bulk Actions -->
                            <div class="col-md-3">
                                <div class="dropdown">
                                    <button class="btn btn-secondary dropdown-toggle" type="button" id="bulkCourseActionsBtn" 
                                            data-bs-toggle="dropdown" disabled>
                                        <i class="bi bi-gear"></i> Bulk Actions
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="#" onclick="bulkDeleteCourses()">
                                            <i class="bi bi-trash text-danger"></i> Delete Selected
                                        </a></li>
                                        <li><a class="dropdown-item" href="#" onclick="bulkAssignTeacher()">
                                            <i class="bi bi-person-plus text-info"></i> Assign Teacher
                                        </a></li>
                                        <li><a class="dropdown-item" href="#" onclick="bulkUpdateCapacity()">
                                            <i class="bi bi-people text-warning"></i> Update Capacity
                                        </a></li>
                                        <li><a class="dropdown-item" href="#" onclick="exportSelectedCourses()">
                                            <i class="bi bi-download text-success"></i> Export Selected
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                            
                            <!-- Pagination Controls -->
                            <div class="col-md-3">
                                <div class="d-flex align-items-center gap-2">
                                    <label class="form-label mb-0 text-nowrap">Show:</label>
                                    <select class="form-select form-select-sm" id="coursesPerPage" style="width: auto;">
                                        <option value="10">10</option>
                                        <option value="25" selected>25</option>
                                        <option value="50">50</option>
                                        <option value="all">All</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body p-0">
                        <!-- Table View -->
                        <div id="courseTableView">
                            <% if (courses != null && !courses.isEmpty()) { %>
                                <div class="table-responsive premium-table-container">
                                    <table class="table premium-table mb-0" id="coursesTable">
                                        <thead class="sticky-top">
                                            <tr>
                                                <th style="width: 50px;">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" id="selectAllCourses">
                                                    </div>
                                                </th>
                                                <th>
                                                    <a href="#" class="sortable" data-column="courseCode">Course Code <span class="sort-icon">↓↑</span></a>
                                                </th>
                                                <th>
                                                    <a href="#" class="sortable" data-column="courseName">Course Name <span class="sort-icon">↓↑</span></a>
                                                </th>
                                                <th>
                                                    <a href="#" class="sortable" data-column="teacherName">Teacher <span class="sort-icon">↓↑</span></a>
                                                </th>
                                                <th>
                                                    <a href="#" class="sortable" data-column="enrolledStudents">Enrolled <span class="sort-icon">↓↑</span></a>
                                                </th>
                                                <th>
                                                    <a href="#" class="sortable" data-column="capacity">Capacity <span class="sort-icon">↓↑</span></a>
                                                </th>
                                                <th>Status</th>
                                                <th style="width: 120px;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="coursesTableBody">
                                            <% for (Course course : courses) { %>
                                                <% 
                                                    double capacityPercentage = course.getMaxStudents() > 0 ? 
                                                        (double) course.getEnrolledStudents() / course.getMaxStudents() * 100 : 0;
                                                    boolean isFull = course.getEnrolledStudents() >= course.getMaxStudents();
                                                    boolean hasTeacher = course.getTeacherName() != null && !course.getTeacherName().isEmpty();
                                                    String statusBadge = isFull ? "danger" : (capacityPercentage > 80 ? "warning" : "success");
                                                    String statusText = isFull ? "Full" : (capacityPercentage > 80 ? "Near Full" : "Available");
                                                %>
                                                <tr data-course-id="<%= course.getCourseId() %>" 
                                                    data-course-code="<%= course.getCourseCode() %>" 
                                                    data-course-name="<%= course.getCourseName() %>" 
                                                    data-teacher-name="<%= course.getTeacherName() != null ? course.getTeacherName() : "" %>" 
                                                    data-enrolled="<%= course.getEnrolledStudents() %>" 
                                                    data-capacity="<%= course.getMaxStudents() %>"
                                                    data-credits="<%= course.getCredits() %>"
                                                    data-has-teacher="<%= hasTeacher %>"
                                                    data-is-full="<%= isFull %>">
                                                    <td>
                                                        <div class="form-check">
                                                            <input class="form-check-input course-checkbox" type="checkbox" 
                                                                   value="<%= course.getCourseId() %>">
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-primary fs-6"><%= course.getCourseCode() %></span>
                                                    </td>
                                                    <td>
                                                        <div>
                                                            <strong><%= course.getCourseName() %></strong>
                                                            <br><small class="text-muted">
                                                                <i class="bi bi-award me-1"></i><%= course.getCredits() %> credits
                                                            </small>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <% if (hasTeacher) { %>
                                                            <div class="d-flex align-items-center">
                                                                <div class="avatar-sm bg-info rounded-circle d-flex align-items-center justify-content-center me-2"
                                                                     style="width: 32px; height: 32px; font-size: 14px;">
                                                                    <i class="bi bi-mortarboard text-white"></i>
                                                                </div>
                                                                <span><%= course.getTeacherName() %></span>
                                                            </div>
                                                        <% } else { %>
                                                            <span class="text-muted">
                                                                <i class="bi bi-person-x me-1"></i>Not assigned
                                                            </span>
                                                        <% } %>
                                                    </td>
                                                    <td>
                                                        <strong><%= course.getEnrolledStudents() %></strong>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <span class="me-2"><%= course.getMaxStudents() %></span>
                                                            <div class="progress flex-grow-1" style="height: 6px; width: 60px;">
                                                                <div class="progress-bar bg-<%= statusBadge %>" 
                                                                     style="width: <%= Math.min(capacityPercentage, 100) %>%"></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-<%= statusBadge %>"><%= statusText %></span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=<%= course.getCourseId() %>" 
                                                               class="btn btn-outline-primary" title="Edit Course">
                                                                <i class="bi bi-pencil"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-outline-danger" 
                                                                    onclick="deleteCourse(<%= course.getCourseId() %>, '<%= course.getCourseCode() %>')" title="Delete Course">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } else { %>
                                <div class="text-center text-muted py-5">
                                    <i class="bi bi-book display-1"></i>
                                    <h5 class="mt-3">No Courses Found</h5>
                                    <p>No courses have been created yet.</p>
                                    <p class="small">Use the form above to add your first course!</p>
                                </div>
                            <% } %>
                        </div>
                        
                        <!-- Grid View -->
                        <div id="courseGridView" style="display: none;" class="p-4">
                            <div class="row g-3" id="coursesGrid">
                                <!-- Grid items will be populated by JavaScript -->
                            </div>
                        </div>
                        
                        <!-- Pagination -->
                        <% if (courses != null && !courses.isEmpty()) { %>
                            <div class="d-flex justify-content-between align-items-center p-3 border-top">
                                <div class="text-muted small">
                                    Showing <span id="courseShowingStart">1</span>-<span id="courseShowingEnd">25</span> 
                                    of <span id="totalCourses"><%= courses.size() %></span> courses
                                </div>
                                <nav aria-label="Courses pagination">
                                    <ul class="pagination pagination-sm mb-0" id="coursesPagination">
                                        <!-- Pagination will be populated by JavaScript -->
                                    </ul>
                                </nav>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Dark Mode Script -->
    <script src="${pageContext.request.contextPath}/js/theme-system.js"></script>
    
    <!-- Enhanced Course Table Management Script -->
    <script>
        // Global variables for course table management
        let allCourses = [];
        let filteredCourses = [];
        let currentCoursePage = 1;
        let coursesPerPage = 25;
        let courseSortColumn = '';
        let courseSortDirection = 'asc';
        let isCourseGridView = false;
        
        // Initialize course table management
        document.addEventListener('DOMContentLoaded', function() {
            initializeCourseTableData();
            setupCourseEventListeners();
            updateCourseTable();
        });
        
        // Extract course data from the table
        function initializeCourseTableData() {
            const rows = document.querySelectorAll('#coursesTableBody tr[data-course-id]');
            allCourses = Array.from(rows).map(row => ({
                id: parseInt(row.dataset.courseId),
                courseCode: row.dataset.courseCode,
                courseName: row.dataset.courseName,
                teacherName: row.dataset.teacherName,
                enrolled: parseInt(row.dataset.enrolled),
                capacity: parseInt(row.dataset.capacity),
                credits: parseInt(row.dataset.credits),
                hasTeacher: row.dataset.hasTeacher === 'true',
                isFull: row.dataset.isFull === 'true',
                element: row.cloneNode(true)
            }));
            filteredCourses = [...allCourses];
        }
        
        // Setup all event listeners for courses
        function setupCourseEventListeners() {
            // Search functionality
            document.getElementById('searchCourses').addEventListener('input', function() {
                currentCoursePage = 1;
                filterAndUpdateCourseTable();
            });
            
            // Course status filter
            document.getElementById('filterCourseStatus').addEventListener('change', function() {
                currentCoursePage = 1;
                filterAndUpdateCourseTable();
            });
            
            // Courses per page
            document.getElementById('coursesPerPage').addEventListener('change', function() {
                coursesPerPage = this.value === 'all' ? filteredCourses.length : parseInt(this.value);
                currentCoursePage = 1;
                updateCourseTable();
            });
            
            // Select all checkbox
            document.getElementById('selectAllCourses').addEventListener('change', function() {
                const checkboxes = document.querySelectorAll('.course-checkbox');
                checkboxes.forEach(cb => {
                    cb.checked = this.checked;
                });
                updateCourseSelectionUI();
            });
            
            // Individual checkbox selection
            document.addEventListener('change', function(e) {
                if (e.target.classList.contains('course-checkbox')) {
                    updateCourseSelectionUI();
                }
            });

            // Sortable headers
            document.querySelectorAll('.sortable').forEach(header => {
                header.addEventListener('click', function(e) {
                    e.preventDefault();
                    const column = this.dataset.column;
                    sortCourseTable(column);
                });
            });
        }
        
        // Filter and search functionality for courses
        function filterAndUpdateCourseTable() {
            const searchTerm = document.getElementById('searchCourses').value.toLowerCase();
            const statusFilter = document.getElementById('filterCourseStatus').value;
            
            filteredCourses = allCourses.filter(course => {
                const matchesSearch = !searchTerm || 
                    course.courseCode.toLowerCase().includes(searchTerm) ||
                    course.courseName.toLowerCase().includes(searchTerm) ||
                    course.teacherName.toLowerCase().includes(searchTerm);
                
                let matchesStatus = true;
                switch (statusFilter) {
                    case 'assigned':
                        matchesStatus = course.hasTeacher;
                        break;
                    case 'unassigned':
                        matchesStatus = !course.hasTeacher;
                        break;
                    case 'full':
                        matchesStatus = course.isFull;
                        break;
                    case 'available':
                        matchesStatus = !course.isFull;
                        break;
                }
                
                return matchesSearch && matchesStatus;
            });
            
            // Update courses per page if it's set to 'all'
            if (document.getElementById('coursesPerPage').value === 'all') {
                coursesPerPage = filteredCourses.length;
            }
            
            updateCourseTable();
        }
        
        // Sort course table by column
        function sortCourseTable(column) {
            if (courseSortColumn === column) {
                courseSortDirection = courseSortDirection === 'asc' ? 'desc' : 'asc';
            } else {
                courseSortColumn = column;
                courseSortDirection = 'asc';
            }
            
            filteredCourses.sort((a, b) => {
                let valueA = a[column];
                let valueB = b[column];
                
                // Handle numeric sorting
                if (['id', 'enrolled', 'capacity', 'credits'].includes(column)) {
                    valueA = parseInt(valueA) || 0;
                    valueB = parseInt(valueB) || 0;
                } else {
                    valueA = valueA.toLowerCase();
                    valueB = valueB.toLowerCase();
                }
                
                if (valueA < valueB) return courseSortDirection === 'asc' ? -1 : 1;
                if (valueA > valueB) return courseSortDirection === 'asc' ? 1 : -1;
                return 0;
            });
            
            updateCourseTable();
            updateCourseSortIcons(column);
        }
        
        // Update sort icons in course table headers
        function updateCourseSortIcons(column) {
            const header = document.querySelector('th a[data-column="' + column + '"]');
            if (!header) return;

            const sortIcon = header.querySelector('.sort-icon');
            if (!sortIcon) return;

            // Reset all icons
            document.querySelectorAll('th a span.sort-icon').forEach(icon => {
                if (icon !== sortIcon) {
                    icon.innerHTML = '↓↑';
                    icon.classList.remove('asc', 'desc');
                }
            });

            if (courseSortDirection === 'asc') {
                sortIcon.innerHTML = '↑';
            } else {
                sortIcon.innerHTML = '↓';
            }
            sortIcon.classList.add(courseSortDirection);
            sortIcon.classList.remove(courseSortDirection === 'asc' ? 'desc' : 'asc');
        }
        
        // Update course table with current page and filters
        function updateCourseTable() {
            if (isCourseGridView) {
                updateCourseGridView();
            } else {
                updateCourseTableView();
            }
            updateCoursePagination();
            updateCourseStats();
        }
        
        // Update course table view
        function updateCourseTableView() {
            const tbody = document.getElementById('coursesTableBody');
            const startIndex = (currentCoursePage - 1) * coursesPerPage;
            const endIndex = startIndex + coursesPerPage;
            const pageCourses = filteredCourses.slice(startIndex, endIndex);
            
            tbody.innerHTML = '';
            
            if (pageCourses.length === 0) {
                tbody.innerHTML = 
                    '<tr>' +
                        '<td colspan="8" class="text-center text-muted py-4">' +
                            '<i class="bi bi-search fs-1 d-block mb-2 opacity-50"></i>' +
                            'No courses found matching your criteria' +
                        '</td>' +
                    '</tr>';
                return;
            }
            
            pageCourses.forEach(course => {
                tbody.appendChild(course.element.cloneNode(true));
            });
            
            // Re-attach event listeners to new checkboxes
            document.querySelectorAll('.course-checkbox').forEach(cb => {
                cb.addEventListener('change', updateCourseSelectionUI);
            });
        }
        
        // Update course grid view
        function updateCourseGridView() {
            const grid = document.getElementById('coursesGrid');
            const startIndex = (currentCoursePage - 1) * coursesPerPage;
            const endIndex = startIndex + coursesPerPage;
            const pageCourses = filteredCourses.slice(startIndex, endIndex);
            
            grid.innerHTML = '';
            
            if (pageCourses.length === 0) {
                grid.innerHTML = 
                    '<div class="col-12 text-center text-muted py-4">' +
                        '<i class="bi bi-search fs-1 d-block mb-2 opacity-50"></i>' +
                        '<p>No courses found matching your criteria</p>' +
                    '</div>';
                return;
            }
            
            pageCourses.forEach(course => {
                const capacityPercentage = course.capacity > 0 ? (course.enrolled / course.capacity) * 100 : 0;
                const statusBadge = course.isFull ? 'danger' : (capacityPercentage > 80 ? 'warning' : 'success');
                const statusText = course.isFull ? 'Full' : (capacityPercentage > 80 ? 'Near Full' : 'Available');
                
                const card = document.createElement('div');
                card.className = 'col-md-6 col-lg-4 col-xl-3';
                card.innerHTML = 
                    '<div class="card h-100 border-0 shadow-sm course-card" data-course-id="' + course.id + '">' +
                        '<div class="card-body">' +
                            '<div class="d-flex justify-content-between align-items-start mb-3">' +
                                '<span class="badge bg-primary">' + course.courseCode + '</span>' +
                                '<span class="badge bg-' + statusBadge + '">' + statusText + '</span>' +
                            '</div>' +
                            '<h6 class="card-title">' + course.courseName + '</h6>' +
                            '<p class="text-muted small mb-2">' +
                                '<i class="bi bi-award me-1"></i>' + course.credits + ' credits' +
                            '</p>' +
                            '<div class="mb-3">' +
                                (course.hasTeacher ? 
                                    '<small class="text-success"><i class="bi bi-mortarboard me-1"></i>' + course.teacherName + '</small>' : 
                                    '<small class="text-muted"><i class="bi bi-person-x me-1"></i>No teacher assigned</small>'
                                ) +
                            '</div>' +
                            '<div class="mb-3">' +
                                '<div class="d-flex justify-content-between align-items-center mb-1">' +
                                    '<small class="text-muted">Enrollment</small>' +
                                    '<small class="fw-bold">' + course.enrolled + '/' + course.capacity + '</small>' +
                                '</div>' +
                                '<div class="progress" style="height: 6px;">' +
                                    '<div class="progress-bar bg-' + statusBadge + '" style="width: ' + Math.min(capacityPercentage, 100) + '%"></div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="btn-group btn-group-sm w-100">' +
                                '<a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=' + course.id + '" ' +
                                   'class="btn btn-outline-primary">' +
                                    '<i class="bi bi-pencil"></i>' +
                                '</a>' +
                                '<button type="button" class="btn btn-outline-danger" onclick="deleteCourse(' + course.id + ', \'' + course.courseCode + '\')">' +
                                    '<i class="bi bi-trash"></i>' +
                                '</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                grid.appendChild(card);
            });
        }
        
        // Toggle between table and grid view for courses
        function toggleCourseView() {
            isCourseGridView = !isCourseGridView;
            const toggleBtn = document.getElementById('toggleCourseViewBtn');
            const tableView = document.getElementById('courseTableView');
            const gridView = document.getElementById('courseGridView');
            
            if (isCourseGridView) {
                tableView.style.display = 'none';
                gridView.style.display = 'block';
                toggleBtn.innerHTML = '<i class="bi bi-table"></i> Table View';
            } else {
                tableView.style.display = 'block';
                gridView.style.display = 'none';
                toggleBtn.innerHTML = '<i class="bi bi-grid-3x3-gap"></i> Grid View';
            }
            
            updateCourseTable();
        }
        
        // Update course pagination
        function updateCoursePagination() {
            const totalPages = Math.ceil(filteredCourses.length / coursesPerPage);
            const pagination = document.getElementById('coursesPagination');
            
            if (totalPages <= 1) {
                pagination.innerHTML = '';
                return;
            }
            
            let paginationHTML = '';
            
            // Previous button
            paginationHTML += 
                '<li class="page-item ' + (currentCoursePage === 1 ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="#" onclick="changeCoursePage(' + (currentCoursePage - 1) + ')">' +
                        '<i class="bi bi-chevron-left"></i>' +
                    '</a>' +
                '</li>';
            
            // Page numbers
            const maxVisiblePages = 5;
            let startPage = Math.max(1, currentCoursePage - Math.floor(maxVisiblePages / 2));
            let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
            
            if (endPage - startPage < maxVisiblePages - 1) {
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }
            
            for (let i = startPage; i <= endPage; i++) {
                paginationHTML += 
                    '<li class="page-item ' + (i === currentCoursePage ? 'active' : '') + '">' +
                        '<a class="page-link" href="#" onclick="changeCoursePage(' + i + ')">' + i + '</a>' +
                    '</li>';
            }
            
            // Next button
            paginationHTML += 
                '<li class="page-item ' + (currentCoursePage === totalPages ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="#" onclick="changeCoursePage(' + (currentCoursePage + 1) + ')">' +
                        '<i class="bi bi-chevron-right"></i>' +
                    '</a>' +
                '</li>';
            
            pagination.innerHTML = paginationHTML;
        }
        
        // Change course page
        function changeCoursePage(page) {
            const totalPages = Math.ceil(filteredCourses.length / coursesPerPage);
            if (page < 1 || page > totalPages) return;
            
            currentCoursePage = page;
            updateCourseTable();
        }
        
        // Update course statistics and counts
        function updateCourseStats() {
            const startIndex = (currentCoursePage - 1) * coursesPerPage;
            const endIndex = Math.min(startIndex + coursesPerPage, filteredCourses.length);
            
            document.getElementById('courseShowingStart').textContent = filteredCourses.length === 0 ? 0 : startIndex + 1;
            document.getElementById('courseShowingEnd').textContent = endIndex;
            document.getElementById('totalCourses').textContent = filteredCourses.length;
            document.getElementById('courseCount').textContent = filteredCourses.length;
        }
        
        // Update course selection UI
        function updateCourseSelectionUI() {
            const selectedCheckboxes = document.querySelectorAll('.course-checkbox:checked');
            const totalCheckboxes = document.querySelectorAll('.course-checkbox');
            const selectedCount = selectedCheckboxes.length;
            
            // Update select all checkbox
            const selectAllCheckbox = document.getElementById('selectAllCourses');
            selectAllCheckbox.indeterminate = selectedCount > 0 && selectedCount < totalCheckboxes.length;
            selectAllCheckbox.checked = selectedCount === totalCheckboxes.length && totalCheckboxes.length > 0;
            
            // Update selected count badge
            const selectedCountBadge = document.getElementById('selectedCourseCount');
            const bulkActionsBtn = document.getElementById('bulkCourseActionsBtn');
            
            if (selectedCount > 0) {
                selectedCountBadge.textContent = selectedCount + ' selected';
                selectedCountBadge.style.display = 'inline-block';
                bulkActionsBtn.disabled = false;
            } else {
                selectedCountBadge.style.display = 'none';
                bulkActionsBtn.disabled = true;
            }
        }
        
        // Individual course actions
        function deleteCourse(courseId, courseCode) {
            if (confirm('Are you sure you want to delete course "' + courseCode + '"?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/courses?action=delete&id=' + courseId;
            }
        }
        
        // Bulk course actions
        function bulkDeleteCourses() {
            const selectedCourses = Array.from(document.querySelectorAll('.course-checkbox:checked'));
            if (selectedCourses.length === 0) return;
            
            const courseIds = selectedCourses.map(cb => cb.value);
            const confirmMessage = 'Are you sure you want to delete ' + courseIds.length + ' selected courses? This action cannot be undone.';
            
            if (confirm(confirmMessage)) {
                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/courses';
                
                // Add action parameter
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'bulkDelete';
                form.appendChild(actionInput);
                
                // Add course IDs
                courseIds.forEach(id => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'courseIds';
                    input.value = id;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function bulkAssignTeacher() {
            const selectedCourses = Array.from(document.querySelectorAll('.course-checkbox:checked'));
            if (selectedCourses.length === 0) return;
            
            const teacherId = prompt('Enter teacher ID to assign to ' + selectedCourses.length + ' courses:');
            if (teacherId && teacherId.trim() !== '') {
                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/courses';
                
                // Add action parameter
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'bulkAssignTeacher';
                form.appendChild(actionInput);
                
                // Add teacher ID
                const teacherInput = document.createElement('input');
                teacherInput.type = 'hidden';
                teacherInput.name = 'teacherId';
                teacherInput.value = teacherId.trim();
                form.appendChild(teacherInput);
                
                // Add course IDs
                selectedCourses.forEach(cb => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'courseIds';
                    input.value = cb.value;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function bulkUpdateCapacity() {
            const selectedCourses = Array.from(document.querySelectorAll('.course-checkbox:checked'));
            if (selectedCourses.length === 0) return;
            
            const newCapacity = prompt('Enter new capacity for ' + selectedCourses.length + ' courses:');
            if (newCapacity && !isNaN(newCapacity) && parseInt(newCapacity) > 0) {
                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/courses';
                
                // Add action parameter
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'bulkUpdateCapacity';
                form.appendChild(actionInput);
                
                // Add new capacity
                const capacityInput = document.createElement('input');
                capacityInput.type = 'hidden';
                capacityInput.name = 'newCapacity';
                capacityInput.value = newCapacity;
                form.appendChild(capacityInput);
                
                // Add course IDs
                selectedCourses.forEach(cb => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'courseIds';
                    input.value = cb.value;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            } else if (newCapacity !== null) {
                alert('Please enter a valid positive number for capacity');
            }
        }
        
        function exportSelectedCourses() {
            const selectedCourses = Array.from(document.querySelectorAll('.course-checkbox:checked'));
            if (selectedCourses.length === 0) {
                alert('Please select courses to export');
                return;
            }
            
            // Create CSV content
            const headers = ['Course ID', 'Course Code', 'Course Name', 'Teacher', 'Enrolled', 'Capacity', 'Credits'];
            let csvContent = headers.join(',') + '\n';
            
            selectedCourses.forEach(checkbox => {
                const row = checkbox.closest('tr');
                const values = [
                    row.dataset.courseId,
                    row.dataset.courseCode,
                    '"' + row.dataset.courseName + '"',
                    '"' + row.dataset.teacherName + '"',
                    row.dataset.enrolled,
                    row.dataset.capacity,
                    row.dataset.credits
                ];
                csvContent += values.join(',') + '\n';
            });
            
            // Download CSV
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'selected_courses_' + new Date().toISOString().split('T')[0] + '.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        }
        
        // Custom file input functionality for courses
        document.getElementById('courseFileInput').addEventListener('change', function(e) {
            const fileLabel = document.getElementById('courseFileLabel');
            const fileIcon = fileLabel.querySelector('.custom-file-icon');
            const fileTitle = fileLabel.querySelector('.custom-file-title');
            const fileSubtitle = fileLabel.querySelector('.custom-file-subtitle');
            
            if (this.files && this.files.length > 0) {
                const file = this.files[0];
                const fileName = file.name;
                const fileSize = (file.size / 1024 / 1024).toFixed(2) + ' MB';
                
                // Update label styling and content
                fileLabel.classList.add('has-file');
                fileIcon.className = 'bi bi-file-earmark-check custom-file-icon';
                fileTitle.textContent = fileName;
                fileSubtitle.textContent = fileSize + ' • Ready to upload';
                
                // Validate file type
                const validExtensions = ['.xlsx', '.csv'];
                const fileExtension = fileName.toLowerCase().substring(fileName.lastIndexOf('.'));
                
                if (validExtensions.includes(fileExtension)) {
                    fileLabel.classList.remove('error');
                    fileLabel.classList.add('success');
                } else {
                    fileLabel.classList.remove('success');
                    fileLabel.classList.add('error');
                    fileSubtitle.textContent = 'Invalid file type. Please select .xlsx or .csv file';
                }
            } else {
                // Reset to default state
                fileLabel.classList.remove('has-file', 'success', 'error');
                fileIcon.className = 'bi bi-cloud-upload custom-file-icon';
                fileTitle.textContent = 'Choose file to upload';
                fileSubtitle.textContent = 'Excel (.xlsx) or CSV (.csv) files only';
            }
        });
    </script>
</body>
</html>

