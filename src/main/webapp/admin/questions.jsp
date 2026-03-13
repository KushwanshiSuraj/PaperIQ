<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.paperiq.model.Question, com.paperiq.dao.QuestionDAO" %>
<%
    // Check if user is logged in as admin
    if(session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Load questions directly
    QuestionDAO qdao = new QuestionDAO();
    List<Question> questions = null;
    try {
        questions = qdao.getAllQuestions();
    } catch(Exception e) {
        System.out.println("Error loading questions: " + e.getMessage());
        e.printStackTrace();
    }
    
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Manage Questions</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="container">
        <div class="nav-bar">
            <div style="font-weight: 700; font-size: 1.5rem;">📄 PaperIQ</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/dashboard">🏠 Dashboard</a>
                <a href="<%= request.getContextPath() %>/admin/questions.jsp" class="active">📋 Question Bank</a>
                <a href="<%= request.getContextPath() %>/paper-history">📊 Paper History</a>
                <a href="<%= request.getContextPath() %>/paper-generator.jsp">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout-confirm.jsp" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <div class="glass-card">
            <h1>📋 Manage Question Bank</h1>
            
            <% if("added".equals(msg)) { %>
                <div class="alert alert-success">✅ Question added successfully!</div>
            <% } else if("updated".equals(msg)) { %>
                <div class="alert alert-success">✅ Question updated successfully!</div>
            <% } else if("deleted".equals(msg)) { %>
                <div class="alert alert-success">✅ Question deleted successfully!</div>
            <% } else if(error != null) { %>
                <div class="alert alert-danger">❌ Error: <%= error %></div>
            <% } %>
            
            <div style="margin: 20px 0;">
                <a href="<%= request.getContextPath() %>/add-question.jsp" class="btn btn-success">➕ Add New Question</a>
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
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(questions != null && !questions.isEmpty()) { 
                            for(Question q : questions) { 
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
                            <td>
                                <a href="<%= request.getContextPath() %>/edit-question?id=<%= q.getQuestionId() %>" class="btn btn-primary btn-sm">Edit</a>
                                <a href="<%= request.getContextPath() %>/delete-question?id=<%= q.getQuestionId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this question?')">Delete</a>
                            </td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 30px;">
                                No questions found. Click "Add New Question" to create one.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (Enrollment No: 2351352563, BCA, IGNOU) </small>
        </div>
    </div>
</body>
</html>