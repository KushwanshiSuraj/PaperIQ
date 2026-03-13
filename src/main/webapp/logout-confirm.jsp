<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout - PaperIQ</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="login-container">
        <div class="login-card" style="text-align: center;">
            <h2 style="color: var(--primary);">📄 PaperIQ</h2>
            <p style="font-size: 1.2rem; margin: 30px 0;">Are you sure you want to logout?</p>
            
            <div style="display: flex; gap: 20px; justify-content: center;">
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger btn-lg">✅ Yes, Logout</a>
                <a href="javascript:history.back()" class="btn btn-primary btn-lg">❌ No, Stay</a>
            </div>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar </small>
        </div>
    </div>
</body>
</html>