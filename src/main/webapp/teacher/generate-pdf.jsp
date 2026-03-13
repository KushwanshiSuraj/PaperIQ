<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.paperiq.dao.QuestionDAO, com.paperiq.model.Question, java.util.List" %>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String topic = request.getParameter("topic");
    int totalMarks = Integer.parseInt(request.getParameter("totalMarks"));
    int rememberPct = Integer.parseInt(request.getParameter("rememberPct"));
    int understandPct = Integer.parseInt(request.getParameter("understandPct"));
    int applyPct = Integer.parseInt(request.getParameter("applyPct"));
    int analyzePct = Integer.parseInt(request.getParameter("analyzePct"));
    int evaluatePct = Integer.parseInt(request.getParameter("evaluatePct"));
    int createPct = Integer.parseInt(request.getParameter("createPct"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Generate PDF</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="container">
        <div class="nav-bar">
            <div style="font-weight: 700; font-size: 1.5rem;">📄 PaperIQ</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/dashboard">🏠 Dashboard</a>
                <a href="<%= request.getContextPath() %>/view-questions.jsp">📋 View Questions</a>
                <a href="<%= request.getContextPath() %>/paper-history">📊 Paper History</a>
                <a href="<%= request.getContextPath() %>/paper-generator.jsp" class="active">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <div class="glass-card">
            <h1>📄 Generate PDF</h1>
            
            <div style="background: white; padding: 30px; border-radius: var(--border-radius);">
                <form action="<%= request.getContextPath() %>/generate-pdf" method="post" target="_blank">
                    <input type="hidden" name="topic" value="<%= topic %>">
                    <input type="hidden" name="totalMarks" value="<%= totalMarks %>">
                    <input type="hidden" name="rememberPct" value="<%= rememberPct %>">
                    <input type="hidden" name="understandPct" value="<%= understandPct %>">
                    <input type="hidden" name="applyPct" value="<%= applyPct %>">
                    <input type="hidden" name="analyzePct" value="<%= analyzePct %>">
                    <input type="hidden" name="evaluatePct" value="<%= evaluatePct %>">
                    <input type="hidden" name="createPct" value="<%= createPct %>">
                    
                    <div style="text-align: center; margin: 30px 0;">
                        <p><strong>Topic:</strong> <%= topic %></p>
                        <p><strong>Total Marks:</strong> <%= totalMarks %></p>
                        <p><strong>Distribution:</strong> R<%= rememberPct %>% | U<%= understandPct %>% | Ap<%= applyPct %>% | An<%= analyzePct %>% | E<%= evaluatePct %>% | C<%= createPct %>%</p>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">📥 Download PDF</button>
                </form>
                
                <div style="text-align: center; margin-top: 20px;">
                    <a href="<%= request.getContextPath() %>/paper-generator.jsp" class="btn btn-secondary">⬅️ Back to Generator</a>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (BCA, IGNOU)</small>
        </div>
    </div>
</body>
</html>