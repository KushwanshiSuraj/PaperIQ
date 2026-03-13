<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Integer totalQuestions = (Integer) request.getAttribute("totalQuestions");
    int[] levelCounts = (int[]) request.getAttribute("levelCounts");
    
    String fullName = (String) session.getAttribute("full_name");
    if(fullName == null) fullName = "Admin";
    
    // Default values if attributes are missing
    if(totalQuestions == null) totalQuestions = 0;
    if(levelCounts == null) levelCounts = new int[7];
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="container">
        <div class="nav-bar">
            <div style="font-weight: 700; font-size: 1.5rem;">📄 PaperIQ</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/dashboard" class="active">🏠 Dashboard</a>
                <a href="<%= request.getContextPath() %>/admin/questions.jsp">📋 Question Bank</a>
                <a href="<%= request.getContextPath() %>/paper-history">📊 Paper History</a>
                <a href="<%= request.getContextPath() %>/paper-generator.jsp">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout-confirm.jsp" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <div class="glass-card fade-in">
            <h1>Admin Dashboard</h1>
            <p style="font-size: 1.2rem;">Welcome back, <strong><%= fullName %></strong>!</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📋</div>
                <div class="stat-number"><%= totalQuestions %></div>
                <div class="stat-label">Total Questions</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">📊</div>
                <div class="stat-number">6</div>
                <div class="stat-label">Bloom Levels</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-number">2</div>
                <div class="stat-label">User Roles</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">📄</div>
                <div class="stat-number">∞</div>
                <div class="stat-label">Papers Generated</div>
            </div>
        </div>
        
        <div class="glass-card" style="margin-top: 30px;">
            <h2>Questions per Bloom Level</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap; gap: 15px; margin: 30px 0;">
                <div style="text-align: center;">
                    <div style="font-size: 2rem; font-weight: bold; color: #4361ee;"><%= levelCounts[1] %></div>
                    <div>Remember</div>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 2rem; font-weight: bold; color: #4cc9f0;"><%= levelCounts[2] %></div>
                    <div>Understand</div>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 2rem; font-weight: bold; color: #06d6a0;"><%= levelCounts[3] %></div>
                    <div>Apply</div>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 2rem; font-weight: bold; color: #ffd166;"><%= levelCounts[4] %></div>
                    <div>Analyze</div>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 2rem; font-weight: bold; color: #ef476f;"><%= levelCounts[5] %></div>
                    <div>Evaluate</div>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 2rem; font-weight: bold; color: #9c89b8;"><%= levelCounts[6] %></div>
                    <div>Create</div>
                </div>
            </div>
        </div>
        
        <div style="display: flex; gap: 20px; justify-content: center; margin: 40px 0;">
            <a href="<%= request.getContextPath() %>/admin/questions.jsp" class="btn btn-primary btn-lg">📋 Manage Questions</a>
            <a href="<%= request.getContextPath() %>/paper-generator.jsp" class="btn btn-success btn-lg">📄 Generate Paper</a>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (Enrollment No: 2351352563, BCA, IGNOU) </small>
        </div>
    </div>
</body>
</html>