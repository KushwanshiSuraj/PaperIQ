<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.paperiq.model.Paper, com.paperiq.dao.PaperDAO" %>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String role = (String) session.getAttribute("role");
    PaperDAO paperDAO = new PaperDAO();
    List<Paper> papers;
    
    if("admin".equals(role)) {
        papers = paperDAO.getAllPapers();
    } else {
        papers = paperDAO.getPapersByUser((Integer)session.getAttribute("user_id"));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Paper History</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="container">
        <div class="nav-bar">
            <div style="font-weight: 700; font-size: 1.5rem;">📄 PaperIQ</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/dashboard">🏠 Dashboard</a>
                <% if("admin".equals(role)) { %>
                    <a href="<%= request.getContextPath() %>/admin/questions.jsp">📋 Question Bank</a>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/view-questions.jsp">📋 View Questions</a>
                <% } %>
                <a href="<%= request.getContextPath() %>/paper-history" class="active">📊 Paper History</a>
                <a href="<%= request.getContextPath() %>/paper-generator.jsp">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout-confirm.jsp" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <div class="glass-card">
            <h1>📊 Paper History</h1>
            
            <% if(papers.isEmpty()) { %>
                <div class="alert alert-info">No papers generated yet.</div>
            <% } else { %>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Paper ID</th>
                                <th>Teacher</th>
                                <th>Topic</th>
                                <th>Total Marks</th>
                                <th>Distribution</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Paper p : papers) { %>
                            <tr>
                                <td><%= p.getPaperId() %></td>
                                <td><%= p.getUsername() %></td>
                                <td><%= p.getTopic() %></td>
                                <td><%= p.getTotalMarks() %></td>
                                <td>R<%= p.getRememberMarks() %> U<%= p.getUnderstandMarks() %> Ap<%= p.getApplyMarks() %> An<%= p.getAnalyzeMarks() %> E<%= p.getEvaluateMarks() %> C<%= p.getCreateMarks() %></td>
                                <td><%= p.getGeneratedDate() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (Enrollment No: 2351352563, BCA, IGNOU) </small>
        </div>
    </div>
</body>
</html>