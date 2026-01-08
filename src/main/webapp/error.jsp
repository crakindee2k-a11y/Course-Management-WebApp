<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Course Management System</title>
    
    <!-- Apply theme before CSS to prevent flash -->
    <%@ include file="/WEB-INF/jspf/theme-init.jspf" %>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 3rem;
            text-align: center;
            max-width: 500px;
        }
        
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="bi bi-exclamation-triangle-fill error-icon"></i>
        <h1 class="h3 mb-3">Oops! Something went wrong</h1>
        
        <c:choose>
            <c:when test="${not empty errorMessage}">
                <p class="text-muted mb-4">${errorMessage}</p>
            </c:when>
            <c:otherwise>
                <p class="text-muted mb-4">An unexpected error occurred. Please try again or contact support if the problem persists.</p>
            </c:otherwise>
        </c:choose>
        
        <div class="d-grid gap-2 d-md-flex justify-content-md-center">
            <a href="javascript:history.back()" class="btn btn-secondary">
                <i class="bi bi-arrow-left me-2"></i>Go Back
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="bi bi-house me-2"></i>Home
            </a>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
