<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Enrollment> allEnrollments = (List<Enrollment>) request.getAttribute("allEnrollments");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrollment Management - Course Management System</title>
    
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
                <a class="btn btn-nav-premium btn-dashboard" href="${pageContext.request.contextPath}/admin/dashboard">
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
                <h2><i class="bi bi-journal-check me-2"></i>Enrollment Management</h2>
                <p class="text-muted">Manage all course enrollments in the system</p>
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

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-journal-check text-primary" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${totalEnrollments}</div>
                            <div class="stat-label">Total Enrollments</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${activeEnrollments}</div>
                            <div class="stat-label">Active</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-award-fill text-info" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${completedEnrollments}</div>
                            <div class="stat-label">Completed</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-x-circle-fill text-danger" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${droppedEnrollments}</div>
                            <div class="stat-label">Dropped</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search and Filter Controls -->
        <div class="card mb-4 filter-controls-card">
            <div class="card-body">
                <div class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <input type="text" class="form-control" id="searchInput" placeholder="Search student, course, or email..." onkeyup="filterTable()">
                    </div>
                    <div class="col-md-3">
                        <select id="statusFilter" class="form-select" onchange="filterTable()">
                            <option value="">All Statuses</option>
                            <option value="ENROLLED">Enrolled</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="DROPPED">Dropped</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <div class="d-flex gap-2">
                            <button class="btn btn-outline-secondary btn-sm" onclick="clearFilters()">
                                <i class="bi bi-x-circle"></i> Clear
                            </button>
                            <div class="dropdown">
                                <button class="btn btn-outline-primary btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-funnel"></i> Rows
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#" onclick="changePageSize(5)">5 per page</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="changePageSize(10)">10 per page</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="changePageSize(25)">25 per page</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="changePageSize(-1)">Show all</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <small class="text-muted">
                            <span id="resultCount">0</span> results
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enrollments Table -->
        <div class="row">
            <div class="col">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-table me-2"></i>All Enrollments
                        </h5>
                    </div>
                    <div class="card-body">
                                <div class="table-responsive premium-table-container">
                                    <table class="table premium-table" id="enrollmentTable">
                                        <thead>
                                            <tr>
                                                <th onclick="sortTable(0)">ID <i class="bi bi-arrow-down-up"></i></th>
                                                <th onclick="sortTable(1)">Student <i class="bi bi-arrow-down-up"></i></th>
                                                <th onclick="sortTable(2)">Course <i class="bi bi-arrow-down-up"></i></th>
                                                <th onclick="sortTable(3)">Status <i class="bi bi-arrow-down-up"></i></th>
                                                <th onclick="sortTable(4)">Enrolled Date <i class="bi bi-arrow-down-up"></i></th>
                                                <th onclick="sortTable(5)">Last Updated <i class="bi bi-arrow-down-up"></i></th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="enrollmentTableBody">
                                    <% if (allEnrollments != null && !allEnrollments.isEmpty()) { %>
                                        <% for (Enrollment enrollment : allEnrollments) { %>
                                            <tr>
                                                <td><%= enrollment.getEnrollmentId() %></td>
                                                <td>
                                                    <div>
                                                        <strong><%= enrollment.getStudentName() %></strong><br>
                                                        <small class="text-muted"><%= enrollment.getStudentEmail() %></small>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div>
                                                        <strong><%= enrollment.getCourseCode() %></strong><br>
                                                        <small class="text-muted"><%= enrollment.getCourseName() %></small>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge <%= "ENROLLED".equalsIgnoreCase(enrollment.getStatus().toString()) || "ACTIVE".equalsIgnoreCase(enrollment.getStatus().toString()) ? "badge-status-enrolled" : 
                                                                           "COMPLETED".equalsIgnoreCase(enrollment.getStatus().toString()) ? "badge-status-completed" : 
                                                                           "DROPPED".equalsIgnoreCase(enrollment.getStatus().toString()) ? "badge-status-dropped" : "bg-secondary" %>">
                                                        <%= enrollment.getStatus() %>
                                                    </span>
                                                </td>
                                                <td><%= enrollment.getEnrollmentDate() %></td>
                                                <td><%= enrollment.getLastUpdated() %></td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <!-- Status Update Dropdown -->
                                                        <div class="dropdown">
                                                            <button class="btn btn-outline-primary btn-sm dropdown-toggle" type="button" 
                                                                    data-bs-toggle="dropdown">
                                                                <i class="bi bi-gear"></i> Status
                                                            </button>
                                                            <ul class="dropdown-menu">
                                                                <li>
                                                                    <form method="post" action="${pageContext.request.contextPath}/admin/enrollments" style="display: inline;">
                                                                        <input type="hidden" name="action" value="updateStatus">
                                                                        <input type="hidden" name="enrollmentId" value="<%= enrollment.getEnrollmentId() %>">
                                                                        <input type="hidden" name="newStatus" value="COMPLETED">
                                                                        <button type="submit" class="dropdown-item" 
                                                                                onclick="return confirm('Change status to COMPLETED?')">
                                                                            <i class="bi bi-award text-info"></i> Set Completed
                                                                        </button>
                                                                    </form>
                                                                </li>
                                                                <li>
                                                                    <form method="post" action="${pageContext.request.contextPath}/admin/enrollments" style="display: inline;">
                                                                        <input type="hidden" name="action" value="updateStatus">
                                                                        <input type="hidden" name="enrollmentId" value="<%= enrollment.getEnrollmentId() %>">
                                                                        <input type="hidden" name="newStatus" value="DROPPED">
                                                                        <button type="submit" class="dropdown-item" 
                                                                                onclick="return confirm('Change status to DROPPED?')">
                                                                            <i class="bi bi-x-circle text-danger"></i> Set Dropped
                                                                        </button>
                                                                    </form>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        
                                                        <!-- Delete Button -->
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/enrollments" style="display: inline;">
                                                            <input type="hidden" name="action" value="deleteEnrollment">
                                                            <input type="hidden" name="enrollmentId" value="<%= enrollment.getEnrollmentId() %>">
                                                            <button type="submit" class="btn btn-danger btn-sm" 
                                                                    onclick="return confirm('Are you sure you want to delete this enrollment?')">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="7" class="text-center text-muted">No enrollments found</td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination Controls -->
                        <div class="card-footer">
                            <nav aria-label="Table pagination">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <small class="text-muted">
                                            Showing <span id="showingStart">1</span>-<span id="showingEnd">10</span> of <span id="showingTotal">0</span> entries
                                        </small>
                                    </div>
                                    <ul class="pagination pagination-sm mb-0" id="pagination">
                                        <!-- Pagination buttons will be generated by JavaScript -->
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Table management variables
        let currentPage = 1;
        let rowsPerPage = 10;
        let sortColumn = -1;
        let sortDirection = 'asc';
        let allRows = [];
        let filteredRows = [];

        // Initialize table on page load
        document.addEventListener('DOMContentLoaded', function() {
            initializeTable();
        });

        function initializeTable() {
            const tableBody = document.getElementById('enrollmentTableBody');
            allRows = Array.from(tableBody.querySelectorAll('tr'));
            filteredRows = [...allRows];
            updateDisplay();
        }

        function filterTable() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;

            filteredRows = allRows.filter(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length === 0) return false;

                // Search in student name, course, and email
                const studentName = cells[1].textContent.toLowerCase();
                const courseName = cells[2].textContent.toLowerCase();
                const status = cells[3].textContent.trim();

                const matchesSearch = searchTerm === '' || 
                    studentName.includes(searchTerm) || 
                    courseName.includes(searchTerm);

                const matchesStatus = statusFilter === '' || status.includes(statusFilter);

                return matchesSearch && matchesStatus;
            });

            currentPage = 1;
            updateDisplay();
        }

        function sortTable(column) {
            if (sortColumn === column) {
                sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
            } else {
                sortColumn = column;
                sortDirection = 'asc';
            }

            filteredRows.sort((a, b) => {
                const aValue = a.querySelectorAll('td')[column]?.textContent.trim() || '';
                const bValue = b.querySelectorAll('td')[column]?.textContent.trim() || '';

                let comparison = 0;
                if (column === 0) { // ID column - numeric sort
                    comparison = parseInt(aValue) - parseInt(bValue);
                } else if (column === 4 || column === 5) { // Date columns
                    comparison = new Date(aValue) - new Date(bValue);
                } else { // Text columns
                    comparison = aValue.localeCompare(bValue);
                }

                return sortDirection === 'asc' ? comparison : -comparison;
            });

            updateDisplay();
        }

        function changePageSize(size) {
            rowsPerPage = size === -1 ? filteredRows.length : size;
            currentPage = 1;
            updateDisplay();
        }

        function goToPage(page) {
            currentPage = page;
            updateDisplay();
        }

        function updateDisplay() {
            const tableBody = document.getElementById('enrollmentTableBody');
            const totalRows = filteredRows.length;
            
            // Update result count
            document.getElementById('resultCount').textContent = totalRows;

            // Clear current table
            tableBody.innerHTML = '';

            if (totalRows === 0) {
                tableBody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">No enrollments found</td></tr>';
                updatePaginationInfo(0, 0, 0);
                document.getElementById('pagination').innerHTML = '';
                return;
            }

            // Calculate pagination
            const totalPages = Math.ceil(totalRows / rowsPerPage);
            const startIndex = (currentPage - 1) * rowsPerPage;
            const endIndex = Math.min(startIndex + rowsPerPage, totalRows);

            // Show rows for current page
            for (let i = startIndex; i < endIndex; i++) {
                tableBody.appendChild(filteredRows[i].cloneNode(true));
            }

            // Update pagination info and controls
            updatePaginationInfo(startIndex + 1, endIndex, totalRows);
            updatePaginationControls(currentPage, totalPages);
        }

        function updatePaginationInfo(start, end, total) {
            document.getElementById('showingStart').textContent = start;
            document.getElementById('showingEnd').textContent = end;
            document.getElementById('showingTotal').textContent = total;
        }

        function updatePaginationControls(current, total) {
            const pagination = document.getElementById('pagination');
            pagination.innerHTML = '';

            if (total <= 1) return;

            // Previous button
            const prevLi = document.createElement('li');
            prevLi.className = 'page-item' + (current === 1 ? ' disabled' : '');
            prevLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + (current - 1) + ')">Previous</a>';
            pagination.appendChild(prevLi);

            // Page numbers
            for (let i = 1; i <= total; i++) {
                if (i === 1 || i === total || (i >= current - 2 && i <= current + 2)) {
                    const li = document.createElement('li');
                    li.className = 'page-item' + (i === current ? ' active' : '');
                    li.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + i + ')">' + i + '</a>';
                    pagination.appendChild(li);
                } else if (i === current - 3 || i === current + 3) {
                    const li = document.createElement('li');
                    li.className = 'page-item disabled';
                    li.innerHTML = '<span class="page-link">...</span>';
                    pagination.appendChild(li);
                }
            }

            // Next button
            const nextLi = document.createElement('li');
            nextLi.className = 'page-item' + (current === total ? ' disabled' : '');
            nextLi.innerHTML = '<a class="page-link" href="#" onclick="goToPage(' + (current + 1) + ')">Next</a>';
            pagination.appendChild(nextLi);
        }

        function clearFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = '';
            filterTable();
        }
    </script>
    <!-- Dark Mode Script -->
    <script src="${pageContext.request.contextPath}/js/theme-system.js"></script>
</body>
</html>
