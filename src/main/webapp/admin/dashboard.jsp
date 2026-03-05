<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is admin
    if(session.getAttribute("user_id") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String basePath = request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Admin Dashboard</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f0f2f5; }
        .container { max-width: 1200px; margin: auto; }
        .header { background: #4CAF50; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .nav { background: white; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .nav a { margin-right: 20px; text-decoration: none; color: #4CAF50; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .welcome { font-size: 18px; margin-bottom: 20px; }
        .logout { float: right; background: #f44336; color: white; padding: 8px 15px; border-radius: 4px; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📄 PaperIQ - Admin Dashboard</h1>
            <a href="<%= basePath %>logout.jsp" class="logout">Logout</a>
        </div>
        
        <div class="nav">
            <a href="dashboard.jsp">🏠 Dashboard</a>
            <a href="<%= basePath %>questions.jsp">📋 Question Bank</a>
            <!--   ><a href="users.jsp">👥 Manage Users</a> -->
            <a href="<%= basePath %>paper-generator.jsp">📄 Generate Paper</a>
        </div>
        
        <div class="card">
            <div class="welcome">
                Welcome, <strong><%= session.getAttribute("full_name") %></strong> (Administrator)
            </div>
            
            <h3>Admin Controls:</h3>
            <ul>
                <li>✅ Full access to Question Bank (Add/Edit/Delete)</li>
                <li>✅ Generate question papers</li>
                <li>✅ Manage Users</li>
            </ul>
            
            <p>
                <a href="<%= basePath %>questions.jsp" style="background: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">Go to Question Bank</a>
                <a href="<%= basePath %>paper-generator.jsp" style="background: #FF9800; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; margin-left: 10px;">Generate Paper</a>
            </p>
        </div>
    </div>
    <!-- Footer -->
<div style="text-align: center; margin-top: 50px; padding: 20px; color: #666; font-size: 12px; border-top: 1px solid #ddd;">
    <small>
        PaperIQ © 2026 - Automated Question Paper System<br>
        Developed by: <strong>Suraj Kumar</strong> <br>
        BCA, IGNOU |
    </small>
</div>
</body>
</html>