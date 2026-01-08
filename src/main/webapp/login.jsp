<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management System - Login</title>
    
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
    
    <style>
        body {
            background: 
                radial-gradient(circle at 20% 20%, rgba(99, 102, 241, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(139, 92, 246, 0.1) 0%, transparent 50%),
                linear-gradient(135deg, var(--accent-primary) 0%, var(--accent-hover) 50%, #8b5cf6 100%);
            min-height: 100vh;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }
        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%236366f1' fill-opacity='0.03'%3E%3Ccircle cx='30' cy='30' r='1'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            pointer-events: none;
            z-index: -1;
        }
        
        /* Floating background elements */
        body::after {
            content: '';
            position: fixed;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: 
                radial-gradient(circle at 25% 25%, rgba(255, 255, 255, 0.05) 0%, transparent 50%),
                radial-gradient(circle at 75% 75%, rgba(139, 92, 246, 0.05) 0%, transparent 50%);
            animation: float-bg 20s ease-in-out infinite;
            pointer-events: none;
            z-index: -1;
        }
        
        @keyframes float-bg {
            0%, 100% { transform: rotate(0deg) scale(1); }
            50% { transform: rotate(180deg) scale(1.1); }
        }
        
        /* Premium Background Scene: animated blobs + subtle grid + spotlight */
        .bg-scene {
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: -1;
            --spot-x: 50%;
            --spot-y: 50%;
        }
        .bg-scene::after {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(380px circle at var(--spot-x) var(--spot-y), rgba(255,255,255,0.025), transparent 70%);
            mix-blend-mode: soft-light;
        }
        .bg-blob {
            position: absolute;
            width: 520px;
            height: 520px;
            filter: blur(120px);
            opacity: 0.25;
            mix-blend-mode: screen;
            border-radius: 50%;
            transform: translateZ(0);
        }
        .bg-blob.blob-1 {
            top: -12%;
            left: -10%;
            background: radial-gradient(circle at 30% 30%, #6366f1 0%, rgba(99,102,241,0.6) 40%, transparent 70%);
            animation: blobFloat1 26s ease-in-out infinite alternate;
        }
        .bg-blob.blob-2 {
            right: -12%;
            bottom: -16%;
            background: radial-gradient(circle at 70% 70%, #8b5cf6 0%, rgba(139,92,246,0.55) 35%, transparent 70%);
            animation: blobFloat2 32s ease-in-out infinite alternate;
        }
        @keyframes blobFloat1 {
            0% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(24px, -36px) scale(1.05); }
            100% { transform: translate(-20px, 18px) scale(1.02); }
        }
        @keyframes blobFloat2 {
            0% { transform: translate(0, 0) scale(1.02); }
            50% { transform: translate(-28px, 30px) scale(1.07); }
            100% { transform: translate(22px, -22px) scale(1.02); }
        }
        .bg-grid {
            position: absolute;
            inset: -10% -10% -10% -10%;
            background-image:
                radial-gradient(rgba(255,255,255,0.035) 0.8px, transparent 0.9px),
                radial-gradient(rgba(255,255,255,0.02) 0.6px, transparent 0.8px);
            background-size: 3px 3px, 2px 2px;
            background-position: 0 0, 1px 1px;
            mask-image: radial-gradient(ellipse at 50% 50%, black 60%, transparent 95%);
            -webkit-mask-image: radial-gradient(ellipse at 50% 50%, black 60%, transparent 95%);
        }
        
        /* Light theme adjustments for background scene */
        [data-theme="light"] .bg-blob.blob-1, [data-bs-theme="light"] .bg-blob.blob-1 {
            background: radial-gradient(circle at 30% 30%, #a5b4fc 0%, rgba(165,180,252,0.6) 40%, transparent 70%);
            opacity: 0.35;
        }
        [data-theme="light"] .bg-blob.blob-2, [data-bs-theme="light"] .bg-blob.blob-2 {
            background: radial-gradient(circle at 70% 70%, #c4b5fd 0%, rgba(196,181,253,0.55) 35%, transparent 70%);
            opacity: 0.35;
        }
        [data-theme="light"] .bg-grid, [data-bs-theme="light"] .bg-grid {
            background-image:
                radial-gradient(rgba(17,24,39,0.06) 0.8px, transparent 0.9px),
                radial-gradient(rgba(17,24,39,0.035) 0.6px, transparent 0.8px);
        }
        
        /* Light theme background */
        [data-theme="light"] body, [data-bs-theme="light"] body {
            background: 
                radial-gradient(circle at 20% 20%, rgba(59, 130, 246, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(139, 92, 246, 0.06) 0%, transparent 50%),
                linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        }
        
        [data-theme="dark"] body, [data-bs-theme="dark"] body {
            background: 
                radial-gradient(circle at 20% 20%, rgba(99, 102, 241, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(139, 92, 246, 0.1) 0%, transparent 50%),
                linear-gradient(135deg, #1a1a1d 0%, #25252a 100%);
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        @keyframes gentleGlow {
            0%, 100% {
                box-shadow: 
                    0 25px 50px rgba(0, 0, 0, 0.15),
                    0 8px 32px rgba(99, 102, 241, 0.1),
                    inset 0 1px 0 rgba(255, 255, 255, 0.2);
            }
            50% {
                box-shadow: 
                    0 30px 60px rgba(0, 0, 0, 0.18),
                    0 10px 36px rgba(99, 102, 241, 0.15),
                    inset 0 1px 0 rgba(255, 255, 255, 0.25);
            }
        }
        
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(30px) saturate(180%);
            -webkit-backdrop-filter: blur(30px) saturate(180%);
            border-radius: var(--radius-2xl);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.15),
                0 8px 32px rgba(99, 102, 241, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.2);
            overflow: hidden;
            max-width: 320px;
            width: 100%;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            animation: slideUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }
        
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.05), transparent);
            opacity: 0;
            transition: opacity var(--transition-normal);
            pointer-events: none;
        }
        
        .login-card:hover {
            transform: translateY(-6px);
            box-shadow: 
                0 30px 60px rgba(0, 0, 0, 0.2),
                0 12px 40px rgba(99, 102, 241, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
        }
        
        .login-card:hover::before {
            opacity: 1;
        }
        
        [data-theme="dark"] .login-card, [data-bs-theme="dark"] .login-card {
            background: rgba(37, 37, 42, 0.4);
            backdrop-filter: blur(40px) saturate(200%);
            border: 1px solid rgba(99, 102, 241, 0.3);
            box-shadow: 
                0 35px 70px rgba(0, 0, 0, 0.4),
                0 12px 40px rgba(99, 102, 241, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.05);
        }
        
        [data-theme="dark"] .login-card:hover, [data-bs-theme="dark"] .login-card:hover {
            border-color: rgba(99, 102, 241, 0.5);
            box-shadow: 
                0 35px 70px rgba(0, 0, 0, 0.4),
                0 14px 45px rgba(99, 102, 241, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.1);
        }

        /* Light Theme Overrides */
        [data-theme="light"] .login-card, [data-bs-theme="light"] .login-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(40px) saturate(180%);
            border: 1px solid rgba(0, 0, 0, 0.1);
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.1),
                0 8px 32px rgba(0, 0, 0, 0.05);
        }

        [data-theme="light"] .login-card:hover, [data-bs-theme="light"] .login-card:hover {
            border-color: rgba(59, 130, 246, 0.3);
            box-shadow: 
                0 30px 60px rgba(0, 0, 0, 0.12),
                0 12px 40px rgba(59, 130, 246, 0.1);
        }

        [data-theme="light"] .form-floating input, [data-bs-theme="light"] .form-floating input {
            background: rgba(243, 244, 246, 0.7);
            border-color: rgba(0, 0, 0, 0.1);
            color: #111827;
        }

        [data-theme="light"] .form-floating input:focus, [data-bs-theme="light"] .form-floating input:focus {
            background: white;
        }

        [data-theme="light"] .form-floating label, [data-bs-theme="light"] .form-floating label {
            color: #6b7280;
        }

        [data-theme="light"] .demo-credentials, [data-bs-theme="light"] .demo-credentials {
            background: rgba(243, 244, 246, 0.6);
            border-color: rgba(0, 0, 0, 0.1);
        }

        [data-theme="light"] .demo-credentials:hover, [data-bs-theme="light"] .demo-credentials:hover {
            background: rgba(229, 231, 235, 0.7);
            border-color: rgba(0, 0, 0, 0.15);
        }

        [data-theme="light"] .demo-credentials h6, [data-bs-theme="light"] .demo-credentials h6 {
            color: #1f2937;
        }

        [data-theme="light"] .demo-credentials .credential-item, [data-bs-theme="light"] .demo-credentials .credential-item {
            border-bottom-color: rgba(0, 0, 0, 0.08);
        }

        [data-theme="light"] .demo-credentials .credential-item:hover, [data-bs-theme="light"] .demo-credentials .credential-item:hover {
            background: rgba(0, 0, 0, 0.03);
        }

        [data-theme="light"] .demo-credentials .credential-item strong, [data-bs-theme="light"] .demo-credentials .credential-item strong {
            color: #111827;
        }

        [data-theme="light"] .demo-credentials .credential-item code, [data-bs-theme="light"] .demo-credentials .credential-item code {
            background: rgba(0, 0, 0, 0.05);
            color: #374151;
            border-color: rgba(0, 0, 0, 0.1);
        }

        [data-theme="light"] .demo-credentials .credential-item code:hover, [data-bs-theme="light"] .demo-credentials .credential-item code:hover {
            background: rgba(0, 0, 0, 0.1);
            border-color: rgba(0, 0, 0, 0.15);
        }
        
        .login-header {
            background: linear-gradient(135deg, var(--accent-primary) 0%, var(--accent-hover) 50%, #8b5cf6 100%);
            color: white;
            padding: var(--space-3) var(--space-4);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            animation: shimmer 3s ease-in-out infinite;
        }
        
        @keyframes shimmer {
            0%, 100% { transform: translateX(-100%); }
            50% { transform: translateX(100%); }
        }
        
        .login-header::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
            pointer-events: none;
        }
        
        .login-header h2 {
            margin: 0;
            font-weight: 800;
            font-size: var(--font-lg);
            letter-spacing: -0.02em;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 2;
        }
        
        .login-header p {
            margin: var(--space-1) 0 0;
            opacity: 0.9;
            font-size: var(--font-sm);
            position: relative;
            z-index: 2;
        }
        
        .login-header .bi-mortarboard-fill {
            font-size: 2rem;
            margin-bottom: var(--space-2);
            color: rgba(255, 255, 255, 0.9);
            filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
            animation: pulse 3s ease-in-out infinite;
            position: relative;
            z-index: 2;
        }
        
        .login-body {
            padding: var(--space-3) var(--space-4) var(--space-3);
            position: relative;
            isolation: isolate;
        }
        
        .form-floating {
            margin-bottom: var(--space-3);
            position: relative;
        }
        
        .form-floating input {
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: var(--radius-xl);
            padding: var(--space-2);
            background: rgba(255, 255, 255, 0.1);
            transition: all var(--transition-normal);
            color: var(--text-primary);
            font-size: var(--font-sm);
            height: calc(2.5rem + 2px);
            line-height: 1.25;
        }
        
        .form-floating input::placeholder {
            color: transparent;
        }
        
        .form-floating input:focus {
            border-color: var(--accent-primary);
            box-shadow: 
                0 0 0 3px rgba(var(--accent-primary-rgb), 0.15);
            background: rgba(255, 255, 255, 0.15);
        }
        
        [data-theme="dark"] .form-floating input, [data-bs-theme="dark"] .form-floating input {
            border-color: rgba(99, 102, 241, 0.2);
            background: rgba(37, 37, 42, 0.5);
            color: var(--text-primary);
        }
        
        [data-theme="dark"] .form-floating input:focus, [data-bs-theme="dark"] .form-floating input:focus {
            border-color: var(--accent-primary);
            background: rgba(37, 37, 42, 0.7);
            box-shadow: 
                0 0 0 3px rgba(99, 102, 241, 0.15);
        }
        
        .form-floating label {
            color: rgba(255, 255, 255, 0.7);
            font-size: var(--font-sm);
            font-weight: 500;
            transition: all var(--transition-normal);
            padding: var(--space-2);
            filter: none;
            box-shadow: none;
            text-shadow: none;
        }
        
        [data-theme="dark"] .form-floating label, [data-bs-theme="dark"] .form-floating label {
            color: var(--text-secondary);
        }
        
        .form-floating input:focus ~ label,
        .form-floating input:not(:placeholder-shown) ~ label {
            color: var(--accent-primary);
            font-weight: 600;
            filter: none;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            text-shadow: none;
        }
        
        [data-theme="light"] .form-floating input:focus ~ label,
        [data-theme="light"] .form-floating input:not(:placeholder-shown) ~ label,
        [data-bs-theme="light"] .form-floating input:focus ~ label,
        [data-bs-theme="light"] .form-floating input:not(:placeholder-shown) ~ label {
            color: #4f46e5;
            filter: none;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
            text-shadow: none;
        }
        
        /* Override any Bootstrap floating label shadows */
        .form-floating input:focus ~ label:before,
        .form-floating input:not(:placeholder-shown) ~ label:before,
        .form-floating input:focus ~ label:after,
        .form-floating input:not(:placeholder-shown) ~ label:after {
            display: none !important;
        }
        
        .form-floating > label {
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04) !important;
        }
        
        .btn-login {
            background: linear-gradient(135deg, var(--accent-primary) 0%, var(--accent-hover) 50%, #8b5cf6 100%);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-xl);
            font-weight: 700;
            font-size: var(--font-sm);
            transition: all var(--transition-normal);
            box-shadow: 
                0 8px 24px rgba(var(--accent-primary-rgb), 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.2);
            color: white;
            width: 100%;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s;
        }
        
        .btn-login:hover::before {
            left: 100%;
        }
        
        .btn-login:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 
                0 12px 32px rgba(var(--accent-primary-rgb), 0.4),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            background: linear-gradient(135deg, var(--accent-hover) 0%, var(--accent-primary) 50%, #7c3aed 100%);
            color: white;
            border-color: rgba(255, 255, 255, 0.3);
        }
        
        .btn-login:active {
            transform: translateY(-1px) scale(0.98);
        }
        
        .alert {
            border: none;
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 16px;
            font-size: 0.85rem;
        }
        
        .demo-credentials {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: var(--radius-xl);
            padding: var(--space-5);
            margin-top: var(--space-5);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }
        
        /* Purple line removed as requested */
        
        .demo-credentials:hover {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }
        
        [data-theme="dark"] .demo-credentials, [data-bs-theme="dark"] .demo-credentials {
            background: rgba(37, 37, 42, 0.5);
            border-color: rgba(99, 102, 241, 0.2);
            backdrop-filter: blur(20px);
            box-shadow: 
                0 8px 32px rgba(0, 0, 0, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.05);
        }
        
        [data-theme="dark"] .demo-credentials:hover, [data-bs-theme="dark"] .demo-credentials:hover {
            background: rgba(37, 37, 42, 0.7);
            border-color: rgba(99, 102, 241, 0.3);
            box-shadow: 
                0 12px 40px rgba(0, 0, 0, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.1);
        }
        
        .demo-credentials h6 {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 700;
            margin-bottom: var(--space-3);
            font-size: var(--font-sm);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }
        
        [data-theme="dark"] .demo-credentials h6, [data-bs-theme="dark"] .demo-credentials h6 {
            color: var(--text-primary);
        }
        
        .demo-credentials .credential-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-2) 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: all var(--transition-fast);
        }
        
        .demo-credentials .credential-item:hover {
            padding-left: var(--space-2);
            background: rgba(255, 255, 255, 0.05);
            border-radius: var(--radius-md);
            margin: 0 calc(-1 * var(--space-2));
            padding-right: var(--space-2);
        }
        
        [data-theme="dark"] .demo-credentials .credential-item, [data-bs-theme="dark"] .demo-credentials .credential-item {
            border-bottom-color: rgba(99, 102, 241, 0.1);
        }
        
        [data-theme="dark"] .demo-credentials .credential-item:hover, [data-bs-theme="dark"] .demo-credentials .credential-item:hover {
            background: rgba(99, 102, 241, 0.1);
        }
        
        .demo-credentials .credential-item:last-child {
            border-bottom: none;
        }
        
        .demo-credentials .credential-item strong {
            color: rgba(255, 255, 255, 0.9);
            font-size: var(--font-sm);
            font-weight: 600;
        }
        
        [data-theme="dark"] .demo-credentials .credential-item strong, [data-bs-theme="dark"] .demo-credentials .credential-item strong {
            color: var(--text-primary);
        }
        
        .demo-credentials .credential-item code {
            background: rgba(255, 255, 255, 0.15);
            color: rgba(255, 255, 255, 0.95);
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-md);
            font-size: var(--font-xs);
            font-weight: 700;
            font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', monospace;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(5px);
            transition: all var(--transition-fast);
        }
        
        .demo-credentials .credential-item code:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }
        
        [data-theme="dark"] .demo-credentials .credential-item code, [data-bs-theme="dark"] .demo-credentials .credential-item code {
            background: rgba(99, 102, 241, 0.15);
            color: var(--accent-primary);
            border-color: rgba(99, 102, 241, 0.2);
        }
        
        [data-theme="dark"] .demo-credentials .credential-item code:hover, [data-bs-theme="dark"] .demo-credentials .credential-item code:hover {
            background: rgba(99, 102, 241, 0.25);
            border-color: rgba(99, 102, 241, 0.4);
        }
        
        /* ✨ ARTISTIC QUOTE SECTION STYLES ✨ */
        .artistic-quote {
            position: relative;
            overflow: hidden;
            text-align: center;
            background: linear-gradient(135deg, 
                rgba(255, 255, 255, 0.1) 0%, 
                rgba(255, 255, 255, 0.05) 100%);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            box-shadow: 
                0 8px 32px rgba(0, 0, 0, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.2);
        }
        
        [data-theme="dark"] .artistic-quote, [data-bs-theme="dark"] .artistic-quote {
            background: linear-gradient(135deg, 
                rgba(37, 37, 42, 0.3) 0%, 
                rgba(99, 102, 241, 0.1) 100%);
            border-color: rgba(99, 102, 241, 0.2);
            box-shadow: 
                0 8px 32px rgba(0, 0, 0, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.1);
        }
        
        .quote-content {
            position: relative;
            z-index: 2;
            padding: var(--space-2);
        }
        
        .quote-icon {
            font-size: 1.5rem;
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--space-1);
            animation: iconGlow 3s ease-in-out infinite alternate;
        }
        
        @keyframes iconGlow {
            0% { filter: drop-shadow(0 0 10px rgba(251, 191, 36, 0.3)); }
            100% { filter: drop-shadow(0 0 20px rgba(251, 191, 36, 0.6)); }
        }
        
        .quote-text {
            font-size: 0.85rem;
            font-weight: 500;
            font-style: italic;
            line-height: 1.4;
            color: rgba(255, 255, 255, 0.95);
            margin: var(--space-1) 0;
            position: relative;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        [data-theme="dark"] .quote-text, [data-bs-theme="dark"] .quote-text {
            color: var(--text-primary);
        }
        
        .quote-text::before, .quote-text::after {
            content: '"';
            font-size: 2rem;
            font-family: serif;
            position: absolute;
            opacity: 0.3;
            background: linear-gradient(135deg, var(--accent-primary), #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .quote-text::before {
            top: -0.5rem;
            left: -1rem;
        }
        
        .quote-text::after {
            bottom: -1rem;
            right: -1rem;
            transform: rotate(180deg);
        }
        
        .quote-author {
            font-size: 0.75rem;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.7);
            letter-spacing: 0.5px;
            position: relative;
        }
        
        [data-theme="dark"] .quote-author, [data-bs-theme="dark"] .quote-author {
            color: rgba(255, 255, 255, 0.8);
        }
        
        .quote-author::before {
            content: '';
            width: 40px;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent-primary), transparent);
            position: absolute;
            top: -0.5rem;
            left: 50%;
            transform: translateX(-50%);
        }
        
        /* ✨ FLOATING ANIMATION ELEMENTS ✨ */
        .floating-elements {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
        }
        
        .float-dot {
            position: absolute;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-primary), #8b5cf6);
            opacity: 0.6;
            animation: floatMove 6s ease-in-out infinite;
        }
        
        .float-dot.dot-1 {
            top: 20%;
            left: 10%;
            animation-delay: 0s;
            animation-duration: 6s;
        }
        
        .float-dot.dot-2 {
            top: 60%;
            right: 15%;
            animation-delay: -2s;
            animation-duration: 8s;
        }
        
        .float-dot.dot-3 {
            bottom: 30%;
            left: 20%;
            animation-delay: -4s;
            animation-duration: 7s;
        }
        
        .float-dot.dot-4 {
            top: 40%;
            right: 25%;
            animation-delay: -1s;
            animation-duration: 5s;
        }
        
        @keyframes floatMove {
            0%, 100% {
                transform: translate(0, 0) scale(1);
                opacity: 0.6;
            }
            25% {
                transform: translate(10px, -15px) scale(1.2);
                opacity: 0.8;
            }
            50% {
                transform: translate(-5px, -25px) scale(0.8);
                opacity: 0.4;
            }
            75% {
                transform: translate(15px, -10px) scale(1.1);
                opacity: 0.7;
            }
        }
        
        /* ✨ HOVER EFFECT ✨ */
        .artistic-quote:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 
                0 12px 40px rgba(0, 0, 0, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
        }
        
        .artistic-quote:hover .quote-icon {
            transform: scale(1.1) rotate(5deg);
        }
        
        .artistic-quote:hover .float-dot {
            animation-duration: 3s;
        }
    </style>
</head>
<body>
    <div class="bg-scene" aria-hidden="true">
        <span class="bg-blob blob-1"></span>
        <span class="bg-blob blob-2"></span>
        <span class="bg-grid"></span>
    </div>
    <div class="login-container">
        <div class="login-card">
            <!-- Login Header -->
            <div class="login-header">
                <div class="d-flex justify-content-end mb-2">
                    <!-- Theme toggle button -->
                    <button id="theme-toggle" class="theme-toggle" aria-label="Toggle theme" title="Toggle light/dark mode"
                        style="background: transparent; border: 1px solid rgba(255,255,255,0.3); border-radius: 50%; width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,0.8); transition: all 0.3s ease; cursor: pointer;">
                        <i class="bi bi-sun-fill" style="font-size: 12px;"></i>
                    </button>
                </div>
                <i class="bi bi-mortarboard-fill"></i>
                <h2>Course Management</h2>
                <p>Welcome back! Please sign in to continue</p>
            </div>
            
            <!-- Login Form -->
            <div class="login-body">
                <!-- Display error messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <!-- Display success messages -->
                <c:if test="${param.message == 'logged_out'}">
                    <div class="alert alert-success" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        You have been logged out successfully.
                    </div>
                </c:if>
                
                <!-- Login Form -->
                <form method="post" action="${pageContext.request.contextPath}/login">
                    <!-- Hidden redirect parameter -->
                    <c:if test="${not empty param.redirect}">
                        <input type="hidden" name="redirect" value="${param.redirect}">
                    </c:if>
                    
                    <!-- Username Field -->
                    <div class="form-floating">
                        <input type="text" 
                               class="form-control" 
                               id="username" 
                               name="username" 
                               placeholder=" "
                               value="${not empty username ? username : ''}"
                               required 
                               autofocus>
                        <label for="username">
                            <i class="bi bi-person me-2"></i>Username
                        </label>
                    </div>
                    
                    <!-- Password Field -->
                    <div class="form-floating">
                        <input type="password" 
                               class="form-control" 
                               id="password" 
                               name="password" 
                               placeholder=" "
                               required>
                        <label for="password">
                            <i class="bi bi-lock me-2"></i>Password
                        </label>
                    </div>
                    
                    <!-- Login Button -->
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-login">
                            <i class="bi bi-box-arrow-in-right me-2"></i>
                            Sign In
                        </button>
                    </div>
                </form>
                
                <!-- Artistic Quote Section -->
                <div class="demo-credentials artistic-quote">
                    <div class="quote-content">
                        <div class="quote-icon">
                            <i class="bi bi-lightbulb-fill"></i>
                        </div>
                        <blockquote class="quote-text">
                            "Education is the most powerful weapon which you can use to change the world"
                        </blockquote>
                        <div class="quote-author">
                            — Nelson Mandela
                        </div>
                        <div class="floating-elements">
                            <span class="float-dot dot-1"></span>
                            <span class="float-dot dot-2"></span>
                            <span class="float-dot dot-3"></span>
                            <span class="float-dot dot-4"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Premium Login Page Interactions
        document.addEventListener('DOMContentLoaded', function() {
            const usernameField = document.getElementById('username');
            const passwordField = document.getElementById('password');
            const loginCard = document.querySelector('.login-card');
            const form = document.querySelector('form');
            const submitBtn = form.querySelector('button[type="submit"]');
            const bgScene = document.querySelector('.bg-scene');
            
            // Subtle parallax tilt on the card
            loginCard.addEventListener('mousemove', function(e) {
                const rect = loginCard.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                const rotateX = (y - rect.height / 2) / (rect.height / 2) * -3;
                const rotateY = (x - rect.width / 2) / (rect.width / 2) * 3;
                loginCard.style.transform = `translateY(-4px) perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
            });
            loginCard.addEventListener('mouseleave', function() {
                loginCard.style.transform = '';
            });
            
            // Dynamic spotlight following cursor
            const updateSpotlight = (clientX, clientY) => {
                const vw = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
                const vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
                const xPerc = (clientX / vw) * 100;
                const yPerc = (clientY / vh) * 100;
                if (bgScene) {
                    bgScene.style.setProperty('--spot-x', xPerc + '%');
                    bgScene.style.setProperty('--spot-y', yPerc + '%');
                }
            };
            // Smooth spotlight motion
            let spotX = window.innerWidth / 2;
            let spotY = window.innerHeight / 2;
            let targetX = spotX;
            let targetY = spotY;
            const lerp = (a, b, t) => a + (b - a) * t;
            const animateSpot = () => {
                spotX = lerp(spotX, targetX, 0.12);
                spotY = lerp(spotY, targetY, 0.12);
                updateSpotlight(spotX, spotY);
                requestAnimationFrame(animateSpot);
            };
            animateSpot();
            document.addEventListener('pointermove', (e) => {
                targetX = e.clientX;
                targetY = e.clientY;
            });
            
            // Auto-focus with smooth animation
            if (!usernameField.value) {
                setTimeout(() => {
                usernameField.focus();
                }, 300);
            }
            
            // Add floating label animation enhancements
            [usernameField, passwordField].forEach(field => {
                field.addEventListener('focus', function() {
                    this.parentElement.classList.add('focused');
                });
                
                field.addEventListener('blur', function() {
                    if (!this.value) {
                        this.parentElement.classList.remove('focused');
                    }
                });
                
                // Check if field has value on load
                if (field.value) {
                    field.parentElement.classList.add('focused');
                }
            });
            
            // Enhanced form submission with meaningful loading animation
            form.addEventListener('submit', function(e) {
                // Add loading class for our custom animation
                submitBtn.classList.add('loading');
                submitBtn.disabled = true;

                // Set the button text. The CSS will handle the animation.
                submitBtn.innerHTML = 'Signing In...';

                // Directly find and remove any spinner Bootstrap might add
                const spinner = submitBtn.querySelector('.spinner-border');
                if (spinner) {
                    spinner.remove();
                }
            });
            
            // Add credential click-to-fill functionality
            document.querySelectorAll('.credential-item code').forEach(codeElement => {
                codeElement.addEventListener('click', function() {
                    const text = this.textContent;
                    const parentItem = this.closest('.credential-item');
                    const isPassword = text === 'password123';
                    
                    if (isPassword) {
                        passwordField.value = text;
                        passwordField.focus();
                        passwordField.parentElement.classList.add('focused');
                    } else {
                        usernameField.value = text;
                        usernameField.focus();
                        usernameField.parentElement.classList.add('focused');
                        // Auto-focus password field after username
                        setTimeout(() => {
                            passwordField.focus();
                        }, 200);
                    }
                    
                    // Add visual feedback
                    this.style.transform = 'scale(1.1)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
                
                // Add hover tooltip effect
                codeElement.title = 'Click to fill field';
                codeElement.style.cursor = 'pointer';
            });
            
            // Add keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                // Alt + 1, 2, 3 for quick credential fill
                if (e.altKey) {
                    const credentialSets = [
                        { username: 'admin', password: 'password123' },
                        { username: 'teacher1', password: 'password123' },
                        { username: 'student1', password: 'password123' }
                    ];
                    
                    const keyIndex = parseInt(e.key) - 1;
                    if (keyIndex >= 0 && keyIndex < credentialSets.length) {
                        e.preventDefault();
                        const creds = credentialSets[keyIndex];
                        usernameField.value = creds.username;
                        passwordField.value = creds.password;
                        usernameField.parentElement.classList.add('focused');
                        passwordField.parentElement.classList.add('focused');
                        
                        // Add visual feedback to card
                        loginCard.style.transform = 'scale(1.02)';
                        setTimeout(() => {
                            loginCard.style.transform = '';
                        }, 200);
                    }
                }
            });
            
            // Add smooth entrance animation for demo credentials
            const demoCredentials = document.querySelector('.demo-credentials');
            setTimeout(() => {
                demoCredentials.style.opacity = '0';
                demoCredentials.style.transform = 'translateY(20px)';
                demoCredentials.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                
                setTimeout(() => {
                    demoCredentials.style.opacity = '1';
                    demoCredentials.style.transform = 'translateY(0)';
                }, 400);
            }, 100);
        });
        
        // Add CSS for sophisticated loading animation
        const style = document.createElement('style');
        style.textContent = `
            .form-floating.focused label {
                color: var(--accent-primary) !important;
                font-weight: 600 !important;
            }
            
            .btn-login.loading {
                cursor: not-allowed !important;
                background: linear-gradient(135deg, var(--accent-primary), var(--accent-hover), #8b5cf6, var(--accent-hover), var(--accent-primary)) !important;
                background-size: 400% 400% !important;
                animation: loading-gradient 3s ease infinite !important;
                box-shadow: 0 4px 15px rgba(var(--accent-primary-rgb), 0.3) !important;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
            }

            /* This will hide any unwanted spinner from Bootstrap */
            .btn-login.loading .spinner-border {
                display: none !important;
            }

            @keyframes loading-gradient {
                0% { background-position: 0% 50%; }
                50% { background-position: 100% 50%; }
                100% { background-position: 0% 50%; }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
