<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/paperiq.css">
</head>
<body>
    <div class="login-container fade-in">
        <div class="login-header">
            <h1>📄 PaperIQ</h1>
            <p style="color: white; opacity: 0.9;">Automated Question Paper Generator</p>
        </div>
        
        <div class="login-card">
            <h2 style="text-align: center; border-bottom: none; margin-bottom: 30px;">Welcome Back</h2>
            
            <%
                String error = (String) request.getAttribute("error");
                String msg = request.getParameter("msg");
                if(error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>
            
            <% if(msg != null && msg.equals("loggedout")) { %>
                <div class="alert alert-success">✅ You have been successfully logged out!</div>
            <% } %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">👤 Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">🔒 Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%;">Login</button>
            </form>
            
            <div style="text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
                <p style="color: var(--gray); font-size: 14px;">
                    Demo Credentials:<br>
                    <strong>Admin:</strong> admin • <strong>Teacher:</strong> teacher
                </p>
            </div>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (BCA, IGNOU) </small>
        </div>
    </div>
</body>
</html>