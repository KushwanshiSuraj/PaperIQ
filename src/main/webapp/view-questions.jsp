<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.paperiq.model.Question, com.paperiq.dao.QuestionDAO" %>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    QuestionDAO qdao = new QuestionDAO();
    List<Question> questions = qdao.getAllQuestions();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - View Questions</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="container">
        <div class="nav-bar">
            <div style="font-weight: 700; font-size: 1.5rem;">📄 PaperIQ</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/dashboard">🏠 Dashboard</a>
                <a href="<%= request.getContextPath() %>/view-questions.jsp" class="active">📋 View Questions</a>
                <a href="<%= request.getContextPath() %>/paper-history">📊 Paper History</a>
                <a href="<%= request.getContextPath() %>/paper-generator.jsp">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout-confirm.jsp" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <div class="glass-card">
            <h1>📋 Question Bank (Read Only)</h1>
            
            <div class="alert alert-info">
                👁️ You are in <strong>read-only mode</strong>. You can view questions but cannot add, edit, or delete them.
            </div>
            
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Question</th>
                            <th>Bloom Level</th>
                            <th>Topic</th>
                            <th>Marks</th>
                            <th>Difficulty</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Question q : questions) { 
                            String badgeClass = q.getDifficulty().equals("Easy") ? "badge-success" : 
                                              (q.getDifficulty().equals("Medium") ? "badge-warning" : "badge-danger");
                        %>
                        <tr>
                            <td><%= q.getQuestionId() %></td>
                            <td><%= q.getQuestionText() %></td>
                            <td><span class="badge badge-primary"><%= q.getLevelName() %></span></td>
                            <td><%= q.getTopic() %></td>
                            <td><%= q.getMarks() %></td>
                            <td><span class="badge <%= badgeClass %>"><%= q.getDifficulty() %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (Enrollment No: 2351352563, BCA, IGNOU)</small>
        </div>
    </div>
</body>
</html>