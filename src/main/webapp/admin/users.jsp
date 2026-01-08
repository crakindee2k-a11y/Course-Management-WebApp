<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.coursemanagement.model.*" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<User> allUsers = (List<User>) request.getAttribute("allUsers");
    List<User> students = (List<User>) request.getAttribute("students");
    List<User> teachers = (List<User>) request.getAttribute("teachers");
    List<User> admins = (List<User>) request.getAttribute("admins");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Course Management System</title>
    
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
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

    <div class="container mt-4 admin-page">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col">
                <h2><i class="bi bi-people-fill me-2"></i>User Management</h2>
                <p class="text-muted">Manage all users in the system</p>
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
        <div class="row mb-4 admin-stats">
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-people-fill text-primary" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${totalUsers}</div>
                            <div class="stat-label">Total Users</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-person-fill text-success" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${totalStudents}</div>
                            <div class="stat-label">Students</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-person-workspace text-info" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${totalTeachers}</div>
                            <div class="stat-label">Teachers</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="dashboard-stat">
                            <i class="bi bi-shield-fill text-warning" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                            <div class="stat-number">${totalAdmins}</div>
                            <div class="stat-label">Admins</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Create New User -->
        <div class="row mb-4">
            <div class="col">
                <div class="card admin-form-section">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-person-plus-fill me-2"></i>Create New User
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/admin/users">
                            <input type="hidden" name="action" value="createUser">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="userType" class="form-label">User Type</label>
                                    <select class="form-select" id="userType" name="userType" required>
                                        <option value="">Select User Type</option>
                                        <option value="STUDENT">Student</option>
                                        <option value="TEACHER">Teacher</option>
                                        <option value="ADMIN">Admin</option>
                                    </select>
                                </div>
                                
                                <div class="col-md-6 mb-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-person-plus me-1"></i>Create User
                                    </button>
                                </div>
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
                            <i class="bi bi-upload me-2"></i>Bulk Import Users
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text text-muted">
                            Upload an Excel (.xlsx) or CSV (.csv) file with user data. The file should contain the following columns in order:
                            <code>username</code>, <code>email</code>, <code>password</code>, <code>fullName</code>, <code>userType</code>.
                            The userType must be either <strong>STUDENT</strong> or <strong>TEACHER</strong>.
                        </p>
                        <form action="${pageContext.request.contextPath}/admin/bulk-import" method="post" enctype="multipart/form-data" id="bulkImportForm">
                            <input type="hidden" name="type" value="users">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <div class="custom-file-input-wrapper">
                                        <input type="file" class="custom-file-input" name="file" id="userFileInput" accept=".xlsx,.csv" required>
                                        <label for="userFileInput" class="custom-file-label" id="userFileLabel">
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

        <!-- Users Table -->
        <div class="row">
            <div class="col">
                <div class="card admin-table-section premium-data-table">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-table me-2"></i>All Users (<span id="userCount"><%= allUsers != null ? allUsers.size() : 0 %></span>)
                        </h5>
                        <div class="d-flex align-items-center gap-2">
                            <span id="selectedCount" class="badge bg-light text-dark" style="display: none;">0 selected</span>
                            <button class="btn btn-light btn-sm" onclick="toggleTableView()" id="toggleViewBtn">
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
                                    <input type="text" class="form-control" id="searchUsers" placeholder="Search users...">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" id="filterUserType">
                                    <option value="">All Types</option>
                                    <option value="ADMIN">Admin</option>
                                    <option value="TEACHER">Teacher</option>
                                    <option value="STUDENT">Student</option>
                                </select>
                            </div>
                            
                            <!-- Bulk Actions -->
                            <div class="col-md-3">
                                <div class="dropdown">
                                    <button class="btn btn-secondary dropdown-toggle" type="button" id="bulkActionsBtn" 
                                            data-bs-toggle="dropdown" disabled>
                                        <i class="bi bi-gear"></i> Bulk Actions
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="#" onclick="bulkDeleteUsers()">
                                            <i class="bi bi-trash text-danger"></i> Delete Selected
                                        </a></li>
                                        <li><a class="dropdown-item" href="#" onclick="bulkChangeUserType()">
                                            <i class="bi bi-person-gear text-info"></i> Change User Type
                                        </a></li>
                                        <li><a class="dropdown-item" href="#" onclick="exportSelectedUsers()">
                                            <i class="bi bi-download text-success"></i> Export Selected
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                            
                            <!-- Pagination Controls -->
                            <div class="col-md-3">
                                <div class="d-flex align-items-center gap-2">
                                    <label class="form-label mb-0 text-nowrap">Show:</label>
                                    <select class="form-select form-select-sm" id="itemsPerPage" style="width: auto;">
                                        <option value="10">10</option>
                                        <option value="25" selected>25</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                        <option value="all">All</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body p-0">
                        <!-- Table View -->
                        <div id="tableView">
                            <div class="table-responsive premium-table-container">
                                <table class="table premium-table mb-0" id="usersTable">
                                    <thead class="sticky-top">
                                        <tr>
                                            <th style="width: 50px;">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="selectAllUsers">
                                                </div>
                                            </th>
                                            <th style="width: 80px;">
                                                <a href="#" class="sortable" data-column="userId">
                                                    ID <span class="sort-icon">↓↑</span>
                                                </a>
                                            </th>
                                            <th>
                                                <a href="#" class="sortable" data-column="username">
                                                    Username <span class="sort-icon">↓↑</span>
                                                </a>
                                            </th>
                                            <th>
                                                <a href="#" class="sortable" data-column="fullName">
                                                    Full Name <span class="sort-icon">↓↑</span>
                                                </a>
                                            </th>
                                            <th>
                                                <a href="#" class="sortable" data-column="email">
                                                    Email <span class="sort-icon">↓↑</span>
                                                </a>
                                            </th>
                                            <th>
                                                <a href="#" class="sortable" data-column="userType">
                                                    Type <span class="sort-icon">↓↑</span>
                                                </a>
                                            </th>
                                            <th>
                                                <a href="#" class="sortable" data-column="createdAt">
                                                    Created <span class="sort-icon">↓↑</span>
                                                </a>
                                            </th>
                                            <th style="width: 120px;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="usersTableBody">
                                        <% if (allUsers != null && !allUsers.isEmpty()) { %>
                                            <% for (User user : allUsers) { %>
                                                <tr data-user-id="<%= user.getUserId() %>" 
                                                    data-username="<%= user.getUsername() %>" 
                                                    data-fullname="<%= user.getFullName() %>" 
                                                    data-email="<%= user.getEmail() %>" 
                                                    data-usertype="<%= user.getUserType() %>" 
                                                    data-created="<%= user.getCreatedAt() %>">
                                                    <td>
                                                        <% if (user.getUserId() != currentUser.getUserId()) { %>
                                                            <div class="form-check">
                                                                <input class="form-check-input user-checkbox" type="checkbox" 
                                                                       value="<%= user.getUserId() %>">
                                                            </div>
                                                        <% } %>
                                                    </td>
                                                    <td><%= user.getUserId() %></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-sm bg-<%= user.getUserType() == User.UserType.ADMIN ? "warning" : 
                                                                                       user.getUserType() == User.UserType.TEACHER ? "info" : "success" %> 
                                                                        rounded-circle d-flex align-items-center justify-content-center me-2"
                                                                 style="width: 32px; height: 32px; font-size: 14px;">
                                                                <i class="bi bi-<%= user.getUserType() == User.UserType.ADMIN ? "shield-check" : 
                                                                                   user.getUserType() == User.UserType.TEACHER ? "mortarboard" : "person" %> text-white"></i>
                                                            </div>
                                                            <strong><%= user.getUsername() %></strong>
                                                        </div>
                                                    </td>
                                                    <td><%= user.getFullName() %></td>
                                                    <td>
                                                        <a href="mailto:<%= user.getEmail() %>" class="text-decoration-none">
                                                            <%= user.getEmail() %>
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-<%= user.getUserType() == User.UserType.ADMIN ? "warning" : 
                                                                               user.getUserType() == User.UserType.TEACHER ? "info" : "success" %>">
                                                            <%= user.getUserType() %>
                                                        </span>
                                                    </td>
                                                    <td class="text-muted small"><%= user.getCreatedAt() %></td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <% if (user.getUserId() != currentUser.getUserId()) { %>
                                                                <button type="button" class="btn btn-outline-primary" 
                                                                        onclick="editUser(<%= user.getUserId() %>)" title="Edit User">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-outline-danger" 
                                                                        onclick="deleteUser(<%= user.getUserId() %>, '<%= user.getUsername() %>')" title="Delete User">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            <% } else { %>
                                                                <span class="badge bg-secondary">Current User</span>
                                                            <% } %>
                                                        </div>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        <% } else { %>
                                            <tr>
                                                <td colspan="8" class="text-center text-muted py-4">
                                                    <i class="bi bi-people-fill fs-1 d-block mb-2 opacity-50"></i>
                                                    No users found
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Grid View (Alternative layout) -->
                        <div id="gridView" style="display: none;" class="p-4">
                            <div class="row g-3" id="usersGrid">
                                <!-- Grid items will be populated by JavaScript -->
                            </div>
                        </div>
                        
                        <!-- Pagination -->
                        <div class="d-flex justify-content-between align-items-center p-3 border-top">
                            <div class="text-muted small">
                                Showing <span id="showingStart">1</span>-<span id="showingEnd">25</span> 
                                of <span id="totalUsers"><%= allUsers != null ? allUsers.size() : 0 %></span> users
                            </div>
                            <nav aria-label="Users pagination">
                                <ul class="pagination pagination-sm mb-0" id="usersPagination">
                                    <!-- Pagination will be populated by JavaScript -->
                                </ul>
                            </nav>
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
    
    <!-- Enhanced Table Management Script -->
    <script>
        // Global variables for table management
        let allUsers = [];
        let filteredUsers = [];
        let currentPage = 1;
        let itemsPerPage = 25;
        let sortColumn = '';
        let sortDirection = 'asc';
        let isGridView = false;
        
        // Initialize table management
        document.addEventListener('DOMContentLoaded', function() {
            initializeTableData();
            setupEventListeners();
            updateTable();
        });
        
        // Extract user data from the table
        function initializeTableData() {
            const rows = document.querySelectorAll('#usersTableBody tr[data-user-id]');
            allUsers = Array.from(rows).map(row => ({
                id: parseInt(row.dataset.userId),
                username: row.dataset.username,
                fullName: row.dataset.fullname,
                email: row.dataset.email,
                userType: row.dataset.usertype,
                created: row.dataset.created,
                element: row.cloneNode(true)
            }));
            filteredUsers = [...allUsers];
        }
        
        // Setup all event listeners
        function setupEventListeners() {
            // Search functionality
            document.getElementById('searchUsers').addEventListener('input', function() {
                currentPage = 1;
                filterAndUpdateTable();
            });
            
            // User type filter
            document.getElementById('filterUserType').addEventListener('change', function() {
                currentPage = 1;
                filterAndUpdateTable();
            });
            
            // Items per page
            document.getElementById('itemsPerPage').addEventListener('change', function() {
                itemsPerPage = this.value === 'all' ? filteredUsers.length : parseInt(this.value);
                currentPage = 1;
                updateTable();
            });
            
            // Select all checkbox
            document.getElementById('selectAllUsers').addEventListener('change', function() {
                const checkboxes = document.querySelectorAll('.user-checkbox:not(:disabled)');
                checkboxes.forEach(cb => {
                    cb.checked = this.checked;
                });
                updateSelectionUI();
            });
            
            // Individual checkbox selection
            document.addEventListener('change', function(e) {
                if (e.target.classList.contains('user-checkbox')) {
                    updateSelectionUI();
                }
            });

            // Sortable headers
            document.querySelectorAll('.sortable').forEach(header => {
                header.addEventListener('click', function(e) {
                    e.preventDefault();
                    const column = this.dataset.column;
                    sortTable(column);
                });
            });
        }
        
        // Filter and search functionality
        function filterAndUpdateTable() {
            const searchTerm = document.getElementById('searchUsers').value.toLowerCase();
            const typeFilter = document.getElementById('filterUserType').value;
            
            filteredUsers = allUsers.filter(user => {
                const matchesSearch = !searchTerm || 
                    user.username.toLowerCase().includes(searchTerm) ||
                    user.fullName.toLowerCase().includes(searchTerm) ||
                    user.email.toLowerCase().includes(searchTerm);
                
                const matchesType = !typeFilter || user.userType === typeFilter;
                
                return matchesSearch && matchesType;
            });
            
            // Update items per page if it's set to 'all'
            if (document.getElementById('itemsPerPage').value === 'all') {
                itemsPerPage = filteredUsers.length;
            }
            
            updateTable();
        }
        
        // Sort table by column
        function sortTable(column) {
            if (sortColumn === column) {
                sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
            } else {
                sortColumn = column;
                sortDirection = 'asc';
            }
            
            filteredUsers.sort((a, b) => {
                let valueA = a[column];
                let valueB = b[column];
                
                // Handle numeric sorting for ID
                if (column === 'id') {
                    valueA = parseInt(valueA);
                    valueB = parseInt(valueB);
                } else {
                    valueA = valueA.toLowerCase();
                    valueB = valueB.toLowerCase();
                }
                
                if (valueA < valueB) return sortDirection === 'asc' ? -1 : 1;
                if (valueA > valueB) return sortDirection === 'asc' ? 1 : -1;
                return 0;
            });
            
            updateTable();
            updateSortIcons(column);
        }
        
        // Update sort icons in table headers
        function updateSortIcons(column) {
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

            if (sortDirection === 'asc') {
                sortIcon.innerHTML = '↑';
            } else {
                sortIcon.innerHTML = '↓';
            }
            sortIcon.classList.add(sortDirection);
            sortIcon.classList.remove(sortDirection === 'asc' ? 'desc' : 'asc');
        }
        
        // Update table with current page and filters
        function updateTable() {
            if (isGridView) {
                updateGridView();
            } else {
                updateTableView();
            }
            updatePagination();
            updateStats();
        }
        
        // Update table view
        function updateTableView() {
            const tbody = document.getElementById('usersTableBody');
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const pageUsers = filteredUsers.slice(startIndex, endIndex);
            
            tbody.innerHTML = '';
            
            if (pageUsers.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="8" class="text-center text-muted py-4">
                            <i class="bi bi-search fs-1 d-block mb-2 opacity-50"></i>
                            No users found matching your criteria
                        </td>
                    </tr>
                `;
                return;
            }
            
            pageUsers.forEach(user => {
                tbody.appendChild(user.element.cloneNode(true));
            });
            
            // Re-attach event listeners to new checkboxes
            document.querySelectorAll('.user-checkbox').forEach(cb => {
                cb.addEventListener('change', updateSelectionUI);
            });
        }
        
        // Update grid view
        function updateGridView() {
            const grid = document.getElementById('usersGrid');
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const pageUsers = filteredUsers.slice(startIndex, endIndex);
            
            grid.innerHTML = '';
            
            if (pageUsers.length === 0) {
                grid.innerHTML = `
                    <div class="col-12 text-center text-muted py-4">
                        <i class="bi bi-search fs-1 d-block mb-2 opacity-50"></i>
                        <p>No users found matching your criteria</p>
                    </div>
                `;
                return;
            }
            
            pageUsers.forEach(user => {
                const badgeClass = user.userType === 'ADMIN' ? 'warning' : 
                                 user.userType === 'TEACHER' ? 'info' : 'success';
                const iconClass = user.userType === 'ADMIN' ? 'shield-check' : 
                                 user.userType === 'TEACHER' ? 'mortarboard' : 'person';
                                
                const card = document.createElement('div');
                card.className = 'col-md-6 col-lg-4 col-xl-3';
                card.innerHTML = 
                    '<div class="card h-100 border-0 shadow-sm user-card" data-user-id="' + user.id + '">' +
                        '<div class="card-body text-center">' +
                            '<div class="position-relative mb-3">' +
                                '<div class="avatar-lg bg-' + badgeClass + ' rounded-circle d-flex align-items-center justify-content-center mx-auto mb-2"' +
                                     ' style="width: 60px; height: 60px;">' +
                                    '<i class="bi bi-' + iconClass + ' text-white fs-4"></i>' +
                                '</div>' +
                                '<span class="badge bg-' + badgeClass + ' position-absolute top-0 end-0">' + user.userType + '</span>' +
                            '</div>' +
                            '<h6 class="card-title">' + user.username + '</h6>' +
                            '<p class="text-muted small mb-2">' + user.fullName + '</p>' +
                            '<p class="text-muted small mb-3">' + user.email + '</p>' +
                            '<div class="btn-group btn-group-sm w-100">' +
                                '<button type="button" class="btn btn-outline-primary" onclick="editUser(' + user.id + ')">' +
                                    '<i class="bi bi-pencil"></i>' +
                                '</button>' +
                                '<button type="button" class="btn btn-outline-danger" onclick="deleteUser(' + user.id + ', \'' + user.username + '\')">' +
                                    '<i class="bi bi-trash"></i>' +
                                '</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                grid.appendChild(card);
            });
        }
        
        // Toggle between table and grid view
        function toggleTableView() {
            isGridView = !isGridView;
            const toggleBtn = document.getElementById('toggleViewBtn');
            const tableView = document.getElementById('tableView');
            const gridView = document.getElementById('gridView');
            
            if (isGridView) {
                tableView.style.display = 'none';
                gridView.style.display = 'block';
                toggleBtn.innerHTML = '<i class="bi bi-table"></i> Table View';
            } else {
                tableView.style.display = 'block';
                gridView.style.display = 'none';
                toggleBtn.innerHTML = '<i class="bi bi-grid-3x3-gap"></i> Grid View';
            }
            
            updateTable();
        }
        
        // Update pagination
        function updatePagination() {
            const totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
            const pagination = document.getElementById('usersPagination');
            
            if (totalPages <= 1) {
                pagination.innerHTML = '';
                return;
            }
            
            let paginationHTML = '';
            
            // Previous button
            paginationHTML += 
                '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="#" onclick="changePage(' + (currentPage - 1) + ')">' +
                        '<i class="bi bi-chevron-left"></i>' +
                    '</a>' +
                '</li>';
            
            // Page numbers
            const maxVisiblePages = 5;
            let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
            let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
            
            if (endPage - startPage < maxVisiblePages - 1) {
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }
            
            for (let i = startPage; i <= endPage; i++) {
                paginationHTML += 
                    '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">' +
                        '<a class="page-link" href="#" onclick="changePage(' + i + ')">' + i + '</a>' +
                    '</li>';
            }
            
            // Next button
            paginationHTML += 
                '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="#" onclick="changePage(' + (currentPage + 1) + ')">' +
                        '<i class="bi bi-chevron-right"></i>' +
                    '</a>' +
                '</li>';
            
            pagination.innerHTML = paginationHTML;
        }
        
        // Change page
        function changePage(page) {
            const totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
            if (page < 1 || page > totalPages) return;
            
            currentPage = page;
            updateTable();
        }
        
        // Update statistics and counts
        function updateStats() {
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = Math.min(startIndex + itemsPerPage, filteredUsers.length);
            
            document.getElementById('showingStart').textContent = filteredUsers.length === 0 ? 0 : startIndex + 1;
            document.getElementById('showingEnd').textContent = endIndex;
            document.getElementById('totalUsers').textContent = filteredUsers.length;
            document.getElementById('userCount').textContent = filteredUsers.length;
        }
        
        // Update selection UI
        function updateSelectionUI() {
            const selectedCheckboxes = document.querySelectorAll('.user-checkbox:checked');
            const totalCheckboxes = document.querySelectorAll('.user-checkbox');
            const selectedCount = selectedCheckboxes.length;
            
            // Update select all checkbox
            const selectAllCheckbox = document.getElementById('selectAllUsers');
            selectAllCheckbox.indeterminate = selectedCount > 0 && selectedCount < totalCheckboxes.length;
            selectAllCheckbox.checked = selectedCount === totalCheckboxes.length && totalCheckboxes.length > 0;
            
            // Update selected count badge
            const selectedCountBadge = document.getElementById('selectedCount');
            const bulkActionsBtn = document.getElementById('bulkActionsBtn');
            
            if (selectedCount > 0) {
                selectedCountBadge.textContent = selectedCount + ' selected';
                selectedCountBadge.style.display = 'inline-block';
                bulkActionsBtn.disabled = false;
            } else {
                selectedCountBadge.style.display = 'none';
                bulkActionsBtn.disabled = true;
            }
        }
        
        // Individual user actions
        function editUser(userId) {
            // Placeholder for edit functionality
            alert('Edit user ' + userId + ' - This functionality can be implemented based on your requirements');
        }
        
        function deleteUser(userId, username) {
            if (confirm('Are you sure you want to delete user "' + username + '"?')) {
                // Create and submit delete form
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/users';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteUser';
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                
                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Bulk actions
        function bulkDeleteUsers() {
            const selectedUsers = Array.from(document.querySelectorAll('.user-checkbox:checked'));
            if (selectedUsers.length === 0) return;
            
            const userIds = selectedUsers.map(cb => cb.value);
            const confirmMessage = 'Are you sure you want to delete ' + userIds.length + ' selected users? This action cannot be undone.';
            
            if (confirm(confirmMessage)) {
                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/users';
                
                // Add action parameter
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'bulkDelete';
                form.appendChild(actionInput);
                
                // Add user IDs
                userIds.forEach(id => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'userIds';
                    input.value = id;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function bulkChangeUserType() {
            const selectedUsers = Array.from(document.querySelectorAll('.user-checkbox:checked'));
            if (selectedUsers.length === 0) return;
            
            const newUserType = prompt('Enter new user type for ' + selectedUsers.length + ' users (ADMIN, TEACHER, STUDENT):');
            if (newUserType && ['ADMIN', 'TEACHER', 'STUDENT'].includes(newUserType.toUpperCase())) {
                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/users';
                
                // Add action parameter
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'bulkChangeType';
                form.appendChild(actionInput);
                
                // Add new user type
                const userTypeInput = document.createElement('input');
                userTypeInput.type = 'hidden';
                userTypeInput.name = 'newUserType';
                userTypeInput.value = newUserType.toUpperCase();
                form.appendChild(userTypeInput);
                
                // Add user IDs
                selectedUsers.forEach(cb => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'userIds';
                    input.value = cb.value;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            } else if (newUserType !== null) {
                alert('Please enter a valid user type: ADMIN, TEACHER, or STUDENT');
            }
        }
        
        function exportSelectedUsers() {
            const selectedUsers = Array.from(document.querySelectorAll('.user-checkbox:checked'));
            if (selectedUsers.length === 0) {
                alert('Please select users to export');
                return;
            }
            
            // Create CSV content
            const headers = ['ID', 'Username', 'Full Name', 'Email', 'User Type', 'Created'];
            let csvContent = headers.join(',') + '\n';
            
            selectedUsers.forEach(checkbox => {
                const row = checkbox.closest('tr');
                const values = [
                    row.dataset.userId,
                    row.dataset.username,
                    '"' + row.dataset.fullname + '"',
                    row.dataset.email,
                    row.dataset.usertype,
                    row.dataset.created
                ];
                csvContent += values.join(',') + '\n';
            });
            
            // Download CSV
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'selected_users_' + new Date().toISOString().split('T')[0] + '.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        }
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl + A to select all
            if (e.ctrlKey && e.key === 'a' && !e.target.matches('input, textarea')) {
                e.preventDefault();
                document.getElementById('selectAllUsers').checked = true;
                document.getElementById('selectAllUsers').dispatchEvent(new Event('change'));
            }
            
            // Escape to clear selection
            if (e.key === 'Escape') {
                document.getElementById('selectAllUsers').checked = false;
                document.getElementById('selectAllUsers').dispatchEvent(new Event('change'));
            }
        });
        
        // Custom file input functionality
        document.getElementById('userFileInput').addEventListener('change', function(e) {
            const fileLabel = document.getElementById('userFileLabel');
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
