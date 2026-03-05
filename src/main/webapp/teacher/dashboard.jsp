<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String basePath = request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Teacher Dashboard</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f0f2f5; }
        .container { max-width: 1200px; margin: auto; }
        .header { background: #2196F3; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .nav { background: white; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .nav a { margin-right: 20px; text-decoration: none; color: #2196F3; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .welcome { font-size: 18px; margin-bottom: 20px; }
        .logout { float: right; background: #f44336; color: white; padding: 8px 15px; border-radius: 4px; text-decoration: none; }
        .note { background: #fff3cd; color: #856404; padding: 10px; border-radius: 4px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📄 PaperIQ - Teacher Dashboard</h1>
            <a href="<%= basePath %>logout.jsp" class="logout">Logout</a>
        </div>
        
        <div class="nav">
            <a href="dashboard.jsp">🏠 Dashboard</a>
            <a href="<%= basePath %>view-questions.jsp">📋 View Questions</a>
            <a href="<%= basePath %>paper-generator.jsp">📄 Generate Paper</a>
        </div>
        
        <div class="card">
            <div class="welcome">
                Welcome, <strong><%= session.getAttribute("full_name") %></strong> (Teacher)
            </div>
            
            <div class="note">
                ⚠️ You have read-only access. You can view questions and generate papers but cannot add/edit/delete.
            </div>
            
            <h3>Teacher Controls:</h3>
            <ul>
                <li>👁️ View Question Bank (Read-only)</li>
                <li>📄 Generate question papers</li>
                <li>📥 Download PDF papers</li>
            </ul>
            
            <p>
                <a href="<%= basePath %>view-questions.jsp" style="background: #2196F3; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">View Questions</a>
                <a href="<%= basePath %>paper-generator.jsp" style="background: #FF9800; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; margin-left: 10px;">Generate Paper</a>
            </p>
        </div>
    </div>
    <!-- Footer -->
<div style="text-align: center; margin-top: 50px; padding: 20px; color: #666; font-size: 12px; border-top: 1px solid #ddd;">
    <small>
        PaperIQ © 2026 - Automated Question Paper System<br>
        Developed by: <strong>Suraj Kumar</strong> <br>
        BCA, IGNOU 
    </small>
</div>
</body>
</html>